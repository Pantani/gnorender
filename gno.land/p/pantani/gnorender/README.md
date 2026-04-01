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
- Tabs and pager links
- Status lines
- Code blocks

## File Organization

The package is split by responsibility:

- `types.gno`: exported enums and structs
- `sections.gno`: titles, sections, dividers, lists, and empty states
- `formatting.gno`: ordered lists, status lines, and code blocks
- `panel.gno`: box rendering helpers
- `navigation.gno`: tabs and pager helpers
- `table.gno`: markdown and ASCII tables
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

type Tab struct {
	ID    string
	Label string
}
```

`Format`, `Align`, `Column`, and `Table` are used together through
`Table.Render()`. `KV` is used by `DrawKVTable`, and `Tab` is used by
`DrawTabs`.

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

### DrawStatus

```go
gnorender.DrawStatus("Client", "active")
```

Output:

```md
**Client:** active
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
- `DrawPager` appends `?page=N` or `&page=N` automatically.
