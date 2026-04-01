# gnorender

`gnorender` is a small rendering helper library for Gno packages and realms.

It focuses on the most common output patterns used inside
`Render(path string) string` implementations, helping contracts and packages keep
their render logic simple, consistent, and easier to maintain.

## Import

```go
import "gno.land/p/pantani/gnorender"
```

## What The Package Covers

- Titles and sections
- Markdown tables
- ASCII tables
- Panels and empty states
- Bullet and ordered lists
- Description lists
- Links and link lists
- Breadcrumbs
- Tabs and pager links
- Status lines
- Badges and callouts
- Blockquotes and progress bars
- Metrics and stat grids
- Timelines and diffs
- Address and transaction helpers
- Filter bars, cards, and forms
- Object rendering
- Code blocks

## File Organization

The package is split by responsibility:

- `types.gno`: exported enums and structs
- `sections.gno`: titles, sections, dividers, lists, description lists, and empty states
- `formatting.gno`: ordered lists, status lines, badges, callouts, blockquotes, progress bars, and code blocks
- `panel.gno`: box rendering helpers
- `navigation.gno`: links, tabs, pager helpers
- `table.gno`: markdown and ASCII tables
- `widgets.gno`: breadcrumbs, metrics, timelines, diffs, address helpers, filters, cards, forms, and objects
- `helpers.gno`: shared string formatting helpers

## Exported Types

```go
type Format string

const (
	FormatMarkdown Format = "markdown"
	FormatASCII    Format = "ascii"
)

type Align string

const (
	AlignLeft   Align = "left"
	AlignCenter Align = "center"
	AlignRight  Align = "right"
)

type Column struct {
	Label string
	Align Align
	Width int
}

type Table struct {
	Title   string
	Columns []Column
	Rows    [][]string
	Empty   string
	Format  Format
}

type KV struct {
	Key   string
	Value string
}

type Link struct {
	Label  string
	Target string
}

type Metric struct {
	Label string
	Value string
	Delta string
	Kind  NoticeKind
}

type Tab struct {
	ID    string
	Label string
}

type NoticeKind string

const (
	NoticeInfo    NoticeKind = "info"
	NoticeSuccess NoticeKind = "success"
	NoticeWarning NoticeKind = "warning"
	NoticeError   NoticeKind = "error"
)

type TimelineItem struct {
	Time  string
	Title string
	Body  string
	Kind  NoticeKind
}

type Filter struct {
	Label  string
	Value  string
	Target string
	Active bool
}

type Field struct {
	Label    string
	Value    string
	Hint     string
	Required bool
}

type AddressFormat string

const (
	AddressFormatShort AddressFormat = "short"
	AddressFormatLong  AddressFormat = "long"
)

type TxStatusKind string

const (
	TxStatusPending TxStatusKind = "pending"
	TxStatusSuccess TxStatusKind = "success"
	TxStatusFailed  TxStatusKind = "failed"
	TxStatusExpired TxStatusKind = "expired"
)
```

`Format`, `Align`, `Column`, and `Table` are used together through
`Table.Render()`. `KV` is used by `DrawKVTable` and `DrawDescriptionList`,
`Link` is used by `DrawLinkList` and `DrawBreadcrumbs`, `Metric` is used by
`DrawMetric` and `DrawStatGrid`, `Tab` is used by `DrawTabs`,
`TimelineItem` is used by `DrawTimeline`, `Filter` is used by `DrawFilterBar`,
`Field` is used by `DrawField` and `DrawFormPreview`, `NoticeKind` is used by
`DrawBadge` and `DrawCallout`, and `TxStatusKind` is used by `DrawTxStatus`.

## Quick Start

```go
func Render(path string) string {
	title := gnorender.DrawTitle("IBC Transfer")
	status := gnorender.DrawStatus("Client", "active")
	tabs := gnorender.DrawTabs(
		"clients",
		gnorender.Tab{ID: "overview", Label: "Overview"},
		gnorender.Tab{ID: "clients", Label: "Clients"},
	)
	table := gnorender.DrawTable(
		[]string{"Client", "Status"},
		[]string{"07-tendermint-1", "active"},
	)

	return title + "\n\n" + status + "\n\n" + tabs + "\n\n" + table
}
```

Output:

```md
# IBC Transfer

**Client:** active

Overview | [Clients]

| Client | Status |
| :--- | :--- |
| 07-tendermint-1 | active |
```

## Helper Catalog

### DrawTitle

```go
gnorender.DrawTitle("IBC Transfer")
```

Output:

```md
# IBC Transfer
```

### DrawSection

```go
gnorender.DrawSection("Clients", "Registered relayers")
```

