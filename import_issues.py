#!/usr/bin/env python3
import argparse, json, os, re, sys, time
from typing import Dict, List, Optional, Tuple
import requests

GITHUB_API = "https://api.github.com"

PRIORITY_MILESTONES = [
    "Low-Lift Starters",
    "Next Higher-Impact Set",
    "Phase 2 / Advanced",
    "Phase 3 / Differentiators & ML",
]

# Fallback milestone for anything not explicitly listed under a tier
DEFAULT_MILESTONE = "Backlog"

# Label prefixes
PRIORITY_LABEL_PREFIX = "priority: "
CATEGORY_LABEL_PREFIX = ""

ISSUE_BODY_TEMPLATE = """\
### Feature
{feature}

**Category:** {category}
**Priority:** {priority}

**Why**
- _What user problem does this solve?_

**What (Acceptance Criteria)**
- [ ] Basic flow works end-to-end
- [ ] Telemetry added (success/failure)
- [ ] Edge cases documented

**Notes**
- Source: FeatureIdeas.md
"""

def gh_get(session: requests.Session, url: str):
    r = session.get(url)
    r.raise_for_status()
    return r.json()

def gh_post(session: requests.Session, url: str, payload: dict):
    r = session.post(url, json=payload)
    r.raise_for_status()
    return r.json()

def gh_patch(session: requests.Session, url: str, payload: dict):
    r = session.patch(url, json=payload)
    r.raise_for_status()
    return r.json()

def ensure_labels(session: requests.Session, repo: str, labels: List[str], dry_run: bool):
    existing = {}
    url = f"{GITHUB_API}/repos/{repo}/labels?per_page=100"
    # paginate
    while url:
        r = session.get(url)
        r.raise_for_status()
        for lab in r.json():
            existing[lab["name"]] = True
        url = r.links.get("next", {}).get("url")

    created = []
    for name in labels:
        if name in existing:
            continue
        if dry_run:
            created.append(name)
        else:
            gh_post(session, f"{GITHUB_API}/repos/{repo}/labels", {"name": name})
            created.append(name)
    return created

def ensure_milestone(session: requests.Session, repo: str, title: str, dry_run: bool) -> Optional[int]:
    # Try to find existing milestone by title
    url = f"{GITHUB_API}/repos/{repo}/milestones?state=all&per_page=100"
    while url:
        r = session.get(url)
        r.raise_for_status()
        for m in r.json():
            if m["title"] == title:
                return m["number"]
        url = r.links.get("next", {}).get("url")
    # Create if not found
    if dry_run:
        return None
    m = gh_post(session, f"{GITHUB_API}/repos/{repo}/milestones", {"title": title})
    return m["number"]

def ensure_all_milestones(session: requests.Session, repo: str, dry_run: bool) -> Dict[str, Optional[int]]:
    numbers = {}
    for title in PRIORITY_MILESTONES + [DEFAULT_MILESTONE]:
        numbers[title] = ensure_milestone(session, repo, title, dry_run)
    return numbers

def parse_markdown(md_text: str) -> Tuple[List[Tuple[str,str]], Dict[str, List[str]]]:
    """
    Returns:
      features: list of (category, feature)
      tiers: dict of tier_title -> list of feature titles appearing under that tier
    """
    # 1) Prefer the JSON export block if present
    json_block = re.search(r"## JSON Export\s+```json\s+(?P<blob>\[.*?\])\s+```", md_text, re.DOTALL)
    features: List[Tuple[str,str]] = []
    if json_block:
        try:
            arr = json.loads(json_block.group("blob"))
            for row in arr:
                features.append((row["category"], row["feature"]))
        except Exception:
            pass

    # 2) If not found, fallback to CSV (very simple parse)
    if not features:
        csv_block = re.search(r"## CSV Export\s+```csv\s+(?P<blob>.*?)\s+```", md_text, re.DOTALL)
        if csv_block:
            lines = [ln.strip() for ln in csv_block.group("blob").splitlines() if ln.strip()]
            # skip header
            for ln in lines[1:]:
                # naive split (category, feature); feature may contain commas rarely, but your file is simple
                parts = ln.split(",", 1)
                if len(parts) == 2:
                    cat = parts[0].strip()
                    feat = parts[1].strip()
                    features.append((cat, feat))

    # 3) Parse Priority Tiers (map each tier to its bullet list items)
    tiers: Dict[str, List[str]] = {}
    tier_sections = {
        "Low-Lift Starters": r"### Low[\u2011\u2013\-]?Lift Starters.*?(?:(?=### )|\Z)",
        "Next Higher-Impact Set": r"### Next Higher[\u2011\u2013\-]?Impact Set.*?(?:(?=### )|\Z)",
        "Phase 2 / Advanced": r"### Phase 2 / Advanced.*?(?:(?=### )|\Z)",
        "Phase 3 / Differentiators & ML": r"### Phase 3 / Differentiators.*?(?:(?=### )|\Z)",
    }
    for title, pat in tier_sections.items():
        m = re.search(pat, md_text, re.DOTALL | re.IGNORECASE)
        items: List[str] = []
        if m:
            block = m.group(0)
            # capture markdown bullet items
            for b in re.findall(r"^\-\s+(.*)$", block, re.MULTILINE):
                # strip trailing parens and notes to match feature names
                clean = b.strip()
                items.append(clean)
        tiers[title] = items

    return features, tiers

