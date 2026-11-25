# CAB Tickets

Use `hbuco.atlassian.net` as the `cloudId`.

## Self-Service Change Requests

Create CAB tickets with `createJiraIssue`:

- Project `CAB`, issue type `[System] Change`
- Request type: set `customfield_11500` to `"325"` ("BLUE Team CAB Change")
- Don't set `customfield_10311`. The BLUE Product and Feature rules don't apply to CAB.
- Don't transition the ticket. The CAB workflow moves it to Implementing on create.

| Field | ID | Default |
| -- | -- | -- |
| Change type | `customfield_11852` | Self Service (`23806`) |
| Impact | `customfield_11851` | Minor / Localized (`24806`) |
| Change risk | `customfield_11853` | Low (`24810`) |
| Team Ownership | `customfield_12675` | Blue (`23794`) |
| Planned start / end | `customfield_12050` / `customfield_12051` | Ask. "ASAP" means the current time, with offset |
| Description of Change | `customfield_13183` |  |
| Detailed Description of Change | `customfield_12791` |  |
| Implementation plan | `customfield_12047` |  |
| Backout plan | `customfield_12048` |  |
| Test plan | `customfield_12049` |  |

Always default Team Ownership to Blue, even when another team does the work.

## Formatting

The MCP converts markdown into Jira wiki markup. Only `description` and `customfield_13183` render it. The other textarea fields use the plain-text renderer and show the markup literally (`{{x}}`, `{code:bash}`, `[url|url|smart-link]`).

For `customfield_12047`, `customfield_12791`, `customfield_12048`, and `customfield_12049`:

- Write plain text only: no backticks, code fences, bold, lists, or markdown links.
- Put each CLI command on one line, without `\` continuations.
- Separate paragraphs with a blank line.
- Don't include URLs. The MCP turns bare URLs into `[url|url|smart-link]`, which these fields show literally. Put links in `customfield_13183` instead.

After creating or editing a ticket, fetch it with `expand: renderedFields`. Check that none of those fields contain `{{`, `{code`, or `|smart-link]`.

## Link to a BLUE Ticket

Link every CAB ticket to its BLUE ticket.

1. Before creating the CAB ticket, find the BLUE ticket with the "Find or Create a Ticket" steps in `blue-jira.md`. List the matches and let the user choose. Don't create the CAB ticket until a BLUE ticket is chosen.
2. After creating the CAB ticket, link it to the BLUE ticket with `createIssueLink`, using `Relates` unless the user states another relationship.
3. Put the BLUE key in Description of Change (`customfield_13183`) as a markdown link: `[BLUE-123](https://hbuco.atlassian.net/browse/BLUE-123)`. Don't put it in the plain-text fields.
4. If the link fails, tell the user which ticket failed and why.

If the work is `BLUE-0`, skip this section. Never link to, mention, or hyperlink `BLUE-0` on a CAB ticket.

## Commands in the Implementation Plan

Include the exact command for the team doing the change. Resolve ARNs, account IDs, and regions from the live resource or a completed CAB ticket for the same resource, and say which one you used.
