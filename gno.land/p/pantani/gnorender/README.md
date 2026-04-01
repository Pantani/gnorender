# gnorender

`gnorender` is a rendering helper library for Gno packages and realms.

It keeps `Render(path string) string` implementations small and composable by
providing helpers for layout, navigation, data presentation, workflow/status
views, and Gno-specific contract metadata.

## Import

```go
import "gno.land/p/pantani/gnorender"
```

## Feature Overview

- Structure: titles, sections, dividers, bullet lists, ordered lists, description lists
- Navigation: links, link lists, breadcrumbs, tabs, linked tabs, pagers, filter bars
- Formatting: status lines, badges, blockquotes, callouts, progress bars, code blocks
- Data views: markdown tables, ASCII tables, key/value tables, comparison tables, object rendering
- Workflow widgets: checklists, timelines, diffs, legends, event logs, empty states with actions
- Transactions and governance: addresses, tx status, tx receipts, vote breakdowns, proposal summaries
- Gno-specific helpers: realm/package headers, method lists, balances, validators, address books, metadata, realm indexes

## File Organization

- `types.gno`: exported types and enums
- `sections.gno`: titles, sections, dividers, lists, description lists, empty states
- `formatting.gno`: ordered lists, status lines, badges, blockquotes, callouts, progress bars, code blocks
- `panel.gno`: ASCII panel rendering
- `navigation.gno`: links, link lists, tabs, linked tabs, pager helpers
- `table.gno`: markdown and ASCII tables
- `widgets.gno`: breadcrumbs, metrics, timelines, diffs, addresses, filters, cards, forms, objects
- `advanced_widgets.gno`: checklist, legend, comparison, event log, tx receipt, empty states with actions, linked tabs
- `gno_widgets.gno`: realm/package metadata, governance, balances, validators, address books, realm index
- `helpers.gno`: shared formatting helpers

## Exported Types

Table rendering:

- `Format`, `Align`, `Column`, `Table`

Shared data:

- `KV`, `Link`, `Tab`

Workflow and status:

- `NoticeKind`, `ChecklistItem`, `TimelineItem`, `VoteBreakdown`, `EventEntry`
- `ComparisonRow`, `LegendItem`

Metrics and forms:

- `Metric`, `Filter`, `Field`

Transactions and addresses:

- `AddressFormat`, `TxStatusKind`, `TxReceipt`

Gno-specific domain types:

- `Method`, `CoinBalance`, `ProposalSummary`, `Validator`
- `AddressEntry`, `ContractMetadata`, `RealmPage`

## Quick Start

```go
package demo

import "gno.land/p/pantani/gnorender"

func Render(path string) string {
	return gnorender.DrawTitle("IBC Dashboard") + "\n\n" +
		gnorender.DrawBreadcrumbs(
			gnorender.Link{Label: "Home", Target: "/"},
			gnorender.Link{Label: "Realms", Target: "/r/"},
			gnorender.Link{Label: "IBC Dashboard"},
		) + "\n\n" +
		gnorender.DrawTabsNav(
			"overview",
			gnorender.Tab{ID: "overview", Label: "Overview", Target: "/r/demo"},
			gnorender.Tab{ID: "packets", Label: "Packets", Target: "/r/demo?tab=packets"},
		) + "\n\n" +
		gnorender.DrawStatGrid(
			"Stats",
			gnorender.Metric{Label: "Packets", Value: "128", Delta: "+18", Kind: gnorender.NoticeSuccess},
			gnorender.Metric{Label: "Pending", Value: "7", Delta: "-3", Kind: gnorender.NoticeWarning},
		)
}
```

## Helper Groups

Layout and sections:

- `DrawTitle`
- `DrawSection`
- `DrawDivider`
- `DrawList`
- `DrawOrderedList`
- `DrawDescriptionList`
- `DrawStatus`

Formatting and emphasis:

