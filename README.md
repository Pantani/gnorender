# gnorender

`gnorender` is a rendering helper library for Gno packages and realms.

It is designed to make `Render(path string) string` easier to compose with
small Markdown-friendly helpers, higher-level workflow widgets, and
Gno-specific presentation helpers.

## Repository Layout

```text
.
├── .gitignore
├── gnowork.toml
├── README.md
├── gno.land/p/pantani/gnorender
│   ├── gnomod.toml
│   ├── README.md
│   ├── types.gno
│   ├── helpers.gno
│   ├── sections.gno
│   ├── formatting.gno
│   ├── panel.gno
│   ├── navigation.gno
│   ├── table.gno
│   ├── widgets.gno
│   ├── advanced_widgets.gno
│   ├── gno_widgets.gno
│   └── *_test.gno
└── gno.land/r/pantani/renderdemo
    ├── gnomod.toml
    ├── README.md
    └── renderdemo.gno
```

## Package Map

- `types.gno`: exported types and enums
- `sections.gno`: titles, sections, lists, dividers, description lists, empty states
- `formatting.gno`: ordered lists, badges, status lines, callouts, progress, code blocks
- `panel.gno`: ASCII panel rendering
- `navigation.gno`: links, link lists, tabs, pager helpers
- `table.gno`: markdown and ASCII table rendering
- `widgets.gno`: breadcrumbs, metrics, timelines, diffs, addresses, filters, forms, objects
- `advanced_widgets.gno`: checklist, legend, comparison, event log, tx receipt, empty states with actions, linked tabs
- `gno_widgets.gno`: realm/package headers, governance, balances, validators, address books, metadata, realm index
- `helpers.gno`: shared formatting internals

## What The Library Covers

- Basic layout: titles, sections, dividers, lists, ordered lists, description lists
- Navigation: links, breadcrumbs, tabs, linked tabs, filter bars, pagers
- Formatting: badges, blockquotes, callouts, progress bars, code fences
- Data views: markdown tables, ASCII tables, key/value tables, JSON-like objects
- State and workflow: timelines, diffs, checklists, legends, empty states with actions
- Transactions and governance: tx status, tx receipts, vote breakdowns, proposal summaries
- Gno-specific views: realm headers, package headers, method lists, balances, validators, address books, metadata, realm indexes

## Package Import

```go
import "gno.land/p/pantani/gnorender"
```

The full package guide lives in
[`gno.land/p/pantani/gnorender/README.md`](./gno.land/p/pantani/gnorender/README.md).

## Demo Realm

The repository includes a showcase realm at
[`gno.land/r/pantani/renderdemo`](./gno.land/r/pantani/renderdemo) that renders
most helpers in one page for manual inspection in `gnoweb`.

## Running Tests

From the repository root:

```sh
gno test ./gno.land/p/pantani/gnorender
gno test ./gno.land/r/pantani/renderdemo
```

If your setup exposes Gno through `go tool`:

```sh
go tool gno test ./gno.land/p/pantani/gnorender
go tool gno test ./gno.land/r/pantani/renderdemo
```