Output:

```md
## Clients

Registered relayers
```

### DrawDivider

```go
gnorender.DrawDivider()
```

Output:

```md
---
```

### DrawList

```go
gnorender.DrawList("Ports", []string{"transfer", "bank"})
```

Output:

```md
## Ports

- transfer
- bank
```

### DrawOrderedList

```go
gnorender.DrawOrderedList("Steps", []string{"Create client", "Send packet"})
```

Output:

```md
## Steps

1. Create client
2. Send packet
```

### DrawDescriptionList

```go
gnorender.DrawDescriptionList(
	"Metadata",
	gnorender.KV{Key: "Source", Value: "AtomOne"},
	gnorender.KV{Key: "Destination", Value: "Gno"},
)
```

Output:

```md
## Metadata

- **Source:** AtomOne
- **Destination:** Gno
```

### DrawStatus

```go
gnorender.DrawStatus("Client", "active")
```

Output:

```md
**Client:** active
```

### DrawBadge

```go
gnorender.DrawBadge(gnorender.NoticeSuccess, "Ready")
```

Output:

```md
🟢 Ready
```

### DrawBlockquote

```go
gnorender.DrawBlockquote("Lightweight note\nwith multiple lines.")
```

Output:

```md
> Lightweight note
> with multiple lines.
```

### DrawCallout

```go
gnorender.DrawCallout(
	gnorender.NoticeWarning,
	"Pending packets",
	"Drain the queue before upgrade.",
)
```

Output:

```md
> **🟡 Warning: Pending packets**
>
> Drain the queue before upgrade.
```

### DrawProgressBar

```go
gnorender.DrawProgressBar("Sync", 3, 10, 10)
```

Output:

