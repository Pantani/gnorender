package gnorender

import (
	"testing"

	"gno.land/p/nt/uassert/v0"
)

func TestDrawBlockquote(t *testing.T) {
	got := DrawBlockquote("Line one\n\nLine two")

	uassert.Equal(t, `> Line one
>
> Line two`, got)
}

func TestDrawCallout(t *testing.T) {
	got := DrawCallout(NoticeWarning, "Pending packets", "Drain the queue\nbefore upgrade.")

	uassert.Equal(t, `> **🟡 Warning: Pending packets**
>
> Drain the queue
> before upgrade.`, got)
}

func TestDrawCalloutFallbackKind(t *testing.T) {
	got := DrawCallout("", "", "Just a note.")

	uassert.Equal(t, `> **⚪ Note**
>
> Just a note.`, got)
}

func TestDrawProgressBar(t *testing.T) {
	uassert.Equal(t, "**Sync:** `[###-------] 30% (3/10)`", DrawProgressBar("Sync", 3, 10, 10))
	uassert.Equal(t, "`[----------] 0% (0/0)`", DrawProgressBar("", 5, 0, 10))
}

func TestDrawBadge(t *testing.T) {
	uassert.Equal(t, "🟢 Ready", DrawBadge(NoticeSuccess, "Ready"))
	uassert.Equal(t, "⚪", DrawBadge("", ""))
}

func TestDrawProgressBarClampsCurrent(t *testing.T) {
	got := DrawProgressBar("Sync", 20, 10, 5)

	uassert.Equal(t, "**Sync:** `[#####] 100% (10/10)`", got)
}

func TestDrawCodeBlockAddsTrailingNewline(t *testing.T) {
	got := DrawCodeBlock("go", "println(\"hi\")")

	uassert.Equal(t, "```go\nprintln(\"hi\")\n```", got)
}
