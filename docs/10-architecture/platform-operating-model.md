# Platform Operating Model

This guide describes how teams use and govern the AWS module catalog. It reflects repository content and workflow configuration; it does not claim that an AWS service is deployed or that an operational SLA has been approved.

## Platform capability

The repository supplies reusable AWS Terraform modules, mocked tests, examples, and validation and publishing workflows. Consumers may use modules independently or compose them in their own root configuration. The catalog does not provision one always-on platform environment.

## Consumer lifecycle

1. Select a module and review its prerequisites, secure defaults, limitations, and cost behavior.
2. Configure providers, identity, target account and Region, backend, and workload inputs in a controlled consuming root.
3. Review and validate changes. The template CI validates code and mocked behavior without AWS access.
4. Review a fresh plan in the consuming deployment process and apply it only under that process's approvals.
5. Operate, monitor, recover, and eventually retire the deployed workload under its service ownership model.

Publishing this repository to GitHub or Azure DevOps is separate from deploying infrastructure.

## Responsibility boundaries

| Concern | Repository responsibility | Consumer or platform owner responsibility |
| --- | --- | --- |
| Module behavior | Reusable resource code, documented inputs/outputs, tests, and examples. | Select, configure, version, and support modules for a workload. |
| Authentication | Document identity and CI expectations. | Provision and authorize workload identities and short-lived credentials. |
| State | Explain state boundaries and safe lifecycle practices. | Select and secure the backend, locking, access, retention, backups, and recovery. |
| Deployment | Define validation and optional repository publishing gates. | Own AWS plan/apply workflows, branch protections, approvals, credentials, and account selection. |
| Cost | Document module resources, defaults, and known cost drivers. | Estimate and approve spend, set budgets, monitor actual usage, and assign chargeback. |
| Service operation | Provide reusable building blocks and operational notes. | Define service owner, support model, monitoring, recovery objectives, and incident response. |

## Governance points

- Treat examples and offline plans as validation aids, not proof of a deployed estate.
- Keep deployment credentials and backend configuration in the consuming root's approved secret and configuration systems.
- Apply the exact plan reviewed by the consumer change process. Re-plan if code, state, or AWS resources change.
- Review changes to shared module interfaces, defaults, and resource addresses for compatibility and downstream impact.
- Confirm account-wide governance, SCPs, quotas, logging destinations, and identity controls with the AWS platform owner.

## Ownership information to maintain

Platform owners should maintain these details in the organization's approved ownership system and link that source here when available:

- module and pipeline maintainers;
- escalation route and support hours;
- service criticality and recovery objectives;
- production approval authorities;
- security and cost owners;
- module deprecation and migration policy.

These values are not inferred from repository code and should be added only after the responsible owners confirm them.

## Related guides

- [Repository Architecture](repository-architecture.md)
- [Architecture Decision Records](architecture-decision-records.md)
- [Environment and Delivery Lifecycle](../30-deployment/environment-lifecycle.md)
- [Cost and Budget Guide](../50-operations/cost-and-budget-guide.md)
- [Stakeholder Reading Guide](../00-start-here/stakeholder-guide.md)
