# Protect user accounts and identities

([Back](../../GUARDRAILS.md))

## Objective

Protect user accounts and identities.
This section contains the Guardrails that address controls in the:

- Access Control (AC)
- Configuration Management (CM)
- Identification and Authentication (IA)
- System Information and Integrity (SI)

families.

## Applicable Service Models

- Software as a Service (SaaS)
    - Specifically, DevOps and Source Code management tools

## Mandatory Requirements

| Activity  | Validation |
| --- | --- |
| Implement strong multi-factor authentication (MFA) for all user accounts. Use phishing resistant MFA where and when available. <br><br> **Note:** User accounts and identities include: <ul><li>root or global administrator (as it has enhanced or the highest level of privilege over the control plane and addresses all aspects of access control).</li><li>Other Administrative user accounts. Refer to<ul><li>Section 4 of the [Directive on Service and Digital](https://www.tbs-sct.canada.ca/pol/doc-eng.aspx?id=32601)</li><li>[Appendix G: Standard on Enterprise Information Technology Service Common Configurations](https://www.tbs-sct.canada.ca/pol/doc-eng.aspx?id=32713)</li><li>[Account Management Configuration Requirements](https://www.canada.ca/en/government/system/digital-government/policies-standards/enterprise-it-service-common-configurations/account.html)</li></ul></li><li>Regular user accounts</li></ul> | <ul><li>Confirm that MFA is implemented according to GC guidance through screenshots, compliance reports, or compliance checks enabled through a reporting tool for all user accounts.</li><li>Confirm that digital policies are in place to ensure that MFA configurations are enforced.</li></li><li>Confirm and report the count of registered root or global administrators (you should have at least two and no more than five).</li></ul> |
| Configure alerting to ensure the prompt detection of a potential compromise, in accordance with the GC [Event Logging Guidance](https://www.canada.ca/en/government/system/digital-government/online-security-privacy/event-logging-guidance.html).</li></ul> | <ul><li>Confirm whether monitoring and auditing is implemented for all user accounts.</li><li>Confirm that alerts to the authorized personnel have been implemented to flag misuse or suspicious activities for all user accounts. |
| Use separate dedicated accounts for highly privileged roles (for example, domain administrators, global administrators, and root and any domain administrator equivalent access) when administering cloud services to minimize the potential damage. | <ul><li>Provide evidence that there are dedicated user accounts for administration (for example, privileged access).</li> |
| Disable Inactive Accounts (automated) | <ul><li>The system must disable user accounts after **90 days** of inactivity</li></ul> |
| Implement a timeout and a lockout after too many login attempts for all user accounts. | <ul><li>Confirm that a timeout and lockout after too many login attempts are implemented for all user accounts.</li><li>The system enforces a limit of **3 consecutive invalid logon attempts** by a user during a **15 minute** period. </li><li>The system automatically locks the account/node for a **30-minute** period or until released by an administrator when the maximum number of unsuccessful attempts is exceeded.</li></ul> |
| Enforce a strong password policy that requires a minimum length, complexity, and regular changes. | <ul><li>Confirm that a strong password policy is enforced for all user accounts.</li><li>Confirm that the password policy includes a minimum length of **12 characters**, complexity, and regular changes.</li></ul> |
| Ensure that users only have the minimum permissions necessary to perform their tasks | <ul><li>Confirm that users only have the minimum permissions necessary to perform their tasks.</li><li>Confirm that permissions are reviewed and updated regularly.</li></ul> |

## Additional Considerations

| Activity  | Validation |
| --- | --- |
| Implement a secure process for account recovery to prevent it from being exploited. | <ul><li>Confirm that the process for account recovery is secure and cannot be exploited.</li></ul> |
| If your SCM supports API keys, ensure they are securely managed, regularly rotated, and not shared. | <ul><li>Confirm that API keys are securely managed, regularly rotated, and not shared.</li></ul> |

## References

- [Direction on the Secure Use of Commercial Cloud Services: Security Policy Implementation Notice](https://www.canada.ca/en/treasury-board-secretariat/services/access-information-privacy/security-identity-management/direction-secure-use-commercial-cloud-services-spin.html) (SPIN) 2017-01, subsection 6.2.3
- Cyber Centre’s top 10 IT security actions, number 3
- [Recommendations for Two-Factor User Authentication Within the Government of Canada Enterprise Domain](https://intranet.canada.ca/wg-tg/rtua-rafu-eng.asp) (accessible only on the Government of Canada network)
- [Government of Canada Multi-Factor Authentication (MFA) Considerations and Strategy for GC Enterprise IT Services](https://www.gcpedia.gc.ca/gcwiki/images/9/9e/GC_MFA_Strategy.pdf)
- [Directive on Service and Digital, Appendix G: Standard on Enterprise Information Technology Service Common Configurations](https://www.tbs-sct.canada.ca/pol/doc-eng.aspx?id=32713)
- [Account Management Configuration Requirements](https://www.canada.ca/en/government/system/digital-government/policies-standards/enterprise-it-service-common-configurations/account.html)
- [Event Logging Guidance](https://www.canada.ca/en/government/system/digital-government/online-security-privacy/event-logging-guidance.html)
- [Guidance on Defence in Depth for Cloud-Based Services (ITSP.50.104)](https://cyber.gc.ca/en/guidance/itsp50104-guidance-defence-depth-cloud-based-services), subsection 4.6

## Related security controls from ITSG-33

AC-2, AC-2(11), AC-3, AC-5, AC-6, AC-6(5), AC-6(10), AC-7, AC-19, AC-20(3), IA-2, IA-2(1), IA-2(2), IA-2(3), IA-2(11), IA-5(1), IA-5(8), SI-4, SI-4(5), SA-4(12), CM-5
