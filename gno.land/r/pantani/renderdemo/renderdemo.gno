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
			gnorender.DrawProgressBar("Showcase Coverage", 52, 52, 20),
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

	workflowWidgets := gnorender.DrawSection(
		"Workflow Widgets",
		joinBlocks(
			gnorender.DrawChecklist(
				"DrawChecklist",
				gnorender.ChecklistItem{Label: "Create client", Done: true},
				gnorender.ChecklistItem{Label: "Relay packets"},
				gnorender.ChecklistItem{Label: "Upgrade contract", Blocked: true, Note: "Waiting on audit"},
			),
			gnorender.DrawLegend(
				"DrawLegend",
				gnorender.LegendItem{Kind: gnorender.NoticeSuccess, Label: "Healthy", Description: "Everything looks good"},
				gnorender.LegendItem{Kind: gnorender.NoticeWarning, Label: "Pending", Description: "Needs attention"},
				gnorender.LegendItem{Kind: gnorender.NoticeError, Label: "Failed", Description: "Requires action"},
			),
			gnorender.DrawComparisonTable(
				"DrawComparisonTable",
				gnorender.ComparisonRow{Field: "Status", Before: "pending", After: "active"},
				gnorender.ComparisonRow{Field: "Height", Before: "120", After: "121"},
				gnorender.ComparisonRow{Field: "Fee", Before: "10", After: "10"},
			),
			gnorender.DrawEmptyStateWithAction(
				"DrawEmptyStateWithAction",
				"No balances yet.",
				gnorender.Link{Label: "Create account", Target: "/r/pantani/renderdemo?tab=create"},
			),
			gnorender.DrawSection(
				"DrawTabsNav",
				gnorender.DrawTabsNav(
					"overview",
					gnorender.Tab{ID: "overview", Label: "Overview", Target: "/r/pantani/renderdemo"},
					gnorender.Tab{ID: "methods", Label: "Methods", Target: "/r/pantani/renderdemo?tab=methods"},
					gnorender.Tab{ID: "state", Label: "State", Target: "/r/pantani/renderdemo?tab=state"},
				),
			),
		),
	)

	governanceAndTx := gnorender.DrawSection(
		"Governance And Transactions",
		joinBlocks(
			gnorender.DrawVoteBreakdown(
				"DrawVoteBreakdown",
				gnorender.VoteBreakdown{Yes: 6, No: 2, Abstain: 1, Veto: 1},
			),
			gnorender.DrawGovernanceTally(
				"DrawGovernanceTally",
				gnorender.VoteBreakdown{Yes: 7, No: 2, Abstain: 1, Veto: 0},
			),
			gnorender.DrawEventLog(
				"DrawEventLog",
				gnorender.EventEntry{
					Time:    "2026-04-01 12:00",
					Type:    "transfer",
					Summary: "packet sent",
					Attributes: []gnorender.KV{
						{Key: "sender", Value: "alice"},
						{Key: "receiver", Value: "bob"},
					},
				},
				gnorender.EventEntry{
					Time:    "2026-04-01 12:01",
					Type:    "ack",
					Summary: "packet acknowledged",
				},
			),
			gnorender.DrawTxReceipt(gnorender.TxReceipt{
				Hash:      "ABCDEF1234567890FEDCBA",
				Status:    gnorender.TxStatusSuccess,
				Sender:    "g1abcdefghijklmno123456789pqrstuv",
				Height:    "123",
				GasWanted: "1000",
				GasUsed:   "800",
				Messages:  []string{"MsgSend", "MsgAck"},
				Events: []gnorender.EventEntry{
					{
						Time:    "2026-04-01 12:00",
						Type:    "transfer",
						Summary: "packet sent",
						Attributes: []gnorender.KV{
							{Key: "amount", Value: "10ugnot"},
						},
					},
				},
			}),
			gnorender.DrawProposalSummary(gnorender.ProposalSummary{
				ID:       "7",
				Title:    "Upgrade gnorender",
				Status:   "Voting",
				Proposer: "g1abcdefghijklmno123456789pqrstuv",
				Summary:  "Adds richer UI widgets.",
				Tally:    gnorender.VoteBreakdown{Yes: 7, No: 2, Abstain: 1, Veto: 0},
			}),
		),
	)

	gnoSpecific := gnorender.DrawSection(
		"Gno-Specific Helpers",
		joinBlocks(
			gnorender.DrawRealmHeader(
				"Render Demo",
				"/r/pantani/renderdemo",
				"g1abcdefghijklmno123456789pqrstuv",
				"A showcase realm for gnorender.",
			),
			gnorender.DrawPackageHeader(
				"gnorender",
				"/p/pantani/gnorender",
				"v0.1.0",
			),
			gnorender.DrawMethodList(
				"DrawMethodList",
				gnorender.Method{Name: "Render", Signature: "Render(path string) string", Description: "Renders the realm view"},
				gnorender.Method{Name: "List", Signature: "List() []string", Description: "Lists demo entries"},
			),
			gnorender.DrawBalanceList(
				"DrawBalanceList",
				gnorender.CoinBalance{Denom: "ugnot", Amount: "1500", Value: "$15.00"},
				gnorender.CoinBalance{Denom: "uatom", Amount: "250", Value: "$2.50"},
			),
			gnorender.DrawCoins(
				"DrawCoins",
				gnorender.CoinBalance{Denom: "ugnot", Amount: "1500", Value: "$15.00"},
			),
			gnorender.DrawValidatorList(
				"DrawValidatorList",
				gnorender.Validator{
					Moniker:     "alpha",
					Address:     "g1abcdefghijklmno123456789pqrstuv",
					VotingPower: "100",
					Status:      "bonded",
				},
				gnorender.Validator{
					Moniker:     "beta",
					Address:     "g1zyxwvutsrqponm987654321lkjihgf",
					VotingPower: "80",
					Status:      "jailed",
				},
			),
			gnorender.DrawAddressBook(
				"DrawAddressBook",
				gnorender.AddressEntry{Name: "Treasury", Address: "g1abcdefghijklmno123456789pqrstuv", Note: "Main vault"},
				gnorender.AddressEntry{Name: "Operator", Address: "g1zyxwvutsrqponm987654321lkjihgf", Note: "Ops wallet"},
			),
			gnorender.DrawContractMetadata(gnorender.ContractMetadata{
				Name:        "Render Demo",
				Path:        "/r/pantani/renderdemo",
				Owner:       "g1abcdefghijklmno123456789pqrstuv",
				Version:     "v1",
				Description: "A realm used to preview helper output.",
			}),
			gnorender.DrawRealmIndex(
				"DrawRealmIndex",
				gnorender.RealmPage{Label: "Overview", Target: "/r/pantani/renderdemo", Description: "Landing page"},
				gnorender.RealmPage{Label: "Methods", Target: "/r/pantani/renderdemo?tab=methods", Description: "API surface"},
				gnorender.RealmPage{Label: "State", Target: "/r/pantani/renderdemo?tab=state", Description: "Current values"},
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
		workflowWidgets,
		gnorender.DrawDivider(),
		governanceAndTx,
		gnorender.DrawDivider(),
		gnoSpecific,
		gnorender.DrawDivider(),
		asciiHelpers,
		gnorender.DrawDivider(),
		codeSamples,
	)
}

func joinBlocks(parts ...string) string {
	return strings.Join(parts, "\n\n")
}
