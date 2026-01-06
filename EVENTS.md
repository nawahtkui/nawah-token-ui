# Event Naming Convention

This document defines the official event naming convention used across the Nawah Token ecosystem.
All analytics, metrics, and experiments must reference these events exactly as defined here.

---

## Naming Rules
- lowercase only
- words separated by underscore `_`
- verb_object format
- clear business meaning
- no UI-specific or technical terms

Format:
[action]_[object]

---

## Core Events (Must-Have)

### initiative_created
Triggered when a user successfully creates a new initiative.
This is the primary value event for the Nawah ecosystem.

### wallet_connected
Triggered when a user connects a Web3 wallet.
Indicates readiness for decentralized interaction.

### flow_completed
Triggered when a user completes a core user flow (e.g., form submission or onboarding).

---

## Secondary Events

### initiative_viewed
Triggered when a user views an initiative page.

### initiative_supported
Triggered when a user interacts positively with an initiative (support, contribution, or endorsement).

---

## Notes
- Do not create new events without updating this file.
- Events must be logged only for meaningful actions.
- Logs, page views, and debugging actions should not be tracked as events.

---

Last updated: 2026
