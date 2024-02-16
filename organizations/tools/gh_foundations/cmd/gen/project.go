package gen

import (
	"gh_foundations/internal/pkg/functions"
	"log"

	"github.com/spf13/cobra"
)

// projectCmd represents the project command
var projectCmd = &cobra.Command{
	Use:   "project",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: func(cmd *cobra.Command, args []string) error {
		// Optionally run one of the validators provided by cobra
		if err := cobra.MinimumNArgs(1)(cmd, args); err != nil {
			return err
		}
		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		organizations, err := cmd.Flags().GetStringSlice("organizations")
		if err != nil {
			log.Fatal(err)
		}

		repositoryRoot, err := cmd.Flags().GetString("repository_root")
		if err != nil {
			log.Fatal(err)
		}

		functions.CreateProjectFiles(args[0], organizations, repositoryRoot)

	},
}

func init() {
	projectCmd.Flags().StringSlice("organizations", []string{}, "List of github organizations that have repositories involved in the project.")
	projectCmd.Flags().String("repository_root", ".", "The root directory of the repository. Defaults to \".\".")
	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// projectCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// projectCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
