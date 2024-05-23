package check

import (
	"encoding/json"
	"errors"
	"gh_foundations/internal/pkg/types"
	"gh_foundations/internal/pkg/types/github"
	"os"

	"github.com/spf13/cobra"
)

var outputFile = "check_results.json"

var CheckCmd = &cobra.Command{
	Use:   "check",
	Short: "Perform checks against a Github configuration.",
	Long:  `Perform checks against a Github configuration and generate reports.`,
	Args: func(cmd *cobra.Command, args []string) error {
		if len(args) < 1 {
			return errors.New("requires a GitHub organization slug")
		}
		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		reports := make([]types.CheckReport, 0)
		slug := args[0]
		authToken, set := os.LookupEnv("GITHUB_TOKEN")
		if !set {
			cmd.PrintErr("GITHUB_TOKEN environment variable not set")
			return
		}
		gs := github.NewGithubService(authToken)
		org, err := gs.GetOrganization(slug)
		if err == nil {
			reports = append(reports, org.Check([]types.CheckType{types.GoCGaurdrails}))
		}

		repos, err := gs.GetRepositories(slug, nil)
		if err == nil {
			for _, r := range repos {
				reports = append(reports, r.Check([]types.CheckType{types.GoCGaurdrails}))
			}
		}

		file, err := os.OpenFile(outputFile, os.O_CREATE|os.O_WRONLY, 0644)
		if err != nil {
			cmd.PrintErr(err)
			return
		}
		defer file.Close()

		bytes, err := json.Marshal(reports)
		if err != nil {
			cmd.PrintErr(err)
			return
		}

		file.Truncate(0)
		file.Seek(0, 0)
		file.Write(bytes)
	},
}
