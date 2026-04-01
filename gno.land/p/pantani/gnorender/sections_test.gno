package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawTitleSectionAndDivider(t *testing.T) {
	uassert.Equal(t, "# IBC Transfer", DrawTitle("  IBC Transfer  "))
	uassert.Equal(t, "", DrawTitle("   "))
	uassert.Equal(t, "## Clients\n\nRegistered relayers", DrawSection("Clients", "Registered relayers"))
	uassert.Equal(t, "body only", DrawSection("", "body only"))
	uassert.Equal(t, "## Overview", DrawSection("Overview", ""))
	uassert.Equal(t, "---", DrawDivider())
}

func TestDrawListHelpers(t *testing.T) {
	list := DrawList("Ports", []string{"transfer", "bank"})
	ordered := DrawOrderedList("Steps", []string{"Create client", "Send packet"})

	uassert.Equal(t, "## Ports\n\n- transfer\n- bank", list)
	uassert.Equal(t, "## Steps\n\n1. Create client\n2. Send packet", ordered)
}

func TestDrawListEmpty(t *testing.T) {
	uassert.Equal(t, "## Ports\n\nNo items.", DrawList("Ports", nil))
	uassert.Equal(t, "## Steps\n\nNo items.", DrawOrderedList("Steps", nil))
}

func TestDrawCodeBlockAndStatus(t *testing.T) {
	code := DrawCodeBlock("json", "{\"ok\":true}")
	status := DrawStatus("Client", "active")

	uassert.Equal(t, "```json\n{\"ok\":true}\n```", code)
	uassert.Equal(t, "**Client:** active", status)
}

func TestDrawStatusFallbacks(t *testing.T) {
	uassert.Equal(t, "active", DrawStatus("", "active"))
	uassert.Equal(t, "Client", DrawStatus("Client", ""))
}

func TestDrawEmptyStateDefaultBody(t *testing.T) {
	got := DrawEmptyState("Balances", "")

	uassert.Equal(t, `+----------+
| Balances |
+----------+
| No data. |
+----------+`, got)
}
