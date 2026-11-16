# brad-agentic-files

Agentic configuration for blue team

## agent setup

## skills

### install

```shell
npx skills add bamboohealth/brad-agentic-files --global --skill '*' --agent kiro-cli
```

### update

```shell
npx skills update
```

______________________________________________________________________

## dev dependencies

mdformat is used to enforce style guides across markdown documents. Jenkins also enforces this.

```shell
brew install pipx yamllint
pipx install mdformat yamlfixer-opt-nc
pipx inject mdformat mdformat-gfm mdformat-frontmatter mdformat-footnote mdformat-gfm-alerts
```

### pre-commit

There is a pre-commit hook to run mdformat

```shell
pre-commit install
```

#### GH PAT

Create a [personal access token](https://github.com/settings/tokens) and add it to `~/.zshenv`:

```shell
echo 'export KIRO_GH_TOKEN=<token>' >> ~/.zshenv
```
