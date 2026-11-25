# Tests and Coverage

These rules override the "Ask before writing tests" rule in the agent steering. In repos with coverage checks, write tests for every code change without asking.

## Coverage Requirement

- New and changed lines in the diff must have 100% line and branch coverage.
- Overall project coverage must not drop.
- Exclusions are documented in each repo's `README.md` or `AGENTS.md`. Follow them, and don't add new exclusions or inline coverage-ignore comments without asking.

## Writing Tests

- Follow the project's existing test framework, layout, and naming.
- Prefer tests that assert behavior: given an input, check the output or side effect.
- When behavior can't be exercised directly, mocking data and asserting on the result is acceptable.
- Use synthetic data only. Never use real PHI or PII in fixtures.

## Verify Before Opening a PR

- Run the project's test and coverage task locally before opening a PR.
- In the PR description, cite the line and branch coverage for the changed code.
- Treat every PR as a full PR unless the user asks for a draft. Draft PRs skip the coverage checks.

## Uncoverable Code

If a line or branch can't reasonably be covered, don't block on it. List each uncovered line in the PR description with the reason it isn't covered.

## Repos Without Coverage Checks

The coverage requirement applies only to repos that already have coverage checks configured. Some repos, such as Terraform/OpenTofu, don't. In those repos, tell the user there are no coverage checks instead of skipping the requirement without saying so.
