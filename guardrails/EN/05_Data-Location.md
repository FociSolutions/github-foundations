# Data Location

([Back](../../GUARDRAILS.md))

## Objective

Establish policies to restrict sensitive GC workloads to approved geographic locations.

## Applicable Service Models

- Software as a Service (SaaS)
    - Specifically, DevOps and Source Code management tools

## A Note on Data Residency

| Activity | Validation |
| --- | --- |
| According to subsection 4.4.3.14 of the Directive on Service and Digital: “Ensuring computing facilities located within the geographic boundaries of Canada or within the premises of a Government of Canada department located abroad, such as a diplomatic or consular mission, be identified and evaluated as a principal delivery option for all sensitive electronic information and data under government control that has been categorized as Protected B, Protected C or is Classified.” | <ul><li>Source code is often considered Protected B in cases where the system that runs the source code handles Protected B data. This is a misconception: most often, source code contains only Unclassified information. There are a few general exceptions, including: <ul><li>those in the [Access to Information Act](http://laws-lois.justice.gc.ca/eng/acts/A-1/),</li><li> code for systems that perform audit and testing tasks,</li><li> and code for systems that handle financial transactions.</li></ul></li></ul> |

## Additional Considerations

None

## References

- [Direction on the Secure Use of Commercial Cloud Services: Security Policy Implementation Notice](https://www.canada.ca/en/treasury-board-secretariat/services/access-information-privacy/security-identity-management/direction-secure-use-commercial-cloud-services-spin.html), SPIN 2017-01, subsection 6.2.3
- [Directive on Service and Digital](https://www.tbs-sct.canada.ca/pol/doc-eng.aspx?id=32601), subsection 4.4.3.14
- [Access to Information Act](http://laws-lois.justice.gc.ca/eng/acts/A-1/)
