package gnorender

import (
	"strings"

	"gno.land/p/nt/ufmt/v0"
)

func escapeMarkdownCell(s string) string {
	s = strings.Join(strings.Split(s, "\r"), "")
	s = strings.Join(strings.Split(s, "\n"), "<br>")
	s = strings.Join(strings.Split(s, "|"), "\\|")
	return s
}

func splitLines(s string) []string {
	s = strings.Join(strings.Split(s, "\r"), "")
	if s == "" {
		return nil
	}
	return strings.Split(s, "\n")
}

func normalizeInline(s string) string {
	s = strings.Join(strings.Split(s, "\r"), "")
	s = strings.Join(strings.Split(s, "\n"), " ")
	return strings.TrimSpace(s)
}

func normalizeMarkdownCell(s string) string {
	s = strings.Join(strings.Split(s, "\r"), "")
	return strings.TrimSpace(s)
}

func shortenMiddle(s string, prefix, suffix int) string {
	if prefix < 0 {
		prefix = 0
	}
	if suffix < 0 {
		suffix = 0
	}
	if len(s) <= prefix+suffix+3 {
		return s
	}
	return s[:prefix] + "..." + s[len(s)-suffix:]
}

func escapeJSONString(s string) string {
	s = strings.Join(strings.Split(s, `\`), `\\`)
	s = strings.Join(strings.Split(s, `"`), `\"`)
	s = strings.Join(strings.Split(s, "\r"), "")
	s = strings.Join(strings.Split(s, "\n"), `\n`)
	return s
}

func pad(s string, width int, align Align) string {
	if len(s) >= width {
		return s
	}
	diff := width - len(s)
	switch align {
	case AlignRight:
		return repeat(" ", diff) + s
	case AlignCenter:
		left := diff / 2
		right := diff - left
		return repeat(" ", left) + s + repeat(" ", right)
	default:
		return s + repeat(" ", diff)
	}
}

func repeat(s string, count int) string {
	if count <= 0 || s == "" {
		return ""
	}
	var sb strings.Builder
	for i := 0; i < count; i++ {
		sb.WriteString(s)
	}
	return sb.String()
}

func markdownLink(label, target string) string {
	if strings.TrimSpace(target) == "" {
		return label
	}
	return ufmt.Sprintf("[%s](%s)", label, target)
}

func pageLink(basePath string, page int) string {
	sep := "?"
	if strings.Contains(basePath, "?") {
		sep = "&"
	}
	return ufmt.Sprintf("%s%spage=%d", basePath, sep, page)
}
