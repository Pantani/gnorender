package gnorender

import (
	"strings"

	"gno.land/p/nt/ufmt/v0"
)

func DrawBreadcrumbs(links ...Link) string {
	var crumbs []string
	for _, link := range links {
		label := normalizeInline(link.Label)
		target := strings.TrimSpace(link.Target)
		if label == "" {
			label = target
		}
		if label == "" {
			continue
		}
		if target == "" {
			crumbs = append(crumbs, label)
			continue
		}
		crumbs = append(crumbs, DrawLink(label, target))
	}
	return strings.Join(crumbs, " / ")
}

func DrawMetric(metric Metric) string {
	label := normalizeInline(metric.Label)
	value := strings.TrimSpace(metric.Value)
	if value == "" {
		value = "-"
	}

	body := value
	delta := drawMetricDelta(metric)
	if delta != "" {
		body += " · " + delta
	}
	if label == "" {
		return body
	}
	return ufmt.Sprintf("**%s:** %s", label, body)
}

func DrawStatGrid(title string, metrics ...Metric) string {
	if len(metrics) == 0 {
		return DrawSection(title, "No stats.")
	}

	rows := make([][]string, 0, len(metrics))
	for _, metric := range metrics {
		label := normalizeInline(metric.Label)
		if label == "" {
			label = "Metric"
		}
		value := strings.TrimSpace(metric.Value)
		if value == "" {
			value = "-"
		}
		rows = append(rows, []string{
			label,
			value,
			drawMetricDelta(metric),
		})
	}

	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Metric"},
			{Label: "Value"},
			{Label: "Delta"},
		},
		Rows:   rows,
		Format: FormatMarkdown,
	}.Render()
}

func DrawTimeline(title string, items ...TimelineItem) string {
	if len(items) == 0 {
		return DrawSection(title, "No events.")
	}

	var sb strings.Builder
	count := 0
	for _, item := range items {
		headline := drawTimelineHeadline(item)
		body := strings.TrimSpace(item.Body)
		if headline == "" && body == "" {
			continue
		}
		if count > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString("- ")
		sb.WriteString(headline)
		if body != "" {
			for _, line := range splitLines(body) {
				sb.WriteString("\n  ")
				sb.WriteString(strings.TrimSpace(line))
			}
		}
		count++
	}
	if count == 0 {
		return DrawSection(title, "No events.")
	}
	return DrawSection(title, sb.String())
}

func DrawDiff(title, before, after string) string {
	before = strings.TrimSpace(before)
	after = strings.TrimSpace(after)
	if before == after {
		if title == "" {
			return "No changes."
		}
		return DrawSection(title, "No changes.")
	}

	var lines []string
	for _, line := range splitLines(before) {
		lines = append(lines, "- "+line)
	}
	for _, line := range splitLines(after) {
		lines = append(lines, "+ "+line)
	}

	body := DrawCodeBlock("diff", strings.Join(lines, "\n"))
	if title == "" {
		return body
	}
	return DrawSection(title, body)
}

func DrawAddress(label, addr string, format AddressFormat) string {
	addr = strings.TrimSpace(addr)
	if addr == "" {
		return strings.TrimSpace(label)
	}

	display := addr
	switch format {
	case AddressFormatLong:
		display = addr
	default:
		display = shortenMiddle(addr, 8, 6)
	}

	if strings.TrimSpace(label) == "" {
		return "`" + display + "`"
	}
	return ufmt.Sprintf("**%s:** `%s`", strings.TrimSpace(label), display)
}

func DrawTxStatus(txHash string, kind TxStatusKind) string {
	label := txStatusLabel(kind)
	status := DrawBadge(txStatusNotice(kind), label)
	hash := strings.TrimSpace(txHash)
	if hash == "" {
		return "**Tx:** " + status
	}
	return ufmt.Sprintf("**Tx:** %s · `%s`", status, shortenMiddle(hash, 8, 6))
}

func DrawFilterBar(title string, filters ...Filter) string {
	if len(filters) == 0 {
		return DrawStatus(title, "No filters.")
	}

	parts := make([]string, 0, len(filters))
	for _, filter := range filters {
		item := drawFilter(filter)
		if item == "" {
			continue
		}
		parts = append(parts, item)
	}
	if len(parts) == 0 {
		return DrawStatus(title, "No filters.")
	}

	bar := strings.Join(parts, " | ")
	if strings.TrimSpace(title) == "" {
		return bar
	}
	return ufmt.Sprintf("**%s:** %s", strings.TrimSpace(title), bar)
}

