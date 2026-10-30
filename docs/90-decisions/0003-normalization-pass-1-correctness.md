# Normalization Pass 1: Correctness

Date: 2026-10-30

This pass records correctness checks and repairs before expanding test and example coverage. The four repositories are reviewed as separate Terraform modules with cloud-specific runtime requirements.

## Changes

- No Terraform resource addresses, input names, or provider constraints were mass-renamed. Those changes can alter consumer plans or state addresses and belong in separately reviewed migrations.
- The AWS workflow already runs formatting, static/security checks, and mocked module tests for changed modules. Existing force-published snapshots and tags were left for a separately scoped publishing-policy change because they are deliberate repository mirror behavior.
- Six modules had no test file at the start of the pass; their coverage is added in Pass 2.

## Validation

- Workflow YAML and current module tests were inspected. No live AWS plan or apply was run for this pass.
- Repository settings and target ADO/GitHub mirror protections cannot be verified from the checked-in source.

## Follow-up

See `0004-normalization-pass-2-coverage.md` for the next coverage pass and its per-repository results.
