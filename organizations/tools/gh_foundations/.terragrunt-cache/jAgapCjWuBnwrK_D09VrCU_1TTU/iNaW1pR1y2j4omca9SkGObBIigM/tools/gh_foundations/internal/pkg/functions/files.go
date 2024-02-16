package functions

import (
	"log"
	"os"
	"strings"
)

func CreateProjectFiles(projectName string, organizations []string, repositoryRoot string) {
	for _, o := range organizations {
		orgProjectFolderPath := strings.Join([]string{repositoryRoot, "projects", projectName, o}, string(os.PathSeparator))
		orgProjectRepoFolderPath := strings.Join([]string{orgProjectFolderPath, "repositories"}, string(os.PathSeparator))
		orgProjectTeamFolderPath := strings.Join([]string{orgProjectFolderPath, "teams"}, string(os.PathSeparator))

		if _, err := os.Stat(orgProjectRepoFolderPath); os.IsNotExist(err) {
			os.MkdirAll(orgProjectRepoFolderPath, os.ModePerm)
		}

		if _, err := os.Stat(orgProjectTeamFolderPath); os.IsNotExist(err) {
			os.MkdirAll(orgProjectTeamFolderPath, os.ModePerm)
		}

		teamsModule := CreateTeamsModuleHCLContent([]string{})
		repositoriesModule := CreateRepositoriesModuleHCLContent()

		if err := os.WriteFile(strings.Join([]string{orgProjectTeamFolderPath, "terragrunt.hcl"}, string(os.PathSeparator)), []byte(teamsModule), os.ModePerm); err != nil {
			log.Fatal(err)
		}

		if err := os.WriteFile(strings.Join([]string{orgProjectRepoFolderPath, "terragrunt.hcl"}, string(os.PathSeparator)), []byte(repositoriesModule), os.ModePerm); err != nil {
			log.Fatal(err)
		}
	}
}
