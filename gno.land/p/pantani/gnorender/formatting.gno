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

func DrawBadge(kind NoticeKind, label string) string {
	label = normalizeInline(label)
	icon := noticeIcon(kind)
	if label == "" {
		return icon
	}
	return icon + " " + label
}

func DrawBlockquote(body string) string {
	lines := splitLines(strings.TrimSpace(body))
	if len(lines) == 0 {
		return ""
	}

	var sb strings.Builder
	for i, line := range lines {
		if i > 0 {
			sb.WriteByte('\n')
		}
		line = strings.TrimSpace(line)
		if line == "" {
			sb.WriteByte('>')
			continue
		}
		sb.WriteString("> ")
		sb.WriteString(line)
	}
	return sb.String()
}

func DrawCallout(kind NoticeKind, title, body string) string {
	label := calloutLabel(kind)
	title = normalizeInline(title)
	body = strings.TrimSpace(body)

	headline := label
	if title != "" {
		headline += ": " + title
	}
	if body == "" {
		return DrawBlockquote("**" + DrawBadge(kind, headline) + "**")
	}
	return DrawBlockquote("**" + DrawBadge(kind, headline) + "**\n\n" + body)
}

func DrawProgressBar(label string, current, total, width int) string {
	label = strings.TrimSpace(label)
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

	bar := "[" + repeat("#", filled) + repeat("-", width-filled) + "]"
	progress := ufmt.Sprintf("%s %d%% (%d/%d)", bar, percent, current, total)
	if label == "" {
		return "`" + progress + "`"
	}
	return ufmt.Sprintf("**%s:** `%s`", label, progress)
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

func calloutLabel(kind NoticeKind) string {
	switch kind {
	case NoticeInfo:
		return "Info"
	case NoticeSuccess:
		return "Success"
	case NoticeWarning:
		return "Warning"
	case NoticeError:
		return "Error"
	default:
		return "Note"
	}
}

func noticeIcon(kind NoticeKind) string {
	switch kind {
	case NoticeInfo:
		return "🔵"
	case NoticeSuccess:
		return "🟢"
	case NoticeWarning:
		return "🟡"
	case NoticeError:
		return "🔴"
	default:
		return "⚪"
	}
}
