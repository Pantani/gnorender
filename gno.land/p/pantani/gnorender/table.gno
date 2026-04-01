package gnorender

import "strings"

func DrawTable(columns []string, rows ...[]string) string {
	return DrawTableWithTitle("", columns, rows...)
}

func DrawTableWithTitle(title string, columns []string, rows ...[]string) string {
	return Table{
		Title:   title,
		Columns: columnsFromLabels(columns),
		Rows:    rows,
		Format:  FormatMarkdown,
	}.Render()
}

func DrawKVTable(title string, pairs ...KV) string {
	rows := make([][]string, 0, len(pairs))
	for _, pair := range pairs {
		rows = append(rows, []string{pair.Key, pair.Value})
	}
	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Key"},
			{Label: "Value"},
		},
		Rows:   rows,
		Format: FormatMarkdown,
	}.Render()
}

func (t Table) Render() string {
	t = normalizeTable(t)
	if len(t.Columns) == 0 {
		if t.Title != "" {
			return DrawSection(t.Title, t.Empty)
		}
		return t.Empty
	}

	switch t.Format {
	case FormatASCII:
		return renderASCIITable(t)
	default:
		return renderMarkdownTable(t)
	}
}

func normalizeTable(t Table) Table {
	if t.Empty == "" {
		t.Empty = "No data."
	}
	if t.Format == "" {
		t.Format = FormatMarkdown
	}

	maxCols := len(t.Columns)
	for _, row := range t.Rows {
		if len(row) > maxCols {
			maxCols = len(row)
		}
	}
	for len(t.Columns) < maxCols {
		t.Columns = append(t.Columns, Column{})
	}
	return t
}

func renderMarkdownTable(t Table) string {
	var rows [][]string
	if len(t.Rows) == 0 {
		row := make([]string, len(t.Columns))
		if len(row) > 0 {
			row[0] = t.Empty
		}
		rows = append(rows, row)
	} else {
		rows = t.Rows
	}

	var sb strings.Builder
	if strings.TrimSpace(t.Title) != "" {
		sb.WriteString("### ")
		sb.WriteString(strings.TrimSpace(t.Title))
		sb.WriteString("\n\n")
	}

	sb.WriteString(renderMarkdownRow(t.Columns, nil))
	sb.WriteByte('\n')
	sb.WriteString(renderMarkdownDivider(t.Columns))
	for _, row := range rows {
		sb.WriteByte('\n')
		sb.WriteString(renderMarkdownRow(t.Columns, row))
	}
	return sb.String()
}

func renderMarkdownRow(columns []Column, row []string) string {
	var sb strings.Builder
	sb.WriteString("|")
	for i, col := range columns {
		value := normalizeMarkdownCell(col.Label)
		if row != nil && i < len(row) {
			value = normalizeMarkdownCell(row[i])
		}
		sb.WriteByte(' ')
		sb.WriteString(escapeMarkdownCell(value))
		sb.WriteString(" |")
	}
	return sb.String()
}

func renderMarkdownDivider(columns []Column) string {
	var sb strings.Builder
	sb.WriteString("|")
	for _, col := range columns {
		sb.WriteByte(' ')
		sb.WriteString(markdownAlign(col.Align))
		sb.WriteString(" |")
	}
	return sb.String()
}

func markdownAlign(align Align) string {
	switch align {
	case AlignRight:
		return "---:"
	case AlignCenter:
		return ":---:"
	default:
		return ":---"
	}
}

func renderASCIITable(t Table) string {
	widths := make([]int, len(t.Columns))
	for i, col := range t.Columns {
		widths[i] = len(normalizeInline(col.Label))
		if col.Width > widths[i] {
			widths[i] = col.Width
		}
	}
	for _, row := range t.Rows {
		for i := 0; i < len(widths); i++ {
			cell := ""
			if i < len(row) {
				cell = normalizeInline(row[i])
			}
			if len(cell) > widths[i] {
				widths[i] = len(cell)
			}
		}
	}
	if len(t.Rows) == 0 {
		emptyWidth := len(normalizeInline(t.Empty))
		totalWidth := mergedASCIIWidth(widths)
		if emptyWidth > totalWidth {
			widths[len(widths)-1] += emptyWidth - totalWidth
		}
	}

	border := renderASCIIBorder(widths)
	var sb strings.Builder
	if strings.TrimSpace(t.Title) != "" {
		sb.WriteString(strings.TrimSpace(t.Title))
		sb.WriteByte('\n')
	}
	sb.WriteString(border)
	sb.WriteByte('\n')
	sb.WriteString(renderASCIIRow(t.Columns, nil, widths))
	sb.WriteByte('\n')
	sb.WriteString(border)

	if len(t.Rows) == 0 {
		sb.WriteByte('\n')
		sb.WriteString(renderASCIIMessageRow(t.Empty, len(border)-4))
		sb.WriteByte('\n')
		sb.WriteString(border)
		return sb.String()
	}

	for _, row := range t.Rows {
		sb.WriteByte('\n')
		sb.WriteString(renderASCIIRow(t.Columns, row, widths))
	}
	sb.WriteByte('\n')
	sb.WriteString(border)
	return sb.String()
}

func renderASCIIBorder(widths []int) string {
	var sb strings.Builder
	sb.WriteByte('+')
	for _, width := range widths {
		sb.WriteString(repeat("-", width+2))
		sb.WriteByte('+')
	}
	return sb.String()
}

func renderASCIIRow(columns []Column, row []string, widths []int) string {
	var sb strings.Builder
	sb.WriteByte('|')
	for i, col := range columns {
		value := normalizeInline(col.Label)
		if row != nil && i < len(row) {
			value = normalizeInline(row[i])
		}
		sb.WriteByte(' ')
		sb.WriteString(pad(value, widths[i], col.Align))
		sb.WriteString(" |")
	}
	return sb.String()
}

func renderASCIIMessageRow(msg string, width int) string {
	return "| " + pad(normalizeInline(msg), width, AlignLeft) + " |"
}

func mergedASCIIWidth(widths []int) int {
	if len(widths) == 0 {
		return 0
	}
	total := len(widths) - 1
	for _, width := range widths {
		total += width
	}
	return total + 2*(len(widths)-1)
}

func columnsFromLabels(labels []string) []Column {
	columns := make([]Column, 0, len(labels))
	for _, label := range labels {
		columns = append(columns, Column{Label: label})
	}
	return columns
}
