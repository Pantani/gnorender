package renderdemo

import (
	"strings"

	"gno.land/p/pantani/gnorender"
)

func Render(path string) string {
	overview := gnorender.DrawSection(
		"Overview",
		joinBlocks(
			gnorender.DrawStatus("Library", "working"),
			gnorender.DrawStatus("Path", path),
			gnorender.DrawBreadcrumbs(
				gnorender.Link{Label: "Home", Target: "/"},
				gnorender.Link{Label: "Realms", Target: "/r/"},
				gnorender.Link{Label: "Render Demo"},
			),
			gnorender.DrawProgressBar("Showcase Coverage", 34, 34, 20),
			gnorender.DrawFilterBar(
				"Filters",
				gnorender.Filter{Label: "View", Value: "Showcase", Active: true},
				gnorender.Filter{Label: "Format", Value: "Markdown", Target: "/r/pantani/renderdemo?format=markdown"},
				gnorender.Filter{Label: "Status", Value: "All"},
			),
			gnorender.DrawTabs(
				"showcase",
				gnorender.Tab{ID: "overview", Label: "Overview"},
				gnorender.Tab{ID: "showcase", Label: "Showcase"},
				gnorender.Tab{ID: "types", Label: "Types"},
			),
			gnorender.DrawPager(2, 4, "/r/pantani/renderdemo?view=showcase"),
		),
	)

	navigationAndActions := gnorender.DrawSection(
		"Navigation And Actions",
		joinBlocks(
			gnorender.DrawSection("DrawLink", gnorender.DrawLink("Open the package docs", "/p/pantani/gnorender")),
			gnorender.DrawLinkList(
				"DrawLinkList",
				gnorender.Link{Label: "Package README", Target: "/p/pantani/gnorender"},
				gnorender.Link{Label: "Refresh Demo", Target: "/r/pantani/renderdemo"},
			),
			gnorender.DrawCard(
				"DrawCard",
				"Use cards when you want a Markdown-friendly emphasis block that still looks good in gnoweb.",
			),
		),
	)

	metricsAndStatus := gnorender.DrawSection(
		"Metrics And Status",
		joinBlocks(
			gnorender.DrawMetric(gnorender.Metric{
				Label: "Active Users",
				Value: "42",
				Delta: "+2",
				Kind:  gnorender.NoticeSuccess,
			}),
			gnorender.DrawStatGrid(
				"DrawStatGrid",
				gnorender.Metric{Label: "Transfers", Value: "128", Delta: "+18", Kind: gnorender.NoticeSuccess},
				gnorender.Metric{Label: "Pending", Value: "7", Delta: "-3", Kind: gnorender.NoticeWarning},
				gnorender.Metric{Label: "Failures", Value: "1", Delta: "-1", Kind: gnorender.NoticeError},
			),
			gnorender.DrawAddress("DrawAddress", "g1abcdefghijklmno123456789pqrstuv", gnorender.AddressFormatShort),
			gnorender.DrawTxStatus("ABCDEF1234567890FEDCBA", gnorender.TxStatusSuccess),
			gnorender.DrawSection(
				"DrawBadge",
				joinBlocks(
					gnorender.DrawBadge(gnorender.NoticeInfo, "Info"),
					gnorender.DrawBadge(gnorender.NoticeSuccess, "Success"),
					gnorender.DrawBadge(gnorender.NoticeWarning, "Warning"),
					gnorender.DrawBadge(gnorender.NoticeError, "Error"),
				),
			),
		),
	)

	sectionsAndLists := gnorender.DrawSection(
		"Sections And Lists",
		joinBlocks(
			gnorender.DrawSection("Nested Section", "This nested section is rendered inside the demo body."),
			gnorender.DrawList("DrawList", []string{
				"Titles and sections",
				"Lists and ordered lists",
				"Markdown and ASCII blocks",
			}),
			gnorender.DrawOrderedList("DrawOrderedList", []string{
				"Open the realm",
				"Inspect each helper output",
				"Reuse the snippets in your own realms",
			}),
			gnorender.DrawDescriptionList(
				"DrawDescriptionList",
				gnorender.KV{Key: "Primary format", Value: string(gnorender.FormatMarkdown)},
				gnorender.KV{Key: "ASCII format", Value: string(gnorender.FormatASCII)},
			),
		),
	)

	dataViews := gnorender.DrawSection(
		"Data Views",
		joinBlocks(
			gnorender.DrawTable(
				[]string{"Helper", "Result"},
				[]string{"DrawTable", "ok"},
				[]string{"DrawDivider", "ok"},
			),
			gnorender.DrawTableWithTitle(
				"DrawTableWithTitle",
				[]string{"Column", "Value"},
				[]string{"FormatMarkdown", string(gnorender.FormatMarkdown)},
				[]string{"FormatASCII", string(gnorender.FormatASCII)},
			),
			gnorender.DrawKVTable(
				"DrawKVTable",
				gnorender.KV{Key: "Package", Value: "gno.land/p/pantani/gnorender"},
				gnorender.KV{Key: "Realm", Value: "gno.land/r/pantani/renderdemo"},
			),
			gnorender.DrawObject(
				"DrawObject",
				gnorender.KV{Key: "chain_id", Value: "dev"},
				gnorender.KV{Key: "owner", Value: "pantani"},
				gnorender.KV{Key: "realm", Value: "renderdemo"},
			),
			gnorender.Table{
				Title: "Table.Render (Markdown)",
				Columns: []gnorender.Column{
					{Label: "Left", Align: gnorender.AlignLeft},
					{Label: "Center", Align: gnorender.AlignCenter},
					{Label: "Right", Align: gnorender.AlignRight},
				},
				Rows: [][]string{
					{"alpha", "beta", "gamma"},
				},
				Format: gnorender.FormatMarkdown,
			}.Render(),
			gnorender.Table{
				Title: "Table Without Columns",
				Empty: "Nothing to show.",
			}.Render(),
		),
	)

	historyAndState := gnorender.DrawSection(
		"History And State",
		joinBlocks(
			gnorender.DrawTimeline(
				"DrawTimeline",
				gnorender.TimelineItem{
					Time:  "2026-04-01 12:00",
					Title: "Proposal submitted",
					Body:  "Initial draft created and shared for feedback.",
					Kind:  gnorender.NoticeInfo,
				},
				gnorender.TimelineItem{
					Time:  "2026-04-01 14:30",
					Title: "Upgrade queued",
					Body:  "Pending packets must be drained before execution.",
					Kind:  gnorender.NoticeWarning,
				},
				gnorender.TimelineItem{
					Time:  "2026-04-01 15:00",
					Title: "Dry run passed",
					Kind:  gnorender.NoticeSuccess,
				},
			),
			gnorender.DrawDiff(
				"DrawDiff",
				"status = pending\nheight = 120",
				"status = active\nheight = 121",
			),
		),
	)

	formsAndCallouts := gnorender.DrawSection(
		"Forms And Callouts",
		joinBlocks(
			gnorender.DrawBlockquote("Blockquotes are handy for lightweight notes and commentary."),
			gnorender.DrawCallout(
				gnorender.NoticeInfo,
				"Markdown-native callout",
				"Use this when you want emphasis without relying on ASCII layout.",
			),
			gnorender.DrawCallout(
				gnorender.NoticeWarning,
				"ASCII helpers",
				"Wrap panels and other ASCII blocks in DrawCodeBlock when rendering through gnoweb.",
			),
			gnorender.DrawCallout(
				gnorender.NoticeSuccess,
				"Progress",
				gnorender.DrawProgressBar("Manual review", 9, 10, 10),
			),
			gnorender.DrawField(gnorender.Field{
				Label:    "Realm Name",
				Value:    "renderdemo",
				Hint:     "Use a stable path",
				Required: true,
			}),
			gnorender.DrawFormPreview(
				"DrawFormPreview",
				gnorender.Field{Label: "Realm Name", Value: "renderdemo", Hint: "Use a stable path", Required: true},
				gnorender.Field{Label: "Owner", Value: "pantani"},
				gnorender.Field{Label: "Description", Value: "", Hint: "Optional"},
			),
		),
	)

	asciiHelpers := gnorender.DrawSection(
		"ASCII Helpers",
		joinBlocks(
			gnorender.DrawCodeBlock(
				"text",
				gnorender.DrawPanel(
					"DrawPanel",
					"Panels need code fences\ninside Markdown renderers.",
				),
			),
			gnorender.DrawCodeBlock(
				"text",
				gnorender.DrawEmptyState(
					"DrawEmptyState",
					"No vouchers minted yet.",
				),
			),
			gnorender.DrawCodeBlock(
				"text",
				gnorender.Table{
					Title: "Table.Render (ASCII)",
					Columns: []gnorender.Column{
						{Label: "Metric", Width: 10},
						{Label: "Value", Align: gnorender.AlignCenter, Width: 7},
						{Label: "Delta", Align: gnorender.AlignRight, Width: 6},
					},
					Rows: [][]string{
						{"Supply", "120", "+4"},
						{"Users", "42", "+2"},
					},
					Format: gnorender.FormatASCII,
				}.Render(),
			),
		),
	)

	codeSamples := gnorender.DrawSection(
		"Code Samples",
		joinBlocks(
			gnorender.DrawCodeBlock("go", `import "gno.land/p/pantani/gnorender"`),
			gnorender.DrawCodeBlock("go", `gnorender.DrawTimeline("Deployments", gnorender.TimelineItem{Title: "Queued"})`),
			gnorender.DrawCodeBlock("go", `gnorender.DrawFilterBar("Filters", gnorender.Filter{Label: "Status", Value: "Open", Active: true})`),
		),
	)

	return joinBlocks(
		gnorender.DrawTitle("Render Demo"),
		overview,
		gnorender.DrawDivider(),
		navigationAndActions,
		gnorender.DrawDivider(),
		metricsAndStatus,
		gnorender.DrawDivider(),
		sectionsAndLists,
		gnorender.DrawDivider(),
		dataViews,
		gnorender.DrawDivider(),
		historyAndState,
		gnorender.DrawDivider(),
		formsAndCallouts,
		gnorender.DrawDivider(),
		asciiHelpers,
		gnorender.DrawDivider(),
		codeSamples,
	)
}

func joinBlocks(parts ...string) string {
	return strings.Join(parts, "\n\n")
}
