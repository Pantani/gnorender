package gnorender

import (
	"strings"

	"gno.land/p/nt/ufmt/v0"
)

func DrawOrderedList(title string, items []string) string {
	if len(items) == 0 {
		return DrawSection(title, "No items.")
	}

	var sb strings.Builder
	for i, item := range items {
		if i > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString(ufmt.Sprintf("%d. %s", i+1, normalizeInline(item)))
	}
	return DrawSection(title, sb.String())
}

func DrawStatus(label, value string) string {
	label = strings.TrimSpace(label)
	value = strings.TrimSpace(value)
	switch {
	case label == "":
		return value
	case value == "":
		return label
	default:
		return ufmt.Sprintf("**%s:** %s", label, value)
	}
}

func DrawCodeBlock(lang, code string) string {
	var sb strings.Builder
	sb.WriteString("```")
	sb.WriteString(strings.TrimSpace(lang))
	sb.WriteByte('\n')
	sb.WriteString(code)
	if !strings.HasSuffix(code, "\n") {
		sb.WriteByte('\n')
	}
	sb.WriteString("```")
	return sb.String()
}