```md
**Sync:** `[###-------] 30% (3/10)`
```

### DrawCodeBlock

```go
gnorender.DrawCodeBlock("json", "{\"ok\":true}")
```

Output:

````text
```json
{"ok":true}
```
````

### DrawPanel

```go
gnorender.DrawPanel("Transfer", "Escrow ready\nVoucher minted")
```

Output:

```text
+----------------+
|    Transfer    |
+----------------+
| Escrow ready   |
| Voucher minted |
+----------------+
```

When rendering inside Markdown surfaces such as `gnoweb`, wrap ASCII output in
`DrawCodeBlock` so spacing and line breaks are preserved:

```go
gnorender.DrawCodeBlock("text", gnorender.DrawPanel("Transfer", "Escrow ready\nVoucher minted"))
```

### DrawEmptyState

```go
gnorender.DrawEmptyState("Balances", "")
```

Output:

```text
+----------+
| Balances |
+----------+
| No data. |
+----------+
```

Custom body:

```go
gnorender.DrawEmptyState("Balances", "No vouchers minted yet.")
```

Output:

```text
+-------------------------+
|        Balances         |
+-------------------------+
| No vouchers minted yet. |
+-------------------------+
```

### DrawLink

```go
gnorender.DrawLink("Package Docs", "/p/pantani/gnorender")
```

Output:

```md
[Package Docs](/p/pantani/gnorender)
```

### DrawLinkList

```go
gnorender.DrawLinkList(
	"Links",
	gnorender.Link{Label: "Package Docs", Target: "/p/pantani/gnorender"},
	gnorender.Link{Label: "Demo Realm", Target: "/r/pantani/renderdemo"},
)
```

Output:

```md
## Links

- [Package Docs](/p/pantani/gnorender)
- [Demo Realm](/r/pantani/renderdemo)
```

### Higher-Level Widgets

The package also includes higher-level helpers that build on the primitives:

- `DrawBreadcrumbs`
- `DrawMetric`
- `DrawStatGrid`
- `DrawTimeline`
- `DrawDiff`
- `DrawAddress`
- `DrawTxStatus`
- `DrawFilterBar`
- `DrawCard`
- `DrawField`
- `DrawFormPreview`
- `DrawObject`

The easiest way to see them all together is the `renderdemo` realm in this
repository.

### DrawTabs

```go
gnorender.DrawTabs(
	"clients",
	gnorender.Tab{ID: "overview", Label: "Overview"},
	gnorender.Tab{ID: "clients", Label: "Clients"},
)
```

Output:

```text
Overview | [Clients]
```

When `Tab.Label` is empty, `DrawTabs` falls back to `Tab.ID`:

```go
gnorender.DrawTabs(
	"transfers",
	gnorender.Tab{ID: "overview", Label: "Overview"},
	gnorender.Tab{ID: "transfers"},
)
```

Output:

```text
Overview | [transfers]
```

### DrawPager

```go
gnorender.DrawPager(2, 4, "/r/demo/render")
```

Output:

```md
Page 2/4 | [Prev](/r/demo/render?page=1) | [Next](/r/demo/render?page=3)
```

When the base path already has query params, `DrawPager` appends with `&`:

```go
gnorender.DrawPager(3, 5, "/r/demo/render?limit=20")
```

Output:

```md
Page 3/5 | [Prev](/r/demo/render?limit=20&page=2) | [Next](/r/demo/render?limit=20&page=4)
```

### DrawTable

```go
gnorender.DrawTable(
	[]string{"Client", "Status"},
	[]string{"07-tendermint-1", "active"},
)
```

Output:

```md
| Client | Status |
| :--- | :--- |
| 07-tendermint-1 | active |
```

### DrawTableWithTitle

```go
gnorender.DrawTableWithTitle(
	"Clients",
	[]string{"Client", "Status"},
	[]string{"07-tendermint-1", "active"},
	[]string{"10-gno-1", "frozen"},
)
```

Output:

```md
### Clients

| Client | Status |
| :--- | :--- |
| 07-tendermint-1 | active |
| 10-gno-1 | frozen |
```

### DrawKVTable

```go
gnorender.DrawKVTable(
	"Metadata",
	gnorender.KV{Key: "Source", Value: "AtomOne"},
	gnorender.KV{Key: "Destination", Value: "Gno"},
)
```

Output:

```md
### Metadata

| Key | Value |
| :--- | :--- |
| Source | AtomOne |
| Destination | Gno |
```

## Using Table.Render

`Table.Render()` is the configurable entry point for advanced table output. It
uses:

- `FormatMarkdown` or `FormatASCII`
- `Column.Align` for left, center, or right alignment
- `Column.Width` as a minimum width hint
- `Empty` as the empty-table message

### Markdown Table via Table

```go
table := gnorender.Table{
	Title: "Clients",
	Columns: []gnorender.Column{
		{Label: "ID"},
		{Label: "Status"},
	},
	Rows: [][]string{
		{"07-tendermint-1", "active"},
	},
	Format: gnorender.FormatMarkdown,
}

table.Render()
```

Output:

```md
### Clients

| ID | Status |
| :--- | :--- |
| 07-tendermint-1 | active |
```

### ASCII Table With Alignment And Width

```go
table := gnorender.Table{
	Title: "Stats",
	Columns: []gnorender.Column{
		{Label: "Metric", Width: 8},
		{Label: "Value", Align: gnorender.AlignCenter, Width: 7},
		{Label: "Delta", Align: gnorender.AlignRight, Width: 6},
	},
	Rows: [][]string{
		{"Supply", "120", "+4"},
	},
	Format: gnorender.FormatASCII,
}

table.Render()
```

Output:

```text
Stats
+----------+---------+--------+
| Metric   |  Value  |  Delta |
+----------+---------+--------+
| Supply   |   120   |     +4 |
+----------+---------+--------+
```

### Empty Markdown Table

```go
table := gnorender.Table{
	Title: "Clients",
	Columns: []gnorender.Column{
		{Label: "ID"},
		{Label: "Status"},
	},
}

table.Render()
```

Output:

```md
### Clients

| ID | Status |
| :--- | :--- |
| No data. |  |
```

### Empty ASCII Table

```go
table := gnorender.Table{
	Title: "Clients",
	Columns: []gnorender.Column{
		{Label: "ID"},
		{Label: "Status"},
	},
	Format: gnorender.FormatASCII,
	Empty:  "No registered clients.",
}

table.Render()
```

Output:

```text
Clients
+----+-------------------+
| ID | Status            |
+----+-------------------+
| No registered clients. |
+----+-------------------+
```

### Table Without Columns

```go
gnorender.Table{
	Title: "Summary",
	Empty: "Nothing to show.",
}.Render()
```

Output:

```md
## Summary

Nothing to show.
```

## Behavior Notes

- Markdown tables escape `|` and convert line breaks inside cells to `<br>`.
- Empty markdown tables render a single row with the empty message in the first column.
- Empty ASCII tables widen themselves when needed so the empty message fits inside the border.
- Semantic colors are exposed through badges and callouts using colored icons so they remain visible in Markdown renderers.
- ASCII helpers such as `DrawPanel` and `DrawEmptyState` should be wrapped with `DrawCodeBlock` when shown through Markdown renderers like `gnoweb`.
- `DrawAddress` and `DrawTxStatus` shorten long identifiers in their compact forms to keep render output readable.
- `DrawPager` appends `?page=N` or `&page=N` automatically.
