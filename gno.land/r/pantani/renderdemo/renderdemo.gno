package renderdemo

import "gno.land/p/pantani/gnorender"

func Render(path string) string {
	title := gnorender.DrawTitle("Render Demo")
	status := gnorender.DrawStatus("Library", "working")
	table := gnorender.DrawTable(
		[]string{"Helper", "Result"},
		[]string{"DrawTitle", "ok"},
		[]string{"DrawStatus", "ok"},
		[]string{"DrawTable", "ok"},
	)
	panel := gnorender.DrawPanel(
		"Manual Test",
		"Open this realm in gnoweb\nand verify the layout.",
	)

	return title + "\n\n" + status + "\n\n" + table + "\n\n" + panel
}