func DrawCard(title, body string) string {
	title = normalizeInline(title)
	body = strings.TrimSpace(body)
	switch {
	case title == "" && body == "":
		return ""
	case title == "":
		return DrawBlockquote(body)
	case body == "":
		return DrawBlockquote("**" + title + "**")
	default:
		return DrawBlockquote("**" + title + "**\n\n" + body)
	}
}

func DrawField(field Field) string {
	label := normalizeInline(field.Label)
	value := strings.TrimSpace(field.Value)
	hint := normalizeInline(field.Hint)

	if label == "" {
		label = "Field"
	}
	if value == "" {
		value = "_empty_"
	}

	line := ufmt.Sprintf("**%s:** %s", label, value)
	if field.Required {
		line += " _(required)_"
	}
	if hint == "" {
		return line
	}
	return line + "\n_Hint: " + hint + "_"
}

func DrawFormPreview(title string, fields ...Field) string {
	if len(fields) == 0 {
		return DrawSection(title, "No fields.")
	}

	parts := make([]string, 0, len(fields))
	for _, field := range fields {
		parts = append(parts, DrawField(field))
	}
	return DrawSection(title, strings.Join(parts, "\n\n"))
}

func DrawObject(title string, pairs ...KV) string {
	if len(pairs) == 0 {
		return DrawSection(title, "No fields.")
	}

	var sb strings.Builder
	sb.WriteString("{\n")
	for i, pair := range pairs {
		if i > 0 {
			sb.WriteString(",\n")
		}
		sb.WriteString(`  "`)
		sb.WriteString(escapeJSONString(strings.TrimSpace(pair.Key)))
		sb.WriteString(`": "`)
		sb.WriteString(escapeJSONString(strings.TrimSpace(pair.Value)))
		sb.WriteString(`"`)
	}
	sb.WriteString("\n}")

	body := DrawCodeBlock("json", sb.String())
	if title == "" {
		return body
	}
	return DrawSection(title, body)
}

func drawMetricDelta(metric Metric) string {
	delta := strings.TrimSpace(metric.Delta)
	switch {
	case delta != "" && metric.Kind != "":
		return DrawBadge(metric.Kind, delta)
	case delta != "":
		return delta
	case metric.Kind != "":
		return DrawBadge(metric.Kind, calloutLabel(metric.Kind))
	default:
		return ""
	}
}

func drawTimelineHeadline(item TimelineItem) string {
	title := normalizeInline(item.Title)
	if title == "" {
		title = "Event"
	}

	parts := []string{"**" + title + "**"}
	if strings.TrimSpace(item.Time) != "" {
		parts = append([]string{"`" + strings.TrimSpace(item.Time) + "`"}, parts...)
	}
	if item.Kind != "" {
		parts = append(parts, DrawBadge(item.Kind, calloutLabel(item.Kind)))
	}
	return strings.Join(parts, " · ")
}

func drawFilter(filter Filter) string {
	label := normalizeInline(filter.Label)
	value := normalizeInline(filter.Value)
	target := strings.TrimSpace(filter.Target)

	text := label
	if value != "" {
		if text != "" {
			text += ": "
		}
		text += value
	}
	if text == "" {
		return ""
	}
	if filter.Active {
		return "[" + text + "]"
	}
	if target != "" {
		return DrawLink(text, target)
	}
	return text
}

func txStatusLabel(kind TxStatusKind) string {
	switch kind {
	case TxStatusPending:
		return "Pending"
	case TxStatusSuccess:
		return "Success"
	case TxStatusFailed:
		return "Failed"
	case TxStatusExpired:
		return "Expired"
	default:
		return "Unknown"
	}
}

func txStatusNotice(kind TxStatusKind) NoticeKind {
	switch kind {
	case TxStatusPending:
		return NoticeWarning
	case TxStatusSuccess:
		return NoticeSuccess
	case TxStatusFailed:
		return NoticeError
	case TxStatusExpired:
		return NoticeWarning
	default:
		return NoticeInfo
	}
}
