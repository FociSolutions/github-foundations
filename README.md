# GitHub Foundations Toolkit

## Secure Your Enterprise's GitHub Environment at Scale

### Quick Start: [Get Started Now!](./README.md#getting-started)

Managing GitHub for large enterprises introduces complex security and consistency challenges. Misaligned permission levels, team structures, incomplete change rollouts across organizations, and status reporting are just a few of the obstacles that can manifest with manual processes.  The GitHub Foundations Toolkit offers a secure and efficient way to manage your enterprise's GitHub environment through automation and centralized control.

### Project Features:

- **Automate Continuous Secure Infrastructure:**
  - Use Terraform to apply Infrastructure as Code (IaC) principles in managing multiple organizations under a single GitHub Enterprise account.
  - Establish and enforce security best practices by default.
  - Use drift detection to promptly identify and rectify unauthorized changes, ensuring your configurations are always secure.

- **Centralize Control:**
  - Gain a comprehensive overview for managing organizations, repositories, and teams across your enterprise.
  - Streamline updates and security policy enforcement across your entire enterprise, reducing the need for manual intervention.

- **Rapid Rollouts:**
  - Push policy updates across the entire enterprise in moments rather than waiting days for each organization to schedule individual exercises.
  - Automate repetitive tasks, allowing teams to focus on innovation.

- **Reduce Security Risks:**
  - Enforce consistent security policies across all organizations to minimize vulnerabilities and protect against attacks.
  - Have a unified view of potential vulnerabilities to prevent gaps opening in one organization or another.

This project is open-source and customizable, released under the [MIT license](./LICENSE.md). You're invited to adapt the toolkit to your specific needs and contribute to its development.

## Detailed Features:

### Current:
- [x] **GCP Backend for Infrastructure Provisioning:** Current support for Google Cloud Platform.
- [x] **Terraform and Terragrunt for Infrastructure Management:** Ensure your infrastructure remains secure and aligned with your policies by leveraging these tools for IaC.
- [x] **Automated Repository Management:** Streamline your workflow by automating the creation, deletion, and configuration of both private and public repositories.
- [x] **Team and Membership Management:** Simplify administration by consistently and efficiently managing teams and their memberships across your organization.
- [x] **Secure Secrets Management:** Protect your data by securely storing and managing sensitive secrets directly in your GitHub environment.
- [x] **Granular Access Control with Rulesets:** Enhance your security with branch protection through customizable [Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets#about-rulesets).

### Upcoming:
- [ ] **Multi-Cloud Support:** Future integration with Azure and AWS for seamless multi-cloud operations.
- [ ] **Enhanced Security Features:** Development of advanced security features based on the evolving needs of the community.

## Getting Started:
The repository is organized into two layers for ease of setup and management:

### [Bootstrap Layer](./bootstrap/README.md)

Initial setup of your state file backend, and creation of all organizations under your GitHub Enterprise account.

### [Organizations Layer](./organizations/README.md)

Management of organizations, repositories, and teams, Review results of drift detection, and execution of pull request plans for your organizations.

## Contributing to the toolkit

We welcome contributions to the GitHub Foundations Toolkit. Please read these [Contributing Guidelines](./CONTRIBUTING.md) for more information on how to get started.

**_Embrace a Secure and Efficient Future with the GitHub Foundations Toolkit!_**
