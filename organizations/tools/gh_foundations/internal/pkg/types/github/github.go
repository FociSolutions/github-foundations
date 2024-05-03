package github

import (
	"context"
	"encoding/json"
	"time"

	"github.com/google/go-github/v61/github"
)

type IGithubService interface {
	GetOrganization(slug string) (Organization, error)
	GetRepositories(owner string, filterFn func(r Repository) bool) ([]Repository, error)
}

type GithubService struct {
	client *github.Client
}

func NewGithubService() IGithubService {
	return &GithubService{
		client: github.NewClient(nil),
	}
}

func (g *GithubService) GetOrganization(slug string) (Organization, error) {
	ctx, cancelFn := context.WithTimeout(context.Background(), 5*time.Minute)
	defer cancelFn()

	_, resp, err := g.client.Organizations.Get(ctx, slug)
	if err != nil {
		return Organization{}, err
	}

	var bodyBytes []byte
	_, err = resp.Body.Read(bodyBytes)
	if err != nil {
		return Organization{}, err
	}

	settings := make(map[string]interface{})
	err = json.Unmarshal(bodyBytes, &settings)
	if err != nil {
		return Organization{}, err
	}

	return Organization{
		slug:     slug,
		settings: settings,
	}, nil
}

func (g *GithubService) GetRepositories(owner string, filterFn func(r Repository) bool) ([]Repository, error) {
	ctx, cancelFn := context.WithTimeout(context.Background(), 5*time.Minute)
	defer cancelFn()

	_, resp, err := g.client.Repositories.ListByUser(ctx, owner, nil)
	if err != nil {
		return []Repository{}, err
	}

	var bodyBytes []byte
	_, err = resp.Body.Read(bodyBytes)
	if err != nil {
		return []Repository{}, err
	}

	var repositories = make([]Repository, 0)
	var settings []map[string]interface{}

	err = json.Unmarshal(bodyBytes, &settings)
	if err != nil {
		return []Repository{}, err
	}

	for _, s := range settings {
		_, rulesetResponse, err := g.client.Repositories.GetRulesForBranch(ctx, owner, s["name"].(string), s["default_branch"].(string))
		var rulesets []map[string]interface{}
		if err == nil {
			var rulesetBytes []byte
			_, err = rulesetResponse.Body.Read(rulesetBytes)
			if err == nil {
				json.Unmarshal(rulesetBytes, &rulesets)
			}
		}

		repositories = append(repositories, Repository{
			slug:     s["name"].(string),
			settings: s,
			rulesets: rulesets,
		})
	}

	return repositories, nil
}
