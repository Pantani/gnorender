package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawTable(t *testing.T) {
	got := DrawTable(
		[]string{"Client", "Status"},
		[]string{"07-tendermint-1", "active"},
	)

	uassert.Equal(t, `| Client | Status |
| :--- | :--- |
| 07-tendermint-1 | active |`, got)
}

func TestDrawTableMarkdown(t *testing.T) {
	got := DrawTableWithTitle(
		"Clients",
		[]string{"Client", "Status"},
		[]string{"07-tendermint-1", "active"},
		[]string{"10-gno-1", "frozen"},
	)

	uassert.Equal(t, `### Clients

| Client | Status |
| :--- | :--- |
| 07-tendermint-1 | active |
| 10-gno-1 | frozen |`, got)
}

func TestDrawKVTable(t *testing.T) {
	got := DrawKVTable(
		"Metadata",
		KV{Key: "Source", Value: "AtomOne"},
		KV{Key: "Destination", Value: "Gno"},
	)

	uassert.Equal(t, `### Metadata

| Key | Value |
| :--- | :--- |
| Source | AtomOne |
| Destination | Gno |`, got)
}

func TestTableRenderASCII(t *testing.T) {
	got := Table{
		Title: "Packets",
		Columns: []Column{
			{Label: "Client"},
			{Label: "Sequence", Align: AlignRight},
		},
		Rows: [][]string{
			{"07-tendermint-1", "12"},
		},
		Format: FormatASCII,
	}.Render()

	uassert.Equal(t, `Packets
+-----------------+----------+
| Client          | Sequence |
+-----------------+----------+
| 07-tendermint-1 |       12 |
+-----------------+----------+`, got)
}

func TestTableRenderASCIIWithWidthAndAlignment(t *testing.T) {
	got := Table{
		Title: "Stats",
		Columns: []Column{
			{Label: "Metric", Width: 8},
			{Label: "Value", Align: AlignCenter, Width: 7},
			{Label: "Delta", Align: AlignRight, Width: 6},
		},
		Rows: [][]string{
			{"Supply", "120", "+4"},
		},
		Format: FormatASCII,
	}.Render()

	uassert.Equal(t, `Stats
+----------+---------+--------+
| Metric   |  Value  |  Delta |
+----------+---------+--------+
| Supply   |   120   |     +4 |
+----------+---------+--------+`, got)
}

func TestTableRenderEmptyASCII(t *testing.T) {
	got := Table{
		Title: "Clients",
		Columns: []Column{
			{Label: "ID"},
			{Label: "Status"},
		},
		Format: FormatASCII,
		Empty:  "No registered clients.",
	}.Render()

	uassert.Equal(t, `Clients
+----+-------------------+
| ID | Status            |
+----+-------------------+
| No registered clients. |
+----+-------------------+`, got)
}

func TestTableRenderMarkdownEmptyAndNoColumns(t *testing.T) {
	emptyMarkdown := Table{
		Title: "Clients",
		Columns: []Column{
			{Label: "ID"},
			{Label: "Status"},
		},
	}.Render()

	noColumns := Table{
		Title: "Summary",
		Empty: "Nothing to show.",
	}.Render()

	onlyEmpty := Table{
		Empty: "Nothing to show.",
	}.Render()

	uassert.Equal(t, `### Clients

| ID | Status |
| :--- | :--- |
| No data. |  |`, emptyMarkdown)
	uassert.Equal(t, "## Summary\n\nNothing to show.", noColumns)
	uassert.Equal(t, "Nothing to show.", onlyEmpty)
}

func TestMarkdownTableEscapesCells(t *testing.T) {
	got := Table{
		Columns: []Column{
			{Label: "Name|ID"},
			{Label: "Notes"},
		},
		Rows: [][]string{
			{"a|b", "line 1\nline 2"},
		},
	}.Render()

	uassert.Equal(t, `| Name\|ID | Notes |
| :--- | :--- |
| a\|b | line 1<br>line 2 |`, got)
}

func TestTableRenderMarkdownAutoExpandsColumns(t *testing.T) {
	got := Table{
		Columns: []Column{
			{Label: "Key"},
		},
		Rows: [][]string{
			{"chain_id", "dev"},
		},
	}.Render()

	uassert.Equal(t, `| Key |  |
| :--- | :--- |
| chain_id | dev |`, got)
}
