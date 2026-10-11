# Scalfagus: scale decisions and legacy compatibility
Date: 2026-10-11
Status: approved product goals, proposed implementation details.

## Three match scales
MIN aims for 20–40 minute matches, MID for 40–80 minute matches, MAX for open-ended Factorio / Transport Tycoon Deluxe-style simulation. These are target experiences rather than enforced clocks. Complexity should be progressively exposed, with routine logistics automated by default.

## Naming
Match scale (match_scale) is not unit chassis size (chassis_scale). Both may take min, mid or max, but they are independent dimensions.

## Prior decisions
Earlier standard 1v1 duration target of 25–40 minutes remains compatible with the wider MIN 20–40 minute range. The earlier worker autonomy limitation still applies to local workers; a distinct strategic planner can choose expansion when enabled. Full manual remains supported.

## LLM participation
Optional LLM partners, rivals and autonomous observer simulations are separate from match scale. Maintain scripted AI baseline and validated, replayable model actions.

## Recommended validation
Benchmark match duration distributions, faction fairness, action burden, logistic bottlenecks, AI competence and long-session stability before fixing balance numbers. The recommended feature stages and cuts are detailed in recommendations-and-roadmap-2026-10.md.
