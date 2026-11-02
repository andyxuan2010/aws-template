# Normalization Pass 4: Interface Migration

Date: 2026-10-30

## Baseline

All 37 AWS modules have `variables.tf`. Thirty-three expose `workload`, `environment`, and `instance`; 31 expose `region_code`; 35 expose `tags` and `inherited_tags`.

## Migration policy

- Retain the established AWS metadata names `workload`, `environment`, `region_code`, and `instance` where those values are meaningful to the module.
- Do not add unused inputs just to make every module's variable list identical.
- Keep AWS `tags` and `inherited_tags` semantics explicit. Preserve provider-native AWS resource options.
- Do not remove or change the meaning of an existing input in a patch release. Breaking removals require a major interface change and a documented migration window.
- Keep module-specific outputs stable. Changes to resource addresses or output meaning require a separately reviewed migration.
- Update tests, examples, module READMEs, generated docs, and pipeline checks together whenever a public interface changes.

## Decision

AWS already follows the shared metadata names used by GCP. Retain those names, document the four module-specific exceptions, and only add a missing common input when it affects actual resource naming, placement, or metadata behavior. Keep AWS tags provider-native; they do not map one-to-one to GCP labels, Azure tags, or OCI defined tags.

This pass records the compatibility contract and inventory. No public variable has been renamed or removed in this documentation step. No infrastructure plan or apply is part of the interface migration.

## Migration sequence

1. Review the four exceptions for whether the absent metadata is relevant to their resource behavior.
2. If useful, add inputs additively and cover them with mocked tests and standalone examples.
3. Retain all current names and output contracts; document any future major-version changes in advance.
