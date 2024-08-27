# Import Tool

An Import tool is provided with the [GitHub Foundations CLI](https://github.com/FociSolutions/github-foundations-cli). This tool will start an interactive process to import resources into Terraform state. It uses the results of a terraform plan to determine which resources are available for import.


To run an import check for a repository, run the following command:

```bash
Usage:
    github-foundations-cli import [module_path]
```

Where `<module_path>` is the path to the Terragrunt module to import.

For more information, see the [documentation](https://github.com/FociSolutions/github-foundations-cli?tab=readme-ov-file#import).
