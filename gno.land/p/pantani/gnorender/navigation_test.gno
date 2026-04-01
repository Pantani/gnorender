package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawTabsAndPager(t *testing.T) {
	tabs := DrawTabs("clients", Tab{ID: "overview", Label: "Overview"}, Tab{ID: "clients", Label: "Clients"})
	pager := DrawPager(2, 4, "/r/demo/render")

	uassert.Equal(t, "Overview | [Clients]", tabs)
	uassert.Equal(t, "Page 2/4 | [Prev](/r/demo/render?page=1) | [Next](/r/demo/render?page=3)", pager)
}

func TestDrawLinkAndLinkList(t *testing.T) {
	link := DrawLink("Package Docs", "/p/pantani/gnorender")
	list := DrawLinkList("Links",
		Link{Label: "Package Docs", Target: "/p/pantani/gnorender"},
		Link{Target: "/r/pantani/renderdemo"},
	)

	uassert.Equal(t, "[Package Docs](/p/pantani/gnorender)", link)
	uassert.Equal(t, "## Links\n\n- [Package Docs](/p/pantani/gnorender)\n- [/r/pantani/renderdemo](/r/pantani/renderdemo)", list)
}

func TestDrawLinkNormalizesRootSections(t *testing.T) {
	uassert.Equal(t, "[Realms](/r/)", DrawLink("Realms", "/r"))
	uassert.Equal(t, "[Packages](/p/)", DrawLink("Packages", "/p"))
	uassert.Equal(t, "[Examples](/e/)", DrawLink("Examples", "/e"))
}

func TestDrawLinkListEmptyAfterFiltering(t *testing.T) {
	got := DrawLinkList("Links", Link{}, Link{Label: "   "})

	uassert.Equal(t, "## Links\n\nNo links.", got)
}

func TestDrawTabsLabelFallback(t *testing.T) {
	got := DrawTabs("transfers",
		Tab{ID: "overview", Label: "Overview"},
		Tab{ID: "transfers"},
		Tab{},
	)

	uassert.Equal(t, "Overview | [transfers]", got)
}

func TestDrawPagerWithExistingQuery(t *testing.T) {
	got := DrawPager(3, 5, "/r/demo/render?limit=20")

	uassert.Equal(t, "Page 3/5 | [Prev](/r/demo/render?limit=20&page=2) | [Next](/r/demo/render?limit=20&page=4)", got)
}

func TestDrawPagerBounds(t *testing.T) {
	uassert.Equal(t, "Page 1/1", DrawPager(0, 0, "/r/demo/render"))
	uassert.Equal(t, "Page 4/4 | [Prev](/r/demo/render?page=3)", DrawPager(9, 4, "/r/demo/render"))
}
