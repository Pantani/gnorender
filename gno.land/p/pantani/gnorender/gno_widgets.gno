package gnorender

import "strings"

func DrawRealmHeader(name, path, owner, description string) string {
	parts := []string{DrawTitle(name)}
	if strings.TrimSpace(path) != "" {
		parts = append(parts, DrawStatus("Path", DrawLink(path, path)))
	}
	if strings.TrimSpace(owner) != "" {
		parts = append(parts, DrawAddress("Owner", owner, AddressFormatShort))
	}
	if strings.TrimSpace(description) != "" {
		parts = append(parts, strings.TrimSpace(description))
	}
	return joinNonEmpty(parts...)
}

func DrawPackageHeader(name, importPath, version string) string {
	parts := []string{DrawTitle(name)}
	if strings.TrimSpace(importPath) != "" {
		parts = append(parts, DrawStatus("Import", DrawLink(importPath, importPath)))
	}
	if strings.TrimSpace(version) != "" {
		parts = append(parts, DrawStatus("Version", version))
	}
	return joinNonEmpty(parts...)
}

func DrawMethodList(title string, methods ...Method) string {
	if len(methods) == 0 {
		return DrawSection(title, "No methods.")
	}

	rows := make([][]string, 0, len(methods))
	for _, method := range methods {
		name := normalizeInline(method.Name)
		if name == "" {
			name = "Method"
		}
		signature := strings.TrimSpace(method.Signature)
		if signature == "" {
			signature = name + "()"
		}
		rows = append(rows, []string{
			name,
			signature,
			normalizeInline(method.Description),
		})
	}

	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Method"},
			{Label: "Signature"},
			{Label: "Description"},
		},
		Rows:   rows,
		Format: FormatMarkdown,
	}.Render()
}

func DrawBalanceList(title string, balances ...CoinBalance) string {
	if len(balances) == 0 {
		return DrawSection(title, "No balances.")
	}

	rows := make([][]string, 0, len(balances))
	for _, balance := range balances {
		denom := normalizeInline(balance.Denom)
		if denom == "" {
			denom = "coin"
		}
		rows = append(rows, []string{
			denom,
			strings.TrimSpace(balance.Amount),
			strings.TrimSpace(balance.Value),
		})
	}

	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Denom"},
			{Label: "Amount", Align: AlignRight},
			{Label: "Value"},
		},
		Rows:   rows,
		Format: FormatMarkdown,
	}.Render()
}

func DrawProposalSummary(proposal ProposalSummary) string {
	title := "Proposal"
	if strings.TrimSpace(proposal.ID) != "" {
		title = "Proposal #" + strings.TrimSpace(proposal.ID)
	}
	if strings.TrimSpace(proposal.Title) != "" {
		title += ": " + strings.TrimSpace(proposal.Title)
	}

	details := make([]KV, 0, 2)
	details = appendKVIfValue(details, "Status", proposalStatusBadge(proposal.Status))
	details = appendKVIfValue(details, "Proposer", DrawAddress("", proposal.Proposer, AddressFormatShort))

	parts := []string{}
	if len(details) > 0 {
		parts = append(parts, DrawDescriptionList("Details", details...))
	}
	if strings.TrimSpace(proposal.Summary) != "" {
		parts = append(parts, proposal.Summary)
	}
	if voteTotal(proposal.Tally) > 0 {
		parts = append(parts, DrawGovernanceTally("Tally", proposal.Tally))
	}
	return DrawSection(title, joinNonEmpty(parts...))
}

func DrawGovernanceTally(title string, tally VoteBreakdown) string {
	return DrawVoteBreakdown(title, tally)
}

func DrawValidatorList(title string, validators ...Validator) string {
	if len(validators) == 0 {
		return DrawSection(title, "No validators.")
	}

	rows := make([][]string, 0, len(validators))
	for _, validator := range validators {
		name := normalizeInline(validator.Moniker)
		if name == "" {
			name = "validator"
		}
		rows = append(rows, []string{
			name,
			shortenMiddle(strings.TrimSpace(validator.Address), 8, 6),
			strings.TrimSpace(validator.VotingPower),
			strings.TrimSpace(validator.Status),
		})
	}

	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Validator"},
			{Label: "Address"},
			{Label: "Voting Power", Align: AlignRight},
			{Label: "Status"},
		},
		Rows:   rows,
		Format: FormatMarkdown,
	}.Render()
}

func DrawAddressBook(title string, entries ...AddressEntry) string {
	if len(entries) == 0 {
		return DrawSection(title, "No addresses.")
	}

	rows := make([][]string, 0, len(entries))
	for _, entry := range entries {
		name := normalizeInline(entry.Name)
		if name == "" {
			name = "entry"
		}
		rows = append(rows, []string{
			name,
			shortenMiddle(strings.TrimSpace(entry.Address), 8, 6),
			normalizeInline(entry.Note),
		})
	}

	return Table{
		Title: title,
		Columns: []Column{
			{Label: "Name"},
			{Label: "Address"},
			{Label: "Note"},
		},
		Rows:   rows,
		Format: FormatMarkdown,
	}.Render()
}

func DrawContractMetadata(meta ContractMetadata) string {
	parts := []string{}
	if strings.TrimSpace(meta.Description) != "" {
		parts = append(parts, meta.Description)
	}
	metadata := make([]KV, 0, 4)
	metadata = appendKVIfValue(metadata, "Name", meta.Name)
	metadata = appendKVIfValue(metadata, "Path", DrawLink(meta.Path, meta.Path))
	metadata = appendKVIfValue(metadata, "Owner", DrawAddress("", meta.Owner, AddressFormatShort))
	metadata = appendKVIfValue(metadata, "Version", meta.Version)
	if len(metadata) > 0 {
		parts = append(parts, DrawDescriptionList("Metadata", metadata...))
	}
	return DrawSection("Contract Metadata", joinNonEmpty(parts...))
}

func DrawRealmIndex(title string, pages ...RealmPage) string {
	if len(pages) == 0 {
		return DrawSection(title, "No pages.")
	}

	var sb strings.Builder
	count := 0
	for _, page := range pages {
		label := normalizeInline(page.Label)
		if label == "" {
			continue
		}
		if count > 0 {
			sb.WriteByte('\n')
		}
		sb.WriteString("- ")
		sb.WriteString(DrawLink(label, page.Target))
		desc := normalizeInline(page.Description)
		if desc != "" {
			sb.WriteString(": ")
			sb.WriteString(desc)
		}
		count++
	}
	if count == 0 {
		return DrawSection(title, "No pages.")
	}
	return DrawSection(title, sb.String())
}

func DrawCoins(title string, balances ...CoinBalance) string {
	return DrawBalanceList(title, balances...)
}

func proposalStatusBadge(status string) string {
	status = normalizeInline(status)
	switch strings.ToLower(status) {
	case "passed", "approved", "active":
		return DrawBadge(NoticeSuccess, status)
	case "rejected", "failed":
		return DrawBadge(NoticeError, status)
	case "voting", "pending":
		return DrawBadge(NoticeWarning, status)
	default:
		if status == "" {
			status = "Unknown"
		}
		return DrawBadge(NoticeInfo, status)
	}
}
