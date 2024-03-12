# GitHub Foundations Toolkit

## Secure Your Enterprise's GitHub Environment at Scale

### Quick Start: [Get Started Now!](./README.md#getting-started)

Managing GitHub for large enterprises introduces complex security and consistency challenges. The GitHub Foundations Toolkit offers a secure, efficient way to manage your enterprise's GitHub environment through automation and centralized control.

### Automation and Security Features:

- [ ] **Automate Continuous Secure Infrastructure:** 
  - Utilize Infrastructure as Code (IaC) principles with Terraform to manage multiple organizations under a single GitHub Enterprise account. 
  - Establish and enforce security best practices by default.
  - Use drift detection to promptly identify and rectify unauthorized changes, ensuring your configurations are always secure.

- **Centralize Control:** 
  - Gain a comprehensive overview for managing organizations, repositories, and teams across your enterprise.

- **Rapid Rollouts:** 
  - Streamline updates and security policy enforcement across your entire enterprise, reducing the need for manual intervention. 
  - Automate repetitive tasks, allowing teams to focus on innovation.

- **Reduce Security Risks:** 
  - Enforce consistent security policies across all organizations to minimize vulnerabilities and protect against attacks.

This project is open-source and customizable, released under the [MIT license](./LICENSE.md). You're invited to adapt the toolkit to your specific needs and contribute to its development.

## Detailed Features:

### Current:
- [ ] **GCP Backend for Infrastructure Provisioning:** Current support for Google Cloud Platform, with future plans to integrate Azure and AWS for a multi-cloud approach.
- [ ] **Terraform and Terragrunt for Infrastructure Management:** Leverage these tools for infrastructure as code, including capabilities for drift detection to ensure your infrastructure remains secure and aligned with your policies.
- [ ] **Automated Repository Management:** Automate the creation, deletion, and configuration of both private and public repositories, streamlining your workflow.
- [ ] **Team and Membership Management:** Efficiently manage teams and their memberships across your organizations, simplifying administration.
- [ ] **Secure Secrets Management:** Securely store and manage sensitive secrets within your GitHub environment to protect your data.
- [ ] **Granular Access Control with Rulesets:** Enforce branch protection with customizable rulesets for enhanced security.

### Upcoming:
- [ ] **Multi-Cloud Support:** Future integration with Azure and AWS for seamless multi-cloud operations.
- [ ] **Enhanced Security Features:** Development of advanced security features based on the evolving needs of the community.

## Getting Started:

The repository is organized into two layers for ease of setup and management:

### [Bootstrap Layer](./bootstrap/README.md)

Initial setup of your state file backend, and creation of all organizations under your GitHub Enterprise account.

### [Organizations Layer](./organizations/README.md)

Management of organizations, repositories, and teams, Review results of drift detection, and execution of pull request plans for your organizations.

**Embrace a secure, efficient future with the GitHub Foundations Toolkit!**