# Driplet Feature Ideas & Roadmap

Comprehensive collection of proposed features, grouped by category, with priority tiers and data export formats.

## Table of Contents
- [Core Brewing Enhancements](#core-brewing-enhancements)
- [Coffee Bag & Inventory](#coffee-bag--inventory)
- [Tasting & Scoring](#tasting--scoring)
- [Personalization & Retention](#personalization--retention)
- [Data & Analytics](#data--analytics)
- [Social & Sharing](#social--sharing)
- [Platform Integrations](#platform-integrations)
- [Discovery & Guidance](#discovery--guidance)
- [ML / Intelligence (Phase 2)](#ml--intelligence-phase-2)
- [Quality & Consistency Tools](#quality--consistency-tools)
- [Safety / Resilience](#safety--resilience)
- [Monetization (Optional)](#monetization-optional)
- [Delight / Differentiation](#delight--differentiation)
- [Technical Enablers](#technical-enablers)
- [Priority Tiers](#priority-tiers)
- [CSV Export](#csv-export)
- [JSON Export](#json-export)
- [Next Steps Suggestions](#next-steps-suggestions)

---
## Core Brewing Enhancements
- Advanced multi‑phase brew timer (bloom / pour segments / steep; haptics; Watch support)
- Brew templates & ratio calculator (auto water ⇄ coffee recalculation)
- Extraction insights (manual TDS / Brix input → strength estimation)
- Brew comparison (side‑by‑side variable diff & rating)
- Water temperature logging (future hardware integration hook)

## Coffee Bag & Inventory
- Inventory counts + low‑stock alerts
- Roast date aging tracker (rest period suggestions)
- Cost per cup & yield estimation
- Origin / processing metadata auto‑fill library
- Barcode / label OCR scan to prefill fields
- Green vs roasted bean tracking

## Tasting & Scoring
- Flavor wheel tag picker (structured taxonomy)
- Cupping score sheet (SCA style fields)
- AI tasting note suggestions (origin + process + history)
- Palate evolution graph over time

## Personalization & Retention
- Streaks (days brewed) & milestones (e.g. 100th brew)
- Smart time‑based brew reminders (learn usual brew window)
- Adaptive parameter suggestions (e.g. ratio / grind nudge)

## Data & Analytics
- Dashboard (favorite origins, average brew time, caffeine estimate)
- Variable impact correlation (grind size vs rating, ratio vs body)
- Data export: CSV / JSON / PDF brew log

## Social & Sharing
- Shareable brew card image (recipe + notes)
- Follow friends / optional public recipes
- Challenge modes (same bean, different method)

## Platform Integrations
- iCloud / CloudKit sync (multi‑device)
- Widgets (last brew summary, next bag to finish)
- Spotlight search (beans, brews, tags)
- Siri Shortcuts / App Intents (log brew, start timer, open template)
- Apple Watch companion (start / control timer, quick log)
- HealthKit caffeine logging (optional / privacy‑first)

## Discovery & Guidance
- Recipe marketplace (curated + community)
- Step‑by‑step guided brew mode (dynamic phase timers + instructions)
- Grind size calibration helper (reference images / burr dial notes)

## ML / Intelligence (Phase 2)
- Predict optimal ratio / time given historical ratings & bean attributes
- Anomaly detection (flag unusual extraction times / ratios)
- Taste note clustering (surface flavor profile trends)

## Quality & Consistency Tools
- Water chemistry profiles (hardness, alkalinity targets + suggestions)
- Roast progression logging (for home roasters)
- Bean rest readiness indicator (post‑roast rest window)

## Safety / Resilience
- Offline‑first sync queue
- Versioned edits / undo (brew & bag history diffs)

## Monetization (Optional)
- Free core + Pro tier: advanced analytics, comparisons, cloud recipe sync
- One‑time unlock for ML suggestions
- Tip jar / support dialog

## Delight / Differentiation
- AR ratio / pour volume visualizer (camera overlay)
- Haptic pour pacing metronome
- Time‑of‑day “brew mood” theme auto‑switch

## Technical Enablers
- Unified `BrewModel` with phases array (extensible for new methods)
- Tagging system (fast filter + Spotlight indexing)
- Persistence abstraction (Core Data now, future sync flexibility)
- AppIntents coverage for Shortcuts & widgets
- Unit tests for ratio math & inventory decrement logic

---
## Priority Tiers

### Low‑Lift Starters (Fast Wins)
- Brew templates & ratio calculator
- Inventory count + low stock badge
- Flavor tags quick‑add
- Shareable brew summary card
- iCloud sync toggle (basic CloudKit wiring)
- Last brew widget

### Next Higher‑Impact Set
- Multi‑phase brew timer + Watch support
- Analytics dashboard (core metrics)
- Barcode / OCR prefill for coffee bags
- Siri Shortcut intents (log brew, start timer)

### Phase 2 / Advanced
- Variable impact correlation analytics
- Water chemistry profiles
- Guided brew mode with dynamic instructions
- AI tasting note suggestion

### Phase 3 / Differentiators & ML
- Predictive ratio/time recommendations
- Anomaly detection (brew outliers)
- Taste note clustering visualization
- AR pour volume visualizer

---
## CSV Export
```csv
Category,Feature
Core Brewing,Advanced multi-phase brew timer
Core Brewing,Brew templates & ratio calculator
Core Brewing,Extraction insights (TDS/Brix)
Core Brewing,Brew comparison
Core Brewing,Water temperature logging
Inventory,Inventory counts + low-stock alerts
Inventory,Roast date aging tracker
Inventory,Cost per cup & yield estimation
Inventory,Origin/processing auto-fill
Inventory,Barcode/OCR scan
Inventory,Green vs roasted tracking
Tasting,Flavor wheel tag picker
Tasting,Cupping score sheet
Tasting,AI tasting note suggestions
Tasting,Palate evolution graph
Personalization,Streaks & milestones
Personalization,Smart reminders
Personalization,Adaptive suggestions
Analytics,Dashboard
Analytics,Variable impact correlation
Analytics,Data export
Social,Brew card sharing
Social,Follow & public recipes
Social,Challenge modes
Integrations,Cloud sync
Integrations,Widgets
Integrations,Spotlight search
Integrations,Siri Shortcuts
Integrations,Apple Watch companion
Integrations,HealthKit caffeine logging
Guidance,Recipe marketplace
Guidance,Guided brew mode
Guidance,Grind calibration helper
ML,Predict optimal ratio/time
ML,Anomaly detection
ML,Taste note clustering
Quality,Water chemistry profiles
Quality,Roast progression logging
Quality,Rest readiness indicator
Resilience,Offline-first sync
Resilience,Versioned edits
Monetization,Pro tier
Monetization,One-time ML unlock
Monetization,Tip jar
Delight,AR ratio visualizer
Delight,Haptic pour metronome
Delight,Brew mood theme
Enablers,Unified BrewModel
Enablers,Tagging system
Enablers,Persistence abstraction
Enablers,AppIntents coverage
Enablers,Ratio/inventory tests
Low-Lift,Brew templates
Low-Lift,Inventory badge
Low-Lift,Flavor tags quick-add
Low-Lift,Brew summary share card
Low-Lift,iCloud sync toggle
Low-Lift,Last brew widget
Next Set,Multi-phase timer + Watch
Next Set,Analytics dashboard
Next Set,Barcode/OCR prefill
Next Set,Siri Shortcut intents
```

## JSON Export
```json
[
  {"category": "Core Brewing", "feature": "Advanced multi-phase brew timer"},
  {"category": "Core Brewing", "feature": "Brew templates & ratio calculator"},
  {"category": "Core Brewing", "feature": "Extraction insights (TDS/Brix)"},
  {"category": "Core Brewing", "feature": "Brew comparison"},
  {"category": "Core Brewing", "feature": "Water temperature logging"},
  {"category": "Inventory", "feature": "Inventory counts + low-stock alerts"},
  {"category": "Inventory", "feature": "Roast date aging tracker"},
  {"category": "Inventory", "feature": "Cost per cup & yield estimation"},
  {"category": "Inventory", "feature": "Origin/processing auto-fill"},
  {"category": "Inventory", "feature": "Barcode/OCR scan"},
  {"category": "Inventory", "feature": "Green vs roasted tracking"},
  {"category": "Tasting", "feature": "Flavor wheel tag picker"},
  {"category": "Tasting", "feature": "Cupping score sheet"},
  {"category": "Tasting", "feature": "AI tasting note suggestions"},
  {"category": "Tasting", "feature": "Palate evolution graph"},
  {"category": "Personalization", "feature": "Streaks & milestones"},
  {"category": "Personalization", "feature": "Smart reminders"},
  {"category": "Personalization", "feature": "Adaptive suggestions"},
  {"category": "Analytics", "feature": "Dashboard"},
  {"category": "Analytics", "feature": "Variable impact correlation"},
  {"category": "Analytics", "feature": "Data export"},
  {"category": "Social", "feature": "Brew card sharing"},
  {"category": "Social", "feature": "Follow & public recipes"},
  {"category": "Social", "feature": "Challenge modes"},
  {"category": "Integrations", "feature": "Cloud sync"},
  {"category": "Integrations", "feature": "Widgets"},
  {"category": "Integrations", "feature": "Spotlight search"},
  {"category": "Integrations", "feature": "Siri Shortcuts"},
  {"category": "Integrations", "feature": "Apple Watch companion"},
  {"category": "Integrations", "feature": "HealthKit caffeine logging"},
  {"category": "Guidance", "feature": "Recipe marketplace"},
  {"category": "Guidance", "feature": "Guided brew mode"},
  {"category": "Guidance", "feature": "Grind calibration helper"},
  {"category": "ML", "feature": "Predict optimal ratio/time"},
  {"category": "ML", "feature": "Anomaly detection"},
  {"category": "ML", "feature": "Taste note clustering"},
  {"category": "Quality", "feature": "Water chemistry profiles"},
  {"category": "Quality", "feature": "Roast progression logging"},
  {"category": "Quality", "feature": "Rest readiness indicator"},
  {"category": "Resilience", "feature": "Offline-first sync"},
  {"category": "Resilience", "feature": "Versioned edits"},
  {"category": "Monetization", "feature": "Pro tier"},
  {"category": "Monetization", "feature": "One-time ML unlock"},
  {"category": "Monetization", "feature": "Tip jar"},
  {"category": "Delight", "feature": "AR ratio visualizer"},
  {"category": "Delight", "feature": "Haptic pour metronome"},
  {"category": "Delight", "feature": "Brew mood theme"},
  {"category": "Enablers", "feature": "Unified BrewModel"},
  {"category": "Enablers", "feature": "Tagging system"},
  {"category": "Enablers", "feature": "Persistence abstraction"},
  {"category": "Enablers", "feature": "AppIntents coverage"},
  {"category": "Enablers", "feature": "Ratio/inventory tests"},
  {"category": "Low-Lift", "feature": "Brew templates"},
  {"category": "Low-Lift", "feature": "Inventory badge"},
  {"category": "Low-Lift", "feature": "Flavor tags quick-add"},
  {"category": "Low-Lift", "feature": "Brew summary share card"},
  {"category": "Low-Lift", "feature": "iCloud sync toggle"},
  {"category": "Low-Lift", "feature": "Last brew widget"},
  {"category": "Next Set", "feature": "Multi-phase timer + Watch"},
  {"category": "Next Set", "feature": "Analytics dashboard"},
  {"category": "Next Set", "feature": "Barcode/OCR prefill"},
  {"category": "Next Set", "feature": "Siri Shortcut intents"}
]
```

---
## Next Steps Suggestions
1. Implement Low‑Lift Starter set (establishes core value & retention hooks).
2. Add unit tests for ratio calculations & inventory decrement early to lock behavior.
3. Introduce CloudKit sync behind a feature flag (safe rollout / fallback offline).
4. Ship multi‑phase timer + Watch to differentiate vs generic timer apps.
5. Layer analytics & adaptive suggestions once sufficient data density exists.

---
*This document is a living backlog; update statuses (Planned / In Progress / Done) as implementation proceeds.*