def choose_priority(feature: str, tiers: Dict[str, List[str]]) -> str:
    for tier_name, items in tiers.items():
        for it in items:
            # Loose match: handle entries like "Multi-phase brew timer + Watch support"
            if feature.lower() in it.lower() or it.lower() in feature.lower():
                return tier_name
    return DEFAULT_MILESTONE

def iter_all_repo_issues(session: requests.Session, repo: str):
    """
    Yield all issues (open & closed) in the repository.
    Note: GitHub returns PRs in this endpoint too; we’ll skip those.
    """
    url = f"{GITHUB_API}/repos/{repo}/issues?state=all&per_page=100"
    while url:
        r = session.get(url)
        r.raise_for_status()
        batch = r.json()
        for it in batch:
            # PRs have "pull_request" field — skip them
            if "pull_request" in it:
                continue
            yield it
        url = r.links.get("next", {}).get("url")

def find_existing_issue(session: requests.Session, repo: str, title: str) -> Optional[int]:
    target = title.strip().lower()
    for it in iter_all_repo_issues(session, repo):
        if it.get("title", "").strip().lower() == target:
            return it.get("number")
    return None


def main():
    ap = argparse.ArgumentParser(description="Create GitHub Issues from FeatureIdeas.md")
    ap.add_argument("--repo", required=True, help="owner/repo")
    ap.add_argument("--token", required=True, help="GitHub personal access token with repo scope")
    ap.add_argument("--path", required=True, help="Path to FeatureIdeas.md")
    ap.add_argument("--assignee", default=None, help="GitHub username to assign (optional)")
    ap.add_argument("--dry-run", action="store_true", help="Preview without creating anything")
    args = ap.parse_args()

    with open(args.path, "r", encoding="utf-8") as f:
        md_text = f.read()

    features, tiers = parse_markdown(md_text)
    if not features:
        print("No features found in JSON or CSV export blocks. Aborting.", file=sys.stderr)
        sys.exit(1)

    session = requests.Session()
    session.headers.update({
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {args.token}",
        "X-GitHub-Api-Version": "2022-11-28"
    })

    # Prepare labels
    categories = sorted(set([c for c, _ in features]))
    priority_labels = [
        PRIORITY_LABEL_PREFIX + "low-lift",
        PRIORITY_LABEL_PREFIX + "next-set",
        PRIORITY_LABEL_PREFIX + "phase-2",
        PRIORITY_LABEL_PREFIX + "phase-3",
        PRIORITY_LABEL_PREFIX + "backlog",
    ]
    desired_labels = categories + priority_labels

    created_labels = ensure_labels(session, args.repo, desired_labels, args.dry_run)
    if created_labels:
        print(f"Created labels: {created_labels}")

    # Prepare milestones
    milestone_numbers = ensure_all_milestones(session, args.repo, args.dry_run)

    # Create/update issues
    for category, feature in features:
        title = feature  # use feature text as the Issue title
        priority = choose_priority(feature, tiers)
        milestone_no = milestone_numbers.get(priority)
        # map a priority label
        if priority == "Low-Lift Starters":
            plabel = PRIORITY_LABEL_PREFIX + "low-lift"
        elif priority == "Next Higher-Impact Set":
            plabel = PRIORITY_LABEL_PREFIX + "next-set"
        elif priority == "Phase 2 / Advanced":
            plabel = PRIORITY_LABEL_PREFIX + "phase-2"
        elif priority == "Phase 3 / Differentiators & ML":
            plabel = PRIORITY_LABEL_PREFIX + "phase-3"
        else:
            plabel = PRIORITY_LABEL_PREFIX + "backlog"

        labels = [CATEGORY_LABEL_PREFIX + category, plabel]
        body = ISSUE_BODY_TEMPLATE.format(
            feature=feature,
            category=category,
            priority=priority
        )

        existing = find_existing_issue(session, args.repo, title)
        if existing:
            print(f"[SKIP] Issue exists: #{existing} — {title}")
            continue

        payload = {"title": title, "body": body, "labels": labels}
        if milestone_no is not None:
            payload["milestone"] = milestone_no
        if args.assignee:
            payload["assignees"] = [args.assignee]

        if args.dry_run:
            print(f"[DRY-RUN] Would create issue: {title} | labels={labels} | milestone={priority}")
        else:
            created = gh_post(session, f"{GITHUB_API}/repos/{args.repo}/issues", payload)
            print(f"[CREATED] #{created['number']} {title}")
            time.sleep(0.2)  # tiny delay to be gentle on the API

if __name__ == "__main__":
    main()
