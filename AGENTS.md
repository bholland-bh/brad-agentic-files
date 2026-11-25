# AGENTS.md — brad-agentic-files

> This repo is **public**. Anyone can read every commit, including history, author metadata, branch names, PR titles, PR descriptions, and PR comments. Re-run the agents-md skill to refresh the repo context sections; keep the Public Repository Rules.

## Public Repository Rules

Before every commit, push, or PR, check the diff, the commit message, and the PR text against these lists. If anything matches "Never publish", stop and ask the user.

### Never publish

- Secrets: tokens, API keys, passwords, private keys, cookies, `.env` contents. Use placeholders such as `<token>`.
- PHI or PII, including in examples. Use synthetic data.
- AWS account IDs, ARNs, resource IDs (VPC, subnet, security group, cluster), IP addresses, internal hostnames, or internal URLs other than `hbuco.atlassian.net`.
- Database names, connection strings, schemas, or table names from Bamboo Health applications.
- Content copied from Jira tickets, Confluence pages, Slack, or CAB tickets. Ticket keys alone are fine.
- Customer, state, or partner names, and contract details.
- Code, config, or skill content copied from private `bamboohealth` repos.
- Names, emails, or account IDs of anyone other than Brad Holland.
- Vulnerabilities, security findings, or incident details.

### Accepted (already public, don't flag or remove)

- `hbuco.atlassian.net`, the BLUE and CAB project keys, and the Jira custom field and option IDs in `steering/`
- Brad's Atlassian account ID in `steering/blue-jira.md`
- Public Bamboo Health product names (Gateway, PMP InterConnect, NarxCare, SafeScripts+, Justice Involved, Customer Connect)
- The private repo name `bamboohealth/blue-precommit-hooks` in `.pre-commit-config.yaml`
- The commit author email `bholland@bamboohealth.com`

### When unsure

Ask before committing. Deleting something after it's pushed doesn't remove it: it stays in history, in `refs/pull/*`, and in any fork or clone.

## Identity

| Field | Value |
| -- | -- |
| Repo | `brad-agentic-files` |
| Type | other (agent configuration) |
| Language | Markdown, Bash |
| Package Manager | mise (pipx and pypi backends) |
| Purpose | Kiro CLI steering files and skills for Brad Holland |

## Structure

```
steering/                 # Kiro steering files, symlinked into ~/.kiro/steering
  blue-jira.md            # BLUE Jira ticket workflow and field rules
  cab.md                  # CAB change ticket workflow and field rules
  tests.md                # test and coverage rules
install.sh                # steering symlink installer
README.md                 # setup for steering, skills, and dev tools
mise.toml / mise.lock     # dev tool pins
.pre-commit-config.yaml   # pre-commit hooks
.mdformat.toml            # markdown formatting
.yamlfix.toml             # YAML formatting
```

## Entry Points

| File | Purpose |
| -- | -- |
| `install.sh` | Symlinks `steering/*.md` into `${KIRO_STEERING_DIR:-~/.kiro/steering}`, backs up differing files to `.bak`, removes stale links that point into this repo |

## Build & Run

```bash
# Install dev tools
mise install

# Enable hooks
pre-commit install

# Lint / format
pre-commit run --all-files

# Install steering files
./install.sh

# Install / update skills
npx skills add bholland-bh/brad-agentic-files --global --skill '*' --agent kiro-cli
npx skills update
```

## Configuration

| File | Controls |
| -- | -- |
| `.pre-commit-config.yaml` | `mise-lock` (blue-precommit-hooks 1.1.0), `trailing-whitespace`, `end-of-file-fixer`, `yamlfix` 1.19.1, `mdformat` 1.0.0 |
| `.mdformat.toml` | No line wrapping, numbered lists, LF endings, GFM, alerts, frontmatter, footnotes, compact tables |
| `.yamlfix.toml` | Block-style sequences, line length 9999, single blank lines |
| `mise.toml` / `mise.lock` | mdformat 1.0.0, yamlfix 1.19.1, yamllint 1.38.0 |
| `.gitignore` | JetBrains, macOS, and VS Code files |

## External Dependencies

| Service/Library | Usage |
| -- | -- |
| Kiro CLI | Loads steering files and skills |
| `npx skills` | Installs skills from this repo |
| mise | Installs dev tools |
| pre-commit | Runs formatters and lint hooks |
| Jenkins | Enforces mdformat per `README.md` (no Jenkinsfile in this repo) |

## Conventions

| Area | Convention |
| -- | -- |
| Branches | `BLUE-0-short-description` |
| Commits / PR titles | `BLUE-0: short description` |
| Merging | PRs are squash-merged into `main` |
| Markdown | `mdformat`, no line wrapping, GFM tables |
| YAML | `yamlfix` |
| Testing | No tests or coverage checks |

## Gotchas

- `kiro-cli chat --v3` skips symlinked steering files (kirodotdev/Kiro#9787). The default v2 engine loads them.
- The `mise-lock` hook comes from the private `bamboohealth/blue-precommit-hooks` repo, so `pre-commit` fails for anyone without access.
- The `exclude: ^(\.md)$` on the whitespace hooks matches only a file named `.md`, so those hooks still run on markdown files.
- The `README.md` skills install command expects skill directories, and this repo has none yet. Check any new skill against the Public Repository Rules before committing it.
