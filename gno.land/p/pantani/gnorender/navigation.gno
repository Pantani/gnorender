package gnorender

import (
	"strings"

	"gno.land/p/nt/ufmt/v0"
)

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
