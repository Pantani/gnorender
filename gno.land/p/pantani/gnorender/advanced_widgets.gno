package gnorender

import (
	"strings"

	"gno.land/p/nt/ufmt/v0"
)

func DrawChecklist(title string, items ...ChecklistItem) string {
	if len(items) == 0 {
		return DrawSection(title, "No checklist items.")
	}

	var sb strings.Builder
	count := 0
	for _, item := range items {
		label := normalizeInline(item.Label)
		if label == "" {
			continue
		}
		if count > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString("- ")
		sb.WriteString(checklistPrefix(item))
		sb.WriteString(" ")
		sb.WriteString(label)
		if item.Blocked && !item.Done {
			sb.WriteString(" · ")
			sb.WriteString(DrawBadge(NoticeWarning, "Blocked"))
		}
		note := normalizeInline(item.Note)
		if note != "" {
			sb.WriteString("\n  ")
			sb.WriteString(note)
		}
		count++
	}
	if count == 0 {
		return DrawSection(title, "No checklist items.")
	}
	return DrawSection(title, sb.String())
}

func DrawVoteBreakdown(title string, breakdown VoteBreakdown) string {
	total := voteTotal(breakdown)
	if total == 0 {
		return DrawSection(title, "No votes.")
	}

	rows := [][]string{
		voteRow("Yes", breakdown.Yes, total, NoticeSuccess),
		voteRow("No", breakdown.No, total, NoticeError),
		voteRow("Abstain", breakdown.Abstain, total, NoticeInfo),
		voteRow("Veto", breakdown.Veto, total, NoticeWarning),
	}

	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Option"},
			{Label: "Votes", Align: AlignRight},
			{Label: "Share"},
			{Label: "Bar"},
		},
		Rows:   rows,
		Format: FormatMarkdown,
	}.Render()
}

func DrawEventLog(title string, events ...EventEntry) string {
	if len(events) == 0 {
		return DrawSection(title, "No events.")
	}

	var sb strings.Builder
	count := 0
	for _, event := range events {
		entry := drawEventEntry(event)
		if entry == "" {
			continue
		}
		if count > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString(entry)
		count++
	}
	if count == 0 {
		return DrawSection(title, "No events.")
	}
	return DrawSection(title, sb.String())
}

func DrawTxReceipt(receipt TxReceipt) string {
	details := make([]KV, 0, 4)
	details = appendKVIfValue(details, "Sender", DrawAddress("", receipt.Sender, AddressFormatShort))
	details = appendKVIfValue(details, "Height", receipt.Height)
	details = appendKVIfValue(details, "Gas Wanted", receipt.GasWanted)
	details = appendKVIfValue(details, "Gas Used", receipt.GasUsed)

	parts := []string{
		DrawTxStatus(receipt.Hash, receipt.Status),
	}
	if len(details) > 0 {
		parts = append(parts, DrawDescriptionList("Details", details...))
	}
	if len(receipt.Messages) > 0 {
		parts = append(parts, DrawList("Messages", receipt.Messages))
	}
	if len(receipt.Events) > 0 {
		parts = append(parts, DrawEventLog("Events", receipt.Events...))
	}
	return DrawSection("Tx Receipt", joinNonEmpty(parts...))
}

func DrawComparisonTable(title string, rows ...ComparisonRow) string {
	if len(rows) == 0 {
		return DrawSection(title, "No values to compare.")
	}

	tableRows := make([][]string, 0, len(rows))
	for _, row := range rows {
		field := normalizeInline(row.Field)
		if field == "" {
			field = "Value"
		}
		tableRows = append(tableRows, []string{
			field,
			strings.TrimSpace(row.Before),
			strings.TrimSpace(row.After),
			changeLabel(row.Before, row.After),
		})
	}

	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Field"},
			{Label: "Before"},
			{Label: "After"},
			{Label: "Change"},
		},
		Rows:   tableRows,
		Format: FormatMarkdown,
	}.Render()
}

