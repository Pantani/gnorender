# gnorender

`gnorender` is a small helper library for building `Render(path string) string`
outputs in Gno packages and realms.

This repository now keeps the package mirrored under its Gno import path and
split by responsibility, so it is easier to maintain and evolve.

## Repository Layout

```text
.
└── gno.land/p/pantani/gnorender
    ├── gnomod.toml
    ├── README.md
    ├── formatting.gno
    ├── formatting_test.gno
    ├── helpers.gno
    ├── navigation.gno
    ├── panel.gno
    ├── sections.gno
    ├── table.gno
    ├── types.gno
    ├── widgets.gno
    ├── navigation_test.gno
    ├── panel_test.gno
    ├── sections_test.gno
    ├── table_test.gno
    └── widgets_test.gno
```

## What Lives Where

- `types.gno`: exported types and enums like `Table`, `Column`, `Metric`, and `Tab`
- `sections.gno`: titles, sections, dividers, lists, description lists, and empty states
- `formatting.gno`: ordered lists, status lines, badges, callouts, blockquotes, progress bars, and code blocks
- `panel.gno`: boxed panel rendering
- `navigation.gno`: links, tabs, and pager helpers
- `table.gno`: markdown and ASCII table APIs plus rendering internals
- `widgets.gno`: breadcrumbs, metrics, timelines, diffs, address helpers, filters, cards, forms, and objects
- `helpers.gno`: shared string and formatting helpers
- `*_test.gno`: tests grouped by feature area

## Package Usage

Import the package from:

```go
import "gno.land/p/pantani/gnorender"
```

See the package guide in
[`gno.land/p/pantani/gnorender/README.md`](./gno.land/p/pantani/gnorender/README.md)
for the full helper catalog and examples.

## Running Tests

From the repository root, use the command style available in your setup:

```sh
gno test ./gno.land/p/pantani/gnorender
```

Or, if you expose Gno through `go tool`:

```sh
go tool gno test ./gno.land/p/pantani/gnorender
```
