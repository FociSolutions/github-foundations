# Github Foundations Toolkit

## _This project is intended as a set of administrative tools for an enterprise to create consistency across all its organizations. Using these tools you'll have a central repository for changes across all the organizations and you can feel confident in the security in place across your entire enterprise._ 

_This repository is organized into 2 layers:_

## [The Bootstrap Layer](./bootstrap/README.md)

The Bootstrap is used to setup GCP and perform the creation of all organizations under a GitHub Enterprise account.

## [The Organizations Layer](./organizations/README.md)

The Organizations Layer is used to manage the organizations created by the Bootstrap as well as create and manage teams. This layer also contains drift detection for Terraform and the ability to run plans on pull requests.
