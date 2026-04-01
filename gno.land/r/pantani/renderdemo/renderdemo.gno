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
			gnorender.DrawTabs(
				"showcase",
				gnorender.Tab{ID: "overview", Label: "Overview"},
				gnorender.Tab{ID: "showcase", Label: "Showcase"},
				gnorender.Tab{ID: "types", Label: "Types"},
			),
			gnorender.DrawPager(2, 4, "/r/pantani/renderdemo?view=showcase"),
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
		),
	)

	markdownHelpers := gnorender.DrawSection(
		"Markdown Helpers",
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
			gnorender.DrawCodeBlock("go", `gnorender.DrawPanel("Box", "ASCII output")`),
		),
	)

	return joinBlocks(
		gnorender.DrawTitle("Render Demo"),
		overview,
		gnorender.DrawDivider(),
		sectionsAndLists,
		gnorender.DrawDivider(),
		markdownHelpers,
		gnorender.DrawDivider(),
		asciiHelpers,
		gnorender.DrawDivider(),
		codeSamples,
	)
}

func joinBlocks(parts ...string) string {
	return strings.Join(parts, "\n\n")
}
