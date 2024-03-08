# GitHub Foundations Toolkit

## Securely Manage Your Enterprise's GitHub Environment at Scale 

### [Get started now!](./README.md#getting-started)

Running a large enterprise on GitHub can be a security nightmare. Maintaining consistent configurations across multiple organizations is a challenge. Updates can take days or weeks, and inconsistencies create blind spots for security vulnerabilities.

Introducing the GitHub Foundations Toolkit.

The GitHub Foundations Toolkit empowers you to manage your enterprise's GitHub environment with security and efficiency. This open-source project provides a comprehensive set of tools to:

### Automate Continuous Secure Infrastructure:
Set up and manage multiple organizations under a single GitHub Enterprise account using Infrastructure as Code (IaC) principles with Terraform. Using these tools you can establish consistent security best practices by default and leverage drift detection to identify unauthorized changes and ensure your configurations remain secure. 
### Centralize Control:
Gain a single pane of glass view for managing configurations, teams, and cloud provider settings across all your organizations for better reporting and decision making. 
### Rapid Rollouts:
Streamline updates and enforce security policies consistently across your entire enterprise, eliminating the need for time-consuming manual intervention by individual organizations. With a single update you can be confident that all your organizations are up to date at the same time and by automating repetitive tasks and streamlining updates your teams can focus on innovation rather than lengthy and repetitive updates. 
### Reduce Security Risks:
Minimize the attack surface by enforcing consistent security policies across all your organizations. 
This project is Open Source and customizable. Released under the [MIT license](./LICENSE.md), you can tailor the toolkit to your specific needs and contribute to its ongoing development. 
## Features:

### Current:
- Our solution leverages a GCP backend for infrastructure provisioning. (Future support for Azure and AWS coming soon!) 
- Terraform and Terragrunt are the industry-standard tools used for managing infrastructure as code, including drift detection. 
- Automate creation, deletion, and configuration of repositories (private and public). 
- Efficiently manage teams and team memberships across organizations. 
- Securely store and manage sensitive secrets within your GitHub environment. 
- Enforce granular access control using Rulesets for branch protection. 
### Future:
- Multi-Cloud Support for seamless integration with Azure and AWS cloud providers. 
- Enhanced Security features based on community needs. 

## Getting Started:
This repository is organized into 2 layers:
Bootstrap Layer:  Organizations Layer: 
### [The Bootstrap Layer](./bootstrap/README.md)

The Bootstrap sets up GCP and creates all organizations under your GitHub Enterprise account.

### [The Organizations Layer](./organizations/README.md)

The Organizations Layer manages configurations, teams, cloud provider settings, drift detection, and pull request plan execution for your organizations.

**_Embrace a Secure and Efficient Future with the GitHub Foundations Toolkit!_**
