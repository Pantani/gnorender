package gnorender

type Format string

const (
	FormatMarkdown Format = "markdown"
	FormatASCII    Format = "ascii"
)

type Align string

const (
	AlignLeft   Align = "left"
	AlignCenter Align = "center"
	AlignRight  Align = "right"
)

type Column struct {
	Label string
	Align Align
	Width int
}

type Table struct {
	Title   string
	Columns []Column
	Rows    [][]string
	Empty   string
	Format  Format
}

type KV struct {
	Key   string
	Value string
}

type Link struct {
	Label  string
	Target string
}

type Tab struct {
	ID    string
	Label string
}

type NoticeKind string

const (
	NoticeInfo    NoticeKind = "info"
	NoticeSuccess NoticeKind = "success"
	NoticeWarning NoticeKind = "warning"
	NoticeError   NoticeKind = "error"
)