- `DrawBadge`
- `DrawBlockquote`
- `DrawCallout`
- `DrawProgressBar`
- `DrawCodeBlock`
- `DrawPanel`
- `DrawEmptyState`
- `DrawEmptyStateWithAction`
- `DrawCard`

Navigation:

- `DrawLink`
- `DrawLinkList`
- `DrawBreadcrumbs`
- `DrawTabs`
- `DrawTabsNav`
- `DrawPager`
- `DrawFilterBar`

Tables and object rendering:

- `DrawTable`
- `DrawTableWithTitle`
- `DrawKVTable`
- `Table.Render()`
- `DrawComparisonTable`
- `DrawObject`

Metrics, forms, and state:

- `DrawMetric`
- `DrawStatGrid`
- `DrawField`
- `DrawFormPreview`
- `DrawTimeline`
- `DrawDiff`
- `DrawChecklist`
- `DrawLegend`
- `DrawEventLog`

Transactions and governance:

- `DrawAddress`
- `DrawTxStatus`
- `DrawTxReceipt`
- `DrawVoteBreakdown`
- `DrawGovernanceTally`
- `DrawProposalSummary`

Gno-specific helpers:

- `DrawRealmHeader`
- `DrawPackageHeader`
- `DrawMethodList`
- `DrawBalanceList`
- `DrawCoins`
- `DrawValidatorList`
- `DrawAddressBook`
- `DrawContractMetadata`
- `DrawRealmIndex`

## Common Patterns

### Markdown Tables

```go
gnorender.DrawTable(
	[]string{"Client", "Status"},
	[]string{"07-tendermint-1", "active"},
	[]string{"07-tendermint-2", "frozen"},
)
```

### Linked Tabs

```go
gnorender.DrawTabsNav(
	"overview",
	gnorender.Tab{ID: "overview", Label: "Overview", Target: "/r/demo"},
	gnorender.Tab{ID: "methods", Label: "Methods", Target: "/r/demo?tab=methods"},
	gnorender.Tab{ID: "state", Label: "State", Target: "/r/demo?tab=state"},
)
```

### Checklist and Callouts

```go
gnorender.DrawChecklist(
	"Upgrade Checklist",
	gnorender.ChecklistItem{Label: "Drain packets", Done: true},
	gnorender.ChecklistItem{Label: "Run migration"},
	gnorender.ChecklistItem{Label: "Broadcast proposal", Blocked: true, Note: "Waiting on multisig"},
)
```

### Transaction Receipt

```go
gnorender.DrawTxReceipt(gnorender.TxReceipt{
	Hash:      "ABCDEF1234567890FEDCBA",
	Status:    gnorender.TxStatusSuccess,
	Sender:    "g1abcdefghijklmno123456789pqrstuv",
	Height:    "123",
	GasWanted: "1000",
	GasUsed:   "800",
	Messages:  []string{"MsgSend"},
})
```

### Gno Realm Header

```go
gnorender.DrawRealmHeader(
	"Render Demo",
	"/r/pantani/renderdemo",
	"g1abcdefghijklmno123456789pqrstuv",
	"A showcase realm for gnorender.",
)
```

## Notes

- `DrawPanel`, `DrawEmptyState`, and other ASCII-heavy helpers should usually be wrapped in `DrawCodeBlock("text", ...)` when rendered through `gnoweb`
- `DrawLink` normalizes exact root section links like `/r`, `/p`, and `/e` into `/r/`, `/p/`, and `/e/`
- `DrawTabs` is visual-only, while `DrawTabsNav` is intended for clickable tab navigation

## Demo Realm

The repository includes a showcase realm at
`gno.land/r/pantani/renderdemo`. It renders the helper catalog in one page so
you can visually inspect output in `gnoweb`.

## Testing

From the repository root:

```sh
gno test ./gno.land/p/pantani/gnorender
```

Or:

```sh
go tool gno test ./gno.land/p/pantani/gnorender
```
