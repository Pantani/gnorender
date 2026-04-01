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

type Metric struct {
	Label string
	Value string
	Delta string
	Kind  NoticeKind
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

type TimelineItem struct {
	Time  string
	Title string
	Body  string
	Kind  NoticeKind
}

type Filter struct {
	Label  string
	Value  string
	Target string
	Active bool
}

type Field struct {
	Label    string
	Value    string
	Hint     string
	Required bool
}

type AddressFormat string

const (
	AddressFormatShort AddressFormat = "short"
	AddressFormatLong  AddressFormat = "long"
)

type TxStatusKind string

const (
	TxStatusPending TxStatusKind = "pending"
	TxStatusSuccess TxStatusKind = "success"
	TxStatusFailed  TxStatusKind = "failed"
	TxStatusExpired TxStatusKind = "expired"
)
