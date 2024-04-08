package gen

import (
	repositoryset "gh_foundations/cmd/gen/repository_set"

	"github.com/spf13/cobra"
)

// genCmd represents the base command when called without any subcommands
var GenCmd = &cobra.Command{
	Use:   "gen",
	Short: "Generate HCL input for GitHub Foundations.",
	Long:  `Generate HCL input for GitHub Foundations. This tool is used to generate HCL input for GitHub Foundations from state files output by terraformer.`,
}

func init() {
	GenCmd.AddCommand(repositoryset.GenRepositorySetCmd)
}
