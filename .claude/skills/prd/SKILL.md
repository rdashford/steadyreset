---
name: prd
description: Look up a Steady Reset PRD requirement by ID (E1, D4, R6, K15…) or a principle by section number and quote it with its acceptance criterion from docs/PRD.md. Use whenever a requirement ID is mentioned or when unsure what the spec says.
argument-hint: <requirement ID or section, e.g. R6 or 5.4>
---

Grep `docs/PRD.md` for the argument. For a requirement ID, print the full table row (ID, requirement, scope, acceptance criterion) and any principle it references. For a section number, print that section. If the ID is not found, list the nearest IDs in the same letter group. Never paraphrase the acceptance criterion; quote it.
