package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawBreadcrumbs(t *testing.T) {
	got := DrawBreadcrumbs(
		Link{Label: "Home", Target: "/"},
		Link{Label: "Realms", Target: "/r"},
		Link{Label: "Render Demo"},
	)

	uassert.Equal(t, "[Home](/) / [Realms](/r/) / Render Demo", got)
}

func TestDrawMetricAndStatGrid(t *testing.T) {
	metric := DrawMetric(Metric{Label: "Users", Value: "42", Delta: "+2", Kind: NoticeSuccess})
	grid := DrawStatGrid(
		"Stats",
		Metric{Label: "Users", Value: "42", Delta: "+2", Kind: NoticeSuccess},
		Metric{Label: "Errors", Value: "1", Delta: "-1", Kind: NoticeWarning},
	)

	uassert.Equal(t, "**Users:** 42 · 🟢 +2", metric)
	uassert.Equal(t, `### Stats

| Metric | Value | Delta |
| :--- | :--- | :--- |
| Users | 42 | 🟢 +2 |
| Errors | 1 | 🟡 -1 |`, grid)
}

func TestDrawMetricAndStatGridFallbacks(t *testing.T) {
	metric := DrawMetric(Metric{Kind: NoticeInfo})
	grid := DrawStatGrid("Stats")

	uassert.Equal(t, "- · 🔵 Info", metric)
	uassert.Equal(t, "## Stats\n\nNo stats.", grid)
}

func TestDrawTimeline(t *testing.T) {
	got := DrawTimeline(
		"Timeline",
		TimelineItem{Time: "2026-04-01", Title: "Proposal submitted", Kind: NoticeInfo, Body: "Initial draft created."},
		TimelineItem{Time: "2026-04-02", Title: "Upgrade queued", Kind: NoticeWarning},
	)

	uassert.Equal(t, `## Timeline

- `+"`2026-04-01`"+` · **Proposal submitted** · 🔵 Info
  Initial draft created.
- `+"`2026-04-02`"+` · **Upgrade queued** · 🟡 Warning`, got)
}

func TestDrawDiff(t *testing.T) {
	got := DrawDiff("State Diff", "old", "new")

	uassert.Equal(t, "## State Diff\n\n```diff\n- old\n+ new\n```", got)
}

func TestDrawDiffNoChanges(t *testing.T) {
	uassert.Equal(t, "## State Diff\n\nNo changes.", DrawDiff("State Diff", "same", "same"))
	uassert.Equal(t, "No changes.", DrawDiff("", "same", "same"))
}

func TestDrawAddress(t *testing.T) {
	got := DrawAddress("Owner", "g1abcdefghijklmno123456789pqrstuv", AddressFormatShort)

	uassert.Equal(t, "**Owner:** `g1abcdef...qrstuv`", got)
}

func TestDrawAddressFallbacks(t *testing.T) {
	uassert.Equal(t, "`g1abcdefghijklmno123456789pqrstuv`", DrawAddress("", "g1abcdefghijklmno123456789pqrstuv", AddressFormatLong))
	uassert.Equal(t, "Owner", DrawAddress("Owner", "", AddressFormatShort))
}

func TestDrawTxStatus(t *testing.T) {
	got := DrawTxStatus("ABCDEF1234567890FEDCBA", TxStatusSuccess)

	uassert.Equal(t, "**Tx:** 🟢 Success · `ABCDEF12...FEDCBA`", got)
}

func TestDrawFilterBar(t *testing.T) {
	got := DrawFilterBar(
		"Filters",
		Filter{Label: "Status", Value: "Open", Active: true},
		Filter{Label: "Sort", Value: "Newest", Target: "/demo?sort=newest"},
		Filter{Label: "Owner", Value: "pantani"},
	)

	uassert.Equal(t, "**Filters:** [Status: Open] | [Sort: Newest](/demo?sort=newest) | Owner: pantani", got)
}

func TestDrawFilterBarFallbacks(t *testing.T) {
	got := DrawFilterBar("Filters", Filter{}, Filter{Label: "   "})

	uassert.Equal(t, "**Filters:** No filters.", got)
}

func TestDrawCard(t *testing.T) {
	got := DrawCard("Treasury", "120,000 ATOM available.")

	uassert.Equal(t, `> **Treasury**
>
> 120,000 ATOM available.`, got)
}

func TestDrawCardFallbacks(t *testing.T) {
	uassert.Equal(t, "> Body only", DrawCard("", "Body only"))
	uassert.Equal(t, "", DrawCard("", ""))
}

func TestDrawFieldAndFormPreview(t *testing.T) {
	field := DrawField(Field{
		Label:    "Realm Name",
		Value:    "renderdemo",
		Hint:     "Use a stable path",
		Required: true,
	})
	form := DrawFormPreview(
		"Form Preview",
		Field{Label: "Realm Name", Value: "renderdemo", Hint: "Use a stable path", Required: true},
		Field{Label: "Owner", Value: "pantani"},
	)

	uassert.Equal(t, "**Realm Name:** renderdemo _(required)_\n_Hint: Use a stable path_", field)
	uassert.Equal(t, `## Form Preview

**Realm Name:** renderdemo _(required)_
_Hint: Use a stable path_

**Owner:** pantani`, form)
}

func TestDrawObject(t *testing.T) {
	got := DrawObject("Config",
		KV{Key: "chain_id", Value: "dev"},
		KV{Key: "owner", Value: "pantani"},
	)

	uassert.Equal(t, "## Config\n\n```json\n{\n  \"chain_id\": \"dev\",\n  \"owner\": \"pantani\"\n}\n```", got)
}

func TestDrawFormPreviewAndObjectEmpty(t *testing.T) {
	uassert.Equal(t, "## Form Preview\n\nNo fields.", DrawFormPreview("Form Preview"))
	uassert.Equal(t, "## Config\n\nNo fields.", DrawObject("Config"))
}
