# BLUE Jira

## Atlassian Cloud ID

Use `hbuco.atlassian.net` as the `cloudId` for every Atlassian MCP call (Jira and Confluence). Other cloud IDs fail with "isn't explicitly granted by the user."

## BLUE-0 Exception

`BLUE-0` is a placeholder ticket for work that has no real ticket. When the user gives `BLUE-0` as the ticket ID, skip every Jira step in this file and in other steering files:

- Don't search for a matching ticket or create a new one.
- Don't check the ticket status before opening a PR.
- After a PR is submitted, don't comment on, assign, or transition the ticket.
- Don't check or set `customfield_10311`.

Still use `BLUE-0` as the ticket ID prefix:

- Branch names: `BLUE-0-short-description` (for example, `BLUE-0-add-something`)
- Commit messages and PR titles: `BLUE-0: short description`

## Find or Create a Ticket Before Starting Work

Before starting any implementation task, search Jira for an existing ticket that matches it.

- Search the BLUE project with `searchJiraIssuesUsingJql`, excluding closed work: `project = BLUE AND status NOT IN (Done, Closed, Rejected) AND text ~ "<keywords>" ORDER BY updated DESC`
- To find the user's own tickets, add `AND assignee = currentUser()`.
- If any tickets match, list them for the user (key, summary, status, assignee) and ask which one to use. Include a "none of these, create a new ticket" option. Don't choose for the user.
- If nothing matches, or the user picks "create new", create a BLUE `Task` only after the user approves the implementation plan. Never create the ticket during planning.
  - `summary`: short title for the work
  - `description`: the approved implementation plan
  - Set `customfield_10311` following the Product and Feature rules below.
- Use the ticket key for branch names and commit messages.

## After a PR Is Submitted

When a PR is opened against a ticket, do all of the following:

1. **Comment.** Add a comment to the ticket (`addCommentToJiraIssue`) with the PR link, the PR title, and a one-line summary of the change.
2. **Assign.** Assign the ticket to Brad Holland with `editJiraIssue`: `{"assignee": {"accountId": "5f4e4300e11542004602a7b0"}}`. This edit counts as modifying the ticket, so set `customfield_10311` here too if it's empty.
3. **Move to In Progress.** Act based on the ticket's current status:
   - **Open** or **To Do**: call `getTransitionsForJiraIssue`, pick the transition whose target status (`to.name`) is `In Progress` (named "Start Progress" in the BLUE workflow), and apply it with `transitionJiraIssue`.
   - **In Progress**, **Ready for Test**, **In Test**, **UAT**, or **Ready for Release**: skip this step and tell the user the current status. Never use "Restart Progress", which moves the ticket backward.
   - **On Hold**: don't transition. Tell the user and ask how to proceed.
   - **Done** or **Rejected**: this shouldn't happen, because the PR check blocks it. Don't use "Reopen and start progress". Tell the user.

## Work Types

When creating tickets in the **BLUE** project, only use these work types (`issueTypeName`):

| Work Type | Use for |
| -- | -- |
| Task | Planned implementation work |
| Bug | Defects in existing behavior |
| Support | Research or investigation work |
| Epic | Large bodies of work that group other tickets |

- Never use any other work type. If none of these fits, ask the user.
- **Always get explicit user confirmation before creating an Epic.**

## Product and Feature

When creating or interacting with any non-Epic ticket in the **BLUE** project, ensure `customfield_10311` ("Product and Feature") is set. Include `customfield_10311` in the `fields` array when fetching.

- **Epics are excluded.** Don't set, check, or report on `customfield_10311` for issues where `issuetype` is `Epic`.
- When creating or modifying the ticket, set the field if it's empty.
- When only reading the ticket, don't edit it. Tell the user the field is missing.

Only these five values are valid for BLUE. Never use any other option in the field:

| Product | Option ID |
| -- | -- |
| Gateway | `23185` |
| PMP InterConnect | `23195` |
| NarxCare/SafeScripts+ | `23186` |
| Justice Involved | `23815` |
| Customer Connect | `23232` |

- Pick the best fit based on the ticket's summary, description, components, and epic.
- If unsure, default to **Gateway**.
- Set the Product (parent) only. Leave the Feature (child) unset.
- If the field already holds a value outside this list, don't overwrite it.

Set via `createJiraIssue` (`additional_fields`) or `editJiraIssue` (`fields`):

```json
{"customfield_10311": {"id": "23185"}}
```

If the field is rejected for an issue type, check `getJiraIssueTypeMetaWithFields` for that type.
