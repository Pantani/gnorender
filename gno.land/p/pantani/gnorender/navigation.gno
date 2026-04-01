package gnorender

import (
	"strings"

	"gno.land/p/nt/ufmt/v0"
)

func DrawLink(label, target string) string {
	label = normalizeInline(label)
	target = strings.TrimSpace(target)
	if label == "" {
		label = target
	}
	if label == "" {
		return ""
	}
	return markdownLink(label, target)
}

func DrawLinkList(title string, links ...Link) string {
	if len(links) == 0 {
		return DrawSection(title, "No links.")
	}

	var sb strings.Builder
	count := 0
	for _, link := range links {
		item := DrawLink(link.Label, link.Target)
		if item == "" {
			continue
		}
		if count > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString("- ")
		sb.WriteString(item)
		count++
	}
	if count == 0 {
		return DrawSection(title, "No links.")
	}
	return DrawSection(title, sb.String())
}

func DrawTabs(selected string, tabs ...Tab) string {
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
			label = "[" + label + "]"
		}
		labels = append(labels, label)
	}
	return strings.Join(labels, " | ")
}

func DrawPager(page, total int, basePath string) string {
	if total <= 0 {
		total = 1
	}
	if page < 1 {
		page = 1
	}
	if page > total {
		page = total
	}

	parts := []string{ufmt.Sprintf("Page %d/%d", page, total)}
	if page > 1 {
		parts = append(parts, markdownLink("Prev", pageLink(basePath, page-1)))
	}
	if page < total {
		parts = append(parts, markdownLink("Next", pageLink(basePath, page+1)))
	}
	return strings.Join(parts, " | ")
}
