# Cyber Defense Services

([Back](../../GUARDRAILS.md)

## Objective

Establish and implement a comprehensive set of cyber defense services for Software as a Service (SaaS) applications, specifically focusing on DevOps and Source Code Management tools.

This section contains the Guardrails that address controls in the following contexts:

- Access Control (AC)
- Audit and Accountability (AU)
- Security Assessment and Authorization (CA)
- Identification and Authentication (IA)

## Mandatory Requirements

| Activity | Validation |
| --- | --- |
| Use threat-detection services that monitor for and alert on suspicious activity, such as multiple failed login attempts, unusual data access patterns, or known malicious IP addresses. | <ul><li>Ensure, at a minimum, that the activity is logged and sent to a SIEM (Security Information and Event Management) tool for analysis.</li></ul> |
| Ensure all changes to the SCM configuration are reviewed and approved by an authorized individual. | <ul><li>Use documented processes to review and approve changes to the SCM configuration</li><li>When using configuration-as-code, Use Pull Requests or Merge Requests to review and approve changes to the SCM configuration.</li></ul> |

## Conditional Requirements

| Activity | Validation |
| --- | --- |
| When possible, use automated tools to scan for credential leaks and ensure that leaked credentials are revoked and replaced. | <ul><li>Verify that the automated tools are used to scan for credential leaks and that leaked credentials are revoked and replaced.</li></ul> |
| Alerts generated by the threat-detection services should be received and acted upon in a [timely manner](#government-of-canada-cyber-security-event-management-plan-gc-csemp-requirements). | <ul><li>Verify that the alerts are received and acted upon in a [timely manner](#government-of-canada-cyber-security-event-management-plan-gc-csemp-requirements).</li></ul> |

## Government of Canada Cyber Security Event Management Plan (GC CSEMP) Requirements

The [GC CSEMP](https://www.canada.ca/en/government/system/digital-government/online-security-privacy/security-identity-management/government-canada-cyber-security-event-management-plan.html) outlines the requirements for the management of cyber security events in the Government of Canada. The GC CSEMP requirements for [reporting Cyber events](https://www.canada.ca/en/government/system/digital-government/online-security-privacy/security-identity-management/government-canada-cyber-security-event-management-plan.html#toc8) are as follows:

| Type of report | Timeframe |
| --- | --- |
| Initial incident report | As soon as possible, and not to exceed 1 hour, after initial detection |
| Detailed incident report | Within 24 hours after detection |

## References

- [Direction on the Secure Use of Commercial Cloud Services: Security Policy Implementation Notice](https://www.canada.ca/en/treasury-board-secretariat/services/access-information-privacy/security-identity-management/direction-secure-use-commercial-cloud-services-spin.html) (SPIN) 2017-01, subsection 6.3
- [Government of Canada Cyber Security Event Management Plan (GC CSEMP)](https://www.canada.ca/en/government/system/digital-government/online-security-privacy/security-identity-management/government-canada-cyber-security-event-management-plan.html)

## Related security controls from ITSG-33

AC-22,
AU-1, AU-2, AU-6,
CA-7,
IA-5(6), IA-5(7)
