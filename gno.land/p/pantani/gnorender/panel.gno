package gnorender

import "strings"

func DrawPanel(title, body string) string {
	title = normalizeInline(title)
	lines := splitLines(body)
	if len(lines) == 0 {
		lines = append(lines, "")
	}

	width := len(title)
	for _, line := range lines {
		line = normalizeInline(line)
		if len(line) > width {
			width = len(line)
		}
	}

	border := "+" + repeat("-", width+2) + "+"
	var sb strings.Builder
	sb.WriteString(border)
	sb.WriteByte('\n')

	hasBody := !(len(lines) == 1 && normalizeInline(lines[0]) == "")
	if title != "" {
		sb.WriteString("| ")
		sb.WriteString(pad(title, width, AlignCenter))
		sb.WriteString(" |")
		sb.WriteByte('\n')
		if hasBody {
			sb.WriteString(border)
			sb.WriteByte('\n')
		}
	}

	if hasBody {
		for i, line := range lines {
			if i > 0 {
				sb.WriteByte('\n')
			}
			sb.WriteString("| ")
			sb.WriteString(pad(normalizeInline(line), width, AlignLeft))
			sb.WriteString(" |")
		}
		sb.WriteByte('\n')
	}

	sb.WriteString(border)
	return sb.String()
}
