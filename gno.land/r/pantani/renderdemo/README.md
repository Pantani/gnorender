# RenderDemo

`RenderDemo` is a showcase realm for `gno.land/p/pantani/gnorender`.

It is meant for manual inspection in `gnoweb` and for quick compile checks in a
local Gno workspace.

## Files

- `renderdemo.gno`: the demo realm and showcase page
- `gnomod.toml`: the local realm module path

The repository root includes `gnowork.toml`, so local Gno tooling can resolve
the package dependency from the same workspace.

## What The Demo Shows

- core layout helpers such as sections, lists, dividers, tables, code blocks
- navigation helpers such as breadcrumbs, tabs, linked tabs, filter bars, pagers
- formatting helpers such as badges, callouts, blockquotes, progress bars
- state and workflow helpers such as timelines, diffs, checklists, legends, empty states
- transaction and governance helpers such as tx status, tx receipts, vote breakdowns, proposal summaries
- Gno-specific helpers such as realm headers, package headers, balances, validators, metadata, and realm indexes
- fenced ASCII output for `DrawPanel`, `DrawEmptyState`, and ASCII `Table.Render()`

## Local Compile Test

From the repository root:

```sh
cd gno.land/r/pantani/renderdemo
gno test . -v
```

This validates that the realm compiles and that the workspace import of
`gno.land/p/pantani/gnorender` resolves correctly.

## Local Manual Test

Start a local dev node:

```sh
cd gno.land/r/pantani/renderdemo
gnodev
```

Then open:

```text
http://127.0.0.1:8888/r/pantani/renderdemo
```

When the page loads correctly, you should see:

- `# Render Demo` at the top
- an overview section with breadcrumbs, filters, tabs, pager, and coverage progress
- dedicated sections for navigation, metrics, lists, data views, history/state, forms/callouts
- workflow widgets including checklist, legend, comparison table, linked tabs, and empty state with action
- governance and transaction widgets including vote breakdowns, event logs, tx receipt, and proposal summary
- Gno-specific helper sections for realm/package metadata, method list, balances, validators, address book, and realm index
- fenced ASCII previews for panel, empty state, and ASCII tables

## Remote Deployment

For remote deployment with `gnokey`, note that official Gno deployment docs
currently describe address-based namespaces for on-chain packages and realms.

This demo currently uses:

```toml
module = "gno.land/r/pantani/renderdemo"
```

That is convenient for local workspace testing, but for remote deployment you
will likely need to switch both the realm path and imported package path to your
address-based namespace.

Typical flow:

1. Deploy the pure package under your address-based `gno.land/p/...` path.
2. Update the demo import to that deployed package path.
3. Update this realm `gnomod.toml` to your address-based `gno.land/r/...` path.
4. Deploy the realm with `gnokey maketx addpkg`.

Example command shape:

```sh
gnokey maketx addpkg \
  -pkgpath "gno.land/r/<your_address>/renderdemo" \
  -pkgdir "." \
  -gas-fee 10000000ugnot \
  -gas-wanted 8000000 \
  -broadcast \
  -chainid staging \
  -remote "https://rpc.gno.land:443" \
  MyKey
```

After deployment, open:

```text
https://gno.land/r/<your_address>/renderdemo
```
