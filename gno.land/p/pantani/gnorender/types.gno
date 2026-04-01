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

type ChecklistItem struct {
	Label   string
	Done    bool
	Blocked bool
	Note    string
}

type Metric struct {
	Label string
	Value string
	Delta string
	Kind  NoticeKind
}

type Tab struct {
	ID     string
	Label  string
	Target string
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

type VoteBreakdown struct {
	Yes     int
	No      int
	Abstain int
	Veto    int
}

type EventEntry struct {
	Time       string
	Type       string
	Summary    string
	Attributes []KV
}

type ComparisonRow struct {
	Field  string
	Before string
	After  string
}

type LegendItem struct {
	Kind        NoticeKind
	Label       string
	Description string
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

type TxReceipt struct {
	Hash      string
	Status    TxStatusKind
	Sender    string
	Height    string
	GasWanted string
	GasUsed   string
	Messages  []string
	Events    []EventEntry
}

type Method struct {
	Name        string
	Signature   string
	Description string
}

type CoinBalance struct {
	Denom  string
	Amount string
	Value  string
}

type ProposalSummary struct {
	ID       string
	Title    string
	Status   string
	Proposer string
	Summary  string
	Tally    VoteBreakdown
}

type Validator struct {
	Moniker     string
	Address     string
	VotingPower string
	Status      string
}

type AddressEntry struct {
	Name    string
	Address string
	Note    string
}

type ContractMetadata struct {
	Name        string
	Path        string
	Owner       string
	Version     string
	Description string
}

type RealmPage struct {
	Label       string
	Target      string
	Description string
}
