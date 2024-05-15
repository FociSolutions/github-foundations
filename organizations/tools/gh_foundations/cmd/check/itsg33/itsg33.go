package itsg33

import (
	"errors"
	"fmt"
	"gh_foundations/internal/pkg/types"
	"gh_foundations/internal/pkg/types/github"

	"github.com/spf13/cobra"
)

var Itsg33Cmd = &cobra.Command{
	Use:   "itsg33",
	Short: "Run the ITSG33 checks against a GitHub configuration.",
	Long:  `Run the ITSG33 checks against a GitHub configuration and generate reports.`,
	Args: func(cmd *cobra.Command, args []string) error {
		if len(args) < 1 {
			return errors.New("requires a GitHub organization slug")
		}
		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		slug := args[0]
		gs := github.NewGithubService()
		org, err := gs.GetOrganization(slug)
		if err == nil {
			report := org.Check([]types.CheckType{types.ITSG33})
			fmt.Printf("org report: %+v\n\n", report)
		} else {
			fmt.Printf("error: %v\n", err)
		}
		repos, err := gs.GetRepositories(slug, nil)
		if err == nil {
			for _, r := range repos {
				report := r.Check([]types.CheckType{types.ITSG33})
				fmt.Printf("repos report: %+v\n\n", report)
			}
		} else {
			fmt.Printf("error: %v\n", err)
		}
	},
}
