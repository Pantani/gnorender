package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawChecklist(t *testing.T) {
	got := DrawChecklist(
		"Checklist",
		ChecklistItem{Label: "Create client", Done: true},
		ChecklistItem{Label: "Relay packets"},
		ChecklistItem{Label: "Upgrade contract", Blocked: true, Note: "Waiting on audit"},
	)

	uassert.Equal(t, `## Checklist

- [x] Create client
- [ ] Relay packets
- [ ] Upgrade contract · 🟡 Blocked
  Waiting on audit`, got)
}

func TestDrawChecklistFallbacks(t *testing.T) {
	uassert.Equal(t, "## Checklist\n\nNo checklist items.", DrawChecklist("Checklist"))
	uassert.Equal(t, "## Checklist\n\nNo checklist items.", DrawChecklist("Checklist", ChecklistItem{}, ChecklistItem{Label: "   "}))
}

func TestDrawVoteBreakdown(t *testing.T) {
	got := DrawVoteBreakdown("Tally", VoteBreakdown{Yes: 6, No: 2, Abstain: 1, Veto: 1})

	uassert.Equal(t, `### Tally

| Option | Votes | Share | Bar |
| :--- | ---: | :--- | :--- |
| 🟢 Yes | 6 | 60% | [######----] 60% |
| 🔴 No | 2 | 20% | [##--------] 20% |
| 🔵 Abstain | 1 | 10% | [#---------] 10% |
| 🟡 Veto | 1 | 10% | [#---------] 10% |`, got)
}

func TestDrawVoteBreakdownEmpty(t *testing.T) {
	got := DrawVoteBreakdown("Tally", VoteBreakdown{})

	uassert.Equal(t, "## Tally\n\nNo votes.", got)
}

func TestDrawEventLog(t *testing.T) {
	got := DrawEventLog(
		"Events",
		EventEntry{
			Time:    "12:00",
			Type:    "transfer",
			Summary: "packet sent",
			Attributes: []KV{
				{Key: "sender", Value: "alice"},
				{Key: "receiver", Value: "bob"},
			},
		},
	)

	uassert.Equal(t, `## Events

- `+"`12:00`"+` · **transfer** · packet sent
  **sender:** alice
  **receiver:** bob`, got)
}

func TestDrawEventLogFallbacks(t *testing.T) {
	uassert.Equal(t, "## Events\n\nNo events.", DrawEventLog("Events"))
	uassert.Equal(t, "## Events\n\n- **event** · queued", DrawEventLog("Events", EventEntry{Summary: "queued"}))
}

func TestDrawTxReceipt(t *testing.T) {
	got := DrawTxReceipt(TxReceipt{
		Hash:      "ABCDEF1234567890FEDCBA",
		Status:    TxStatusSuccess,
		Sender:    "g1abcdefghijklmno123456789pqrstuv",
		Height:    "123",
		GasWanted: "1000",
		GasUsed:   "800",
		Messages:  []string{"MsgSend"},
		Events: []EventEntry{
			{Time: "12:00", Type: "transfer", Summary: "packet sent", Attributes: []KV{{Key: "amount", Value: "10ugnot"}}},
		},
	})

	uassert.Equal(t, `## Tx Receipt

**Tx:** 🟢 Success · `+"`ABCDEF12...FEDCBA`"+`

## Details

- **Sender:** `+"`g1abcdef...qrstuv`"+`
- **Height:** 123
- **Gas Wanted:** 1000
- **Gas Used:** 800

## Messages

- MsgSend

## Events

- `+"`12:00`"+` · **transfer** · packet sent
  **amount:** 10ugnot`, got)
}

func TestDrawTxReceiptMinimal(t *testing.T) {
	got := DrawTxReceipt(TxReceipt{Status: TxStatusPending})

	uassert.Equal(t, "## Tx Receipt\n\n**Tx:** 🟡 Pending", got)
}

func TestDrawComparisonTable(t *testing.T) {
	got := DrawComparisonTable(
		"Comparison",
		ComparisonRow{Field: "Status", Before: "pending", After: "active"},
		ComparisonRow{Field: "Fee", Before: "10", After: "10"},
	)

	uassert.Equal(t, `### Comparison

| Field | Before | After | Change |
| :--- | :--- | :--- | :--- |
| Status | pending | active | 🟡 Updated |
| Fee | 10 | 10 | 🔵 Same |`, got)
}

func TestDrawComparisonTableFallbacks(t *testing.T) {
	got := DrawComparisonTable(
		"Comparison",
		ComparisonRow{Before: "", After: "enabled"},
		ComparisonRow{Field: "Owner", Before: "alice", After: ""},
	)

	uassert.Equal(t, `### Comparison

| Field | Before | After | Change |
| :--- | :--- | :--- | :--- |
| Value |  | enabled | 🟢 Added |
| Owner | alice |  | 🟡 Removed |`, got)
}

func TestDrawLegend(t *testing.T) {
	got := DrawLegend(
		"Legend",
		LegendItem{Kind: NoticeSuccess, Label: "Healthy", Description: "Everything looks good"},
		LegendItem{Kind: NoticeWarning, Label: "Pending", Description: "Needs attention"},
	)

	uassert.Equal(t, `## Legend

- 🟢 Healthy: Everything looks good
- 🟡 Pending: Needs attention`, got)
}

func TestDrawLegendFallbacks(t *testing.T) {
	got := DrawLegend("Legend", LegendItem{Kind: NoticeError, Description: "Needs attention"})

	uassert.Equal(t, `## Legend

- 🔴 Error: Needs attention`, got)
}

func TestDrawEmptyStateWithAction(t *testing.T) {
	got := DrawEmptyStateWithAction("Balances", "No balances yet.", Link{Label: "Create account", Target: "/r/demo/create"})

	uassert.Equal(t, "```text\n+------------------+\n|     Balances     |\n+------------------+\n| No balances yet. |\n+------------------+\n```\n\n**Next:** [Create account](/r/demo/create)", got)
}

func TestDrawEmptyStateWithActionWithoutAction(t *testing.T) {
	got := DrawEmptyStateWithAction("Balances", "No balances yet.", Link{})

	uassert.Equal(t, "```text\n+------------------+\n|     Balances     |\n+------------------+\n| No balances yet. |\n+------------------+\n```", got)
}

func TestDrawTabsNav(t *testing.T) {
	got := DrawTabsNav("overview",
		Tab{ID: "overview", Label: "Overview", Target: "/r/demo?tab=overview"},
		Tab{ID: "showcase", Label: "Showcase", Target: "/r/demo?tab=showcase"},
		Tab{ID: "settings", Label: "Settings"},
	)

	uassert.Equal(t, "[Overview] | [Showcase](/r/demo?tab=showcase) | Settings", got)
}

func TestDrawTabsNavFallbacks(t *testing.T) {
	got := DrawTabsNav("Settings",
		Tab{ID: "overview", Label: "Overview", Target: "/r"},
		Tab{ID: "cfg", Label: "Settings", Target: "/r/demo?tab=settings"},
		Tab{},
	)

	uassert.Equal(t, "[Overview](/r/) | [Settings]", got)
}
