# Experiments

This document defines product experiments for the Nawah Token ecosystem.
Experiments are used to validate decisions through data, not assumptions.

---

## Experiment 001 – Initiative Creation Flow (Placeholder)

**Status:** Planned (Not Active)

### Hypothesis
Reducing the number of required fields in the initiative creation form will increase the initiative creation rate.

### Change
Compare:
- Version A: Full initiative form
- Version B: Simplified initiative form

### Event
initiative_created

### Metric
Initiative Creation Rate  
(initiative_created / unique_users)

### Decision Rule
If Version B improves the Initiative Creation Rate by **at least 15%** over a 7-day period, adopt the simplified form.

---

## Experiment 002 – Wallet Connection Flow (Placeholder)

**Status:** Planned (Not Active)

### Hypothesis
Simplifying the wallet connection flow and clarifying its purpose will increase the wallet connection rate.

### Change
Compare:
- Version A: Standard wallet connection prompt
- Version B: Simplified wallet connection with clear explanation of benefits (why wallet is needed)

### Event
wallet_connected

### Metric
Wallet Connection Rate  
(wallet_connected / unique_users)

### Decision Rule
If Version B improves the Wallet Connection Rate by **at least 10%** over a 7-day period, adopt the simplified flow.

---

## Notes
- All experiments start as Planned (Not Active).
- No experiment should be activated without stable traffic and metrics.
- Experiments must reference events defined in EVENTS.md.
