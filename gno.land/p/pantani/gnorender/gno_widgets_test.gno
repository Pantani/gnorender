package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawRealmAndPackageHeader(t *testing.T) {
	realm := DrawRealmHeader("Render Demo", "/r/pantani/renderdemo", "g1abcdefghijklmno123456789pqrstuv", "A showcase realm.")
	pkg := DrawPackageHeader("gnorender", "/p/pantani/gnorender", "v0.1.0")

	uassert.Equal(t, "# Render Demo\n\n**Path:** [/r/pantani/renderdemo](/r/pantani/renderdemo)\n\n**Owner:** `g1abcdef...qrstuv`\n\nA showcase realm.", realm)
	uassert.Equal(t, "# gnorender\n\n**Import:** [/p/pantani/gnorender](/p/pantani/gnorender)\n\n**Version:** v0.1.0", pkg)
}

func TestDrawMethodList(t *testing.T) {
	got := DrawMethodList(
		"Methods",
		Method{Name: "Render", Signature: "Render(path string) string", Description: "Renders the realm view"},
		Method{Name: "List", Signature: "List() []string", Description: "Returns items"},
	)

	uassert.Equal(t, `### Methods

| Method | Signature | Description |
| :--- | :--- | :--- |
| Render | Render(path string) string | Renders the realm view |
| List | List() []string | Returns items |`, got)
}

func TestDrawBalanceListAndCoins(t *testing.T) {
	balances := DrawBalanceList(
		"Balances",
		CoinBalance{Denom: "ugnot", Amount: "1500", Value: "$15.00"},
		CoinBalance{Denom: "uatom", Amount: "250", Value: "$2.50"},
	)
	coins := DrawCoins(
		"Coins",
		CoinBalance{Denom: "ugnot", Amount: "1500", Value: "$15.00"},
	)

	uassert.Equal(t, `### Balances

| Denom | Amount | Value |
| :--- | ---: | :--- |
| ugnot | 1500 | $15.00 |
| uatom | 250 | $2.50 |`, balances)
	uassert.Equal(t, `### Coins

| Denom | Amount | Value |
| :--- | ---: | :--- |
| ugnot | 1500 | $15.00 |`, coins)
}

func TestDrawProposalSummaryAndGovernanceTally(t *testing.T) {
	proposal := DrawProposalSummary(ProposalSummary{
		ID:       "7",
		Title:    "Upgrade gnorender",
		Status:   "Voting",
		Proposer: "g1abcdefghijklmno123456789pqrstuv",
		Summary:  "Adds richer UI widgets.",
		Tally:    VoteBreakdown{Yes: 7, No: 2, Abstain: 1, Veto: 0},
	})
	tally := DrawGovernanceTally("Governance Tally", VoteBreakdown{Yes: 3, No: 1, Abstain: 0, Veto: 0})

	uassert.Equal(t, `## Proposal #7: Upgrade gnorender

## Details

- **Status:** 🟡 Voting
- **Proposer:** `+"`g1abcdef...qrstuv`"+`

Adds richer UI widgets.

### Tally

| Option | Votes | Share | Bar |
| :--- | ---: | :--- | :--- |
| 🟢 Yes | 7 | 70% | [#######---] 70% |
| 🔴 No | 2 | 20% | [##--------] 20% |
| 🔵 Abstain | 1 | 10% | [#---------] 10% |
| 🟡 Veto | 0 | 0% | [----------] 0% |`, proposal)

	uassert.Equal(t, `### Governance Tally

| Option | Votes | Share | Bar |
| :--- | ---: | :--- | :--- |
| 🟢 Yes | 3 | 75% | [#######---] 75% |
| 🔴 No | 1 | 25% | [##--------] 25% |
| 🔵 Abstain | 0 | 0% | [----------] 0% |
| 🟡 Veto | 0 | 0% | [----------] 0% |`, tally)
}

func TestDrawValidatorListAndAddressBook(t *testing.T) {
	validators := DrawValidatorList(
		"Validators",
		Validator{Moniker: "alpha", Address: "g1abcdefghijklmno123456789pqrstuv", VotingPower: "100", Status: "bonded"},
	)
	addressBook := DrawAddressBook(
		"Address Book",
		AddressEntry{Name: "Treasury", Address: "g1abcdefghijklmno123456789pqrstuv", Note: "Main vault"},
	)

	uassert.Equal(t, `### Validators

| Validator | Address | Voting Power | Status |
| :--- | :--- | ---: | :--- |
| alpha | g1abcdef...qrstuv | 100 | bonded |`, validators)
	uassert.Equal(t, `### Address Book

| Name | Address | Note |
| :--- | :--- | :--- |
| Treasury | g1abcdef...qrstuv | Main vault |`, addressBook)
}

func TestDrawContractMetadataAndRealmIndex(t *testing.T) {
	meta := DrawContractMetadata(ContractMetadata{
		Name:        "Render Demo",
		Path:        "/r/pantani/renderdemo",
		Owner:       "g1abcdefghijklmno123456789pqrstuv",
		Version:     "v1",
		Description: "A realm used to preview helper output.",
	})
	index := DrawRealmIndex(
		"Realm Index",
		RealmPage{Label: "Overview", Target: "/r/pantani/renderdemo"},
		RealmPage{Label: "Methods", Target: "/r/pantani/renderdemo?tab=methods", Description: "API surface"},
	)

	uassert.Equal(t, `## Contract Metadata

A realm used to preview helper output.

## Metadata

- **Name:** Render Demo
- **Path:** [/r/pantani/renderdemo](/r/pantani/renderdemo)
- **Owner:** `+"`g1abcdef...qrstuv`"+`
- **Version:** v1`, meta)
	uassert.Equal(t, `## Realm Index

- [Overview](/r/pantani/renderdemo)
- [Methods](/r/pantani/renderdemo?tab=methods): API surface`, index)
}
