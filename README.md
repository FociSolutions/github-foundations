# GitHub Foundations Toolkit

## _This project is intended as a set of administrative tools for an enterprise to create consistency across all its organizations. Using these tools you'll have a central repository for changes across all the organizations and you can feel confident in the security in place across your entire enterprise._ 

If you are managing an enterprise with multiple organizations, it can be hard to know if security tools are being applied consistently across all your organizations. Simultaneously, updates across the enterprise can take days, even weeks, with inconsistent roll out requiring actions be performed by each organization independently. Before long you end up with organizations out of sync, and in a large enterprise not only can you not guarantee that your configurations are the same, you don't know which organizations are out of touch.

Enter the GitHub Foundations Toolkit.

By using this project you are able to setup multiple organizations under a single GitHub Enterprise account and manage their configurations, teams, and cloud provider settings all using Terraform. Our intent is to create a true "Infrastructure as Code" approach that can be used quickly and reliably out of the box, ensuring that security protocols are established by default. We also support drift detection to protect against unauthorized changes and keep the enterprise within the boundaries of a known level of security.

This repository is organized into 2 layers as follows:

## [The Bootstrap Layer](./bootstrap/README.md)

The Bootstrap is used to setup GCP and perform the creation of all organizations under a GitHub Enterprise account.

## [The Organizations Layer](./organizations/README.md)

The Organizations Layer is used to manage the organizations created by the Bootstrap as well as create and manage teams. This layer also contains drift detection for Terraform and the ability to run plans on pull requests.