func DrawLegend(title string, items ...LegendItem) string {
	if len(items) == 0 {
		return DrawSection(title, "No legend items.")
	}

	var sb strings.Builder
	count := 0
	for _, item := range items {
		label := normalizeInline(item.Label)
		if label == "" {
			label = calloutLabel(item.Kind)
		}
		if label == "" {
			continue
		}
		if count > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString("- ")
		sb.WriteString(DrawBadge(item.Kind, label))
		desc := normalizeInline(item.Description)
		if desc != "" {
			sb.WriteString(": ")
			sb.WriteString(desc)
		}
		count++
	}
	if count == 0 {
		return DrawSection(title, "No legend items.")
	}
	return DrawSection(title, sb.String())
}

func DrawEmptyStateWithAction(title, body string, action Link) string {
	parts := []string{
		DrawCodeBlock("text", DrawEmptyState(title, body)),
	}
	actionLine := DrawLink(action.Label, action.Target)
	if actionLine != "" {
		parts = append(parts, DrawStatus("Next", actionLine))
	}
	return joinNonEmpty(parts...)
}

func DrawTabsNav(selected string, tabs ...Tab) string {
	var labels []string
	for _, tab := range tabs {
		label := strings.TrimSpace(tab.Label)
		if label == "" {
			label = strings.TrimSpace(tab.ID)
		}
		if label == "" {
			continue
		}
		if selected != "" && (selected == tab.ID || selected == tab.Label) {
			labels = append(labels, "["+label+"]")
			continue
		}
		if strings.TrimSpace(tab.Target) != "" {
			labels = append(labels, DrawLink(label, tab.Target))
			continue
		}
		labels = append(labels, label)
	}
	return strings.Join(labels, " | ")
}

func checklistPrefix(item ChecklistItem) string {
	switch {
	case item.Done:
		return "[x]"
	default:
		return "[ ]"
	}
}

func voteRow(label string, votes, total int, kind NoticeKind) []string {
	share := 0
	if total > 0 {
		share = votes * 100 / total
	}
	return []string{
		DrawBadge(kind, label),
		ufmt.Sprintf("%d", votes),
		ufmt.Sprintf("%d%%", share),
		progressInline(votes, total, 10),
	}
}

func drawEventEntry(event EventEntry) string {
	parts := []string{}
	if strings.TrimSpace(event.Time) != "" {
		parts = append(parts, "`"+strings.TrimSpace(event.Time)+"`")
	}
	eventType := normalizeInline(event.Type)
	if eventType == "" {
		eventType = "event"
	}
	parts = append(parts, "**"+eventType+"**")
	if summary := normalizeInline(event.Summary); summary != "" {
		parts = append(parts, summary)
	}

	var sb strings.Builder
	sb.WriteString("- ")
	sb.WriteString(strings.Join(parts, " · "))
	for _, attr := range event.Attributes {
		line := strings.TrimSpace(DrawStatus(attr.Key, attr.Value))
		if line == "" {
			continue
		}
		sb.WriteString("\n  ")
		sb.WriteString(line)
	}
	return sb.String()
}

func changeLabel(before, after string) string {
	before = strings.TrimSpace(before)
	after = strings.TrimSpace(after)
	switch {
	case before == after:
		return DrawBadge(NoticeInfo, "Same")
	case before == "":
		return DrawBadge(NoticeSuccess, "Added")
	case after == "":
		return DrawBadge(NoticeWarning, "Removed")
	default:
		return DrawBadge(NoticeWarning, "Updated")
	}
}

func voteTotal(breakdown VoteBreakdown) int {
	return breakdown.Yes + breakdown.No + breakdown.Abstain + breakdown.Veto
}

func progressInline(current, total, width int) string {
	if current < 0 {
		current = 0
	}
	if total < 0 {
		total = 0
	}
	if total > 0 && current > total {
		current = total
	}
	if width <= 0 {
		width = 10
	}

	filled := 0
	percent := 0
	if total > 0 {
		filled = current * width / total
		percent = current * 100 / total
	}

	return ufmt.Sprintf("[%s%s] %d%%",
		repeat("#", filled),
		repeat("-", width-filled),
		percent,
	)
}
