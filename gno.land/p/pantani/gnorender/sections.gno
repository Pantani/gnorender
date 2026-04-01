package gnorender

import "strings"

func DrawTitle(title string) string {
	title = strings.TrimSpace(title)
	if title == "" {
		return ""
	}
	return "# " + title
}

func DrawSection(title, body string) string {
	title = strings.TrimSpace(title)
	body = strings.TrimSpace(body)
	if title == "" {
		return body
	}
	if body == "" {
		return "## " + title
	}
	return "## " + title + "\n\n" + body
}

func DrawDivider() string {
	return "---"
}

func DrawList(title string, items []string) string {
	if len(items) == 0 {
		return DrawSection(title, "No items.")
	}

	var sb strings.Builder
	for i, item := range items {
		if i > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString("- ")
		sb.WriteString(normalizeInline(item))
	}
	return DrawSection(title, sb.String())
}

func DrawEmptyState(title, body string) string {
	if strings.TrimSpace(body) == "" {
		body = "No data."
	}
	return DrawPanel(title, body)
}
