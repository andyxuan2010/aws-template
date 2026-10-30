# Cost and Budget Guide

Terraform configuration describes resources and settings; it does not provide a complete or current monthly cost estimate. Estimate the consumer workload before an approved deployment and monitor actual AWS usage afterward.

## What affects cost

- Region, Availability Zone coverage, service tier, redundancy, and capacity;
- compute size, runtime, autoscaling, idle resources, and licensing;
- storage capacity, requests, retention, backup, replication, and retrieval;
- network data transfer, NAT gateways, load balancers, endpoints, and public IPs;
- logs, metrics, traces, alarms, and retention;
- development, sandbox, and production copies of shared services;
- request, data, and event volumes for managed and serverless services.

Module defaults and examples show configuration behavior. They do not guarantee a workload fits a budget, utilization estimate, or service objective. For example, the foundation example creates two NAT gateways in its resilient mode, which incur ongoing charges.

## Estimate before provisioning

1. Select the relevant module and example, then list every enabled and conditional resource.
2. Confirm Region, SKU or instance type, data volume, uptime, redundancy, retention, and expected request rates with the workload owner.
3. Review a fresh consumer Terraform plan for additions, replacements, deletions, and configuration that affects ongoing usage.
4. Use the organization's approved AWS pricing and FinOps process or AWS Pricing Calculator. Record assumptions, Region, currency, and estimate date.
5. Obtain budget-owner approval and define AWS Budgets or other approved alerts before production use.
6. Compare estimates with actual billing and usage data after deployment; revisit the model when workload or module settings change.

This repository does not contain approved workload budgets or live price quotes. AWS prices and service meters change; use current pricing for the selected Region and date.

## Cost ownership

Confirm workload, account, budget, and alert owners before deployment. Follow the [Tagging Standard](../60-security-governance/tagging-standard.md) so supported resources can be attributed. A tag does not create a budget, alert, or chargeback process by itself.

## Useful review questions

- Which resources continue to incur charges when the workload is idle?
- Which tiers, retention windows, and availability settings are selected by module defaults?
- Are backups, replicas, gateways, endpoints, or monitoring retained after a test?
- What scales with requests, storage, network transfer, or runtime?
- Who reviews actual cost and approves capacity or retention changes?

Before removing resources, confirm data-retention and recovery requirements with the owner; see [Remove a Terraform-Managed Resource](destroy-a-resource.md).
