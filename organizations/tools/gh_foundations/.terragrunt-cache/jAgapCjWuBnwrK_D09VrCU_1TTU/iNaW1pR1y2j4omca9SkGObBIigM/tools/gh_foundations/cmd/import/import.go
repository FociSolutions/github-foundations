package import_cmd

import (
	"fmt"
	"gh_foundations/internal/pkg/functions"
	"log"
	"os"

	"github.com/spf13/cobra"
)

// ImportCmd represents the project command
var ImportCmd = &cobra.Command{
	Use:   "import",
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
		modulePath := args[0]
		planArchive, err := functions.ArchivePlan(modulePath, "plan.json")
		fmt.Println(err)
		if err != nil {
			log.Fatal(err)
			os.Exit(2)
		}
		resources, err := functions.GetAddressesForPlannedResourceCreates(planArchive)
		fmt.Println(err)
		if err != nil {
			log.Fatal(err)
			os.Exit(2)
		}
		fmt.Println(resources)
	},
}

func init() {
	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// ImportCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// ImportCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
