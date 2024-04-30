"""
This module provides functions to find and manage organizations, repositories,
and files in the GHF (GitHub Foundations) project.

Usage:
- To find all public repositories or repositories with GHAS enabled, run the
  script with the `--ghas` flag.
- To find all organizations managed by GHF, run the script with the `--orgs` flag.
"""

import inspect
import logging
import os
import sys

import argparse
import hcl2

# Get the absolute path of the script file
script_dir = os.path.dirname(os.path.abspath(__file__))
# Construct the path to the providers directory
providers_dir = os.path.join(script_dir, '../../../providers')
# Construct the path to the projects directory
projects_dir = os.path.join(script_dir, '../../../projects')

def find_terragrunt_hcl_files(root_dir=projects_dir)->list:
    """ Find all terragrunt.hcl files

    Looks for all terragrunt.hcl files in the provided directory and
    returns a dictionary.
    Args:
        root_dir (str): The root directory to search for terragrunt.hcl files.
                        Default is `../../../projects`
    Returns:
        dict: A dictionary with the org name as the key and a list of paths
              to the terragrunt.hcl files as the value
    """
    hcl_files = []

    for root, _, files in os.walk(root_dir):
        for file in files:
            # ignore file in the .terragrunt-cache directory
            if '.terragrunt-cache' in root:
                continue

            dirs = root.split('/')
            if len(dirs) < 2:
                continue

            if file.endswith('terragrunt.hcl') or file.endswith('providers.hcl'):
                logging.debug(
                    "%s: Found tf file: %s",
                    inspect.currentframe().f_code.co_name,
                    os.path.join(root, file)
                )
                hcl_files.append(os.path.join(root, file))

    return hcl_files


def find_orgs_from_filenames(hcl_files, index_of_key=5)->dict:
    """ Find all orgs given a set of terragrunt.hcl file paths

    Args:
        hcl_files (list): A list of terragrunt.hcl file paths
        index_of_key (int): The index of the Org name in the path. Default is 5
    Returns:
        dict: A dictionary with the org name as the key and a list of paths
              to the terragrunt.hcl files as the value
    """
    names = {}
    for file in hcl_files:
        dirs = file.split('/')
        # Add a key/value pair of org name / path to the hcl file
        # The key is the name of the 3rd dir from the root
        org_name = dirs[index_of_key]
        if org_name not in names:
            names[org_name] = []
        names[org_name].append(file)

    return names


def find_managed_repos()->dict:
    """ Find all public and private repos managed by GHF

    Searches for repos belonging to any org
    Returns:
        dict: A dictionary with two keys, `public` and `private`, each containing a list of repos
    """
    hcl_files = find_terragrunt_hcl_files()
    org_files = find_orgs_from_filenames(hcl_files)
    repos = {}
    repos['public'] = []
    repos['private'] = []
    for org, files in org_files.items():
        for file in files:
            logging.debug("%s: Org: %s\tFile: %s", inspect.currentframe().f_code.co_name, org, file)
            with open(file, 'r', encoding='utf-8') as f:
                data = hcl2.load(f)
                if 'inputs' in data:
                    if 'public_repositories' in data['inputs']:
                        for repo_name, repo_details in data['inputs']['public_repositories'].items():
                            repos['public'].append({
                                'org': org,
                                'name': repo_name,
                            })
                    if 'private_repositories' in data['inputs']:
                        # iterate over private repos and add them to the list, along
                        # with the value of the `advance_security` key
                        for repo_name, repo_details in data['inputs']['private_repositories'].items():
                            advance_security = repo_details.get('advance_security', False)
                            repos['private'].append({
                                'org': org,
                                'name': repo_name,
                                'advance_security': advance_security
                            })
    return repos


def find_managed_orgs()->list:
    """ Find all orgs managed by GHF

    Searches for all terragrunt.hcl files in the organizations directory
    Returns:
        list: A list of org names
    """
    orgs = []
    hcl_files = find_terragrunt_hcl_files(providers_dir)

    for file in hcl_files:
        with open(file, 'r', encoding='utf-8') as f:
            logging.debug("%s: Reading file: %s", inspect.currentframe().f_code.co_name, file)
            data = hcl2.load(f)
            if 'locals' in data:
                if 'organization_name' in data['locals'][0]:
                    logging.debug(
                        "%s: Found org: %s",
                        inspect.currentframe().f_code.co_name,
                        data['locals'][0]['organization_name']
                    )
                    orgs.append(data['locals'][0]['organization_name'])

    logging.debug(
        "%s: Found %i orgs",
        inspect.currentframe().f_code.co_name,
        len(orgs)
    )
    return orgs


def find_ghas_eligible_repos()->list:
    """ Find all public repos or repos with GHAS enabled

    Returns a list of all public repos and private repos with GHAS enabled.
    """
    repos = find_managed_repos()
    return filter_repos_without_ghas_enabled(repos)


def filter_repos_without_ghas_enabled(repos)->list:
    """ Given a list of repos, filter out the ones without GHAS eligible """

    repos_with_ghas = []
    # append all public repos, since they are enabled by default
    for repo in repos['public']:
        repos_with_ghas.append(f"{repo['org']}/{repo['name']}")

    for repo in repos['private']:
        if repo['advance_security']:
            repos_with_ghas.append(f"{repo['org']}/{repo['name']}")
    return repos_with_ghas


if __name__ == '__main__':
    logging.getLogger().setLevel(logging.DEBUG)

    parser = argparse.ArgumentParser(description="Run commands on GHF entities")

    parser.add_argument(
        '--ghas',
        action='store_true',
        dest='ghas',
        required=False,
        help='Find all public repos, or repos with GHAS enabled'
    )
    parser.add_argument(
        '--orgs',
        action='store_true',
        dest='orgs',
        required=False,
        help='Find all orgs managed by GHF'
    )


    known_args, others = parser.parse_known_args(sys.argv)

    if known_args.ghas:
        ghas_repos = find_ghas_eligible_repos()
        print(ghas_repos)
    if known_args.orgs:
        managed_orgs = find_managed_orgs()
        print(managed_orgs)
