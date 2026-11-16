# brad-agentic-files

Agentic configuration for blue team

## agent setup

### steering install

```shell
./install.sh
```

This symlinks every `steering/*.md` file into `~/.kiro/steering`, so edits in this repo apply the next time the agent starts. Re-run it after adding or renaming steering files; it also removes links to files that no longer exist. An existing file in `~/.kiro/steering` that differs from the repo copy is backed up to `<name>.bak` before it is replaced.

> [!NOTE]
> `kiro-cli chat --v3` skips symlinked steering files ([kirodotdev/Kiro#9787](https://github.com/kirodotdev/Kiro/issues/9787)). The default v2 engine loads them.

## skills

### install

```shell
npx skills add bholland-bh/brad-agentic-files --global --skill '*' --agent kiro-cli
```

### update

```shell
npx skills update
```

______________________________________________________________________

## dev dependencies

mdformat is used to enforce style guides across markdown documents. Jenkins also enforces this.

[mise](https://mise.jdx.dev) installs the dev tools pinned in `mise.toml` (mdformat, yamlfix, and yamllint):

```shell
brew install mise
mise install
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
