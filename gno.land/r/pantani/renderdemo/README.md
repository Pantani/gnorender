# RenderDemo

`RenderDemo` is a small showcase realm that imports
`gno.land/p/pantani/gnorender` and renders a simple page using the helper
library.

It is useful for manually validating that the package composes well inside a
real `Render(path string) string` function, including every exported helper and
all exported types.

## Files

- `renderdemo.gno`: the demo realm
- `gnomod.toml`: the realm package path for local tooling

## Prerequisites

- `gno` installed for local testing
- `gnodev` installed if you want to open the realm in `gnoweb`
- `gnokey` installed if you want to deploy to a remote network

This repository includes a root `gnowork.toml` so local Gno tooling can resolve
the dependency on `gno.land/p/pantani/gnorender` from the same workspace.

## Local Test

From the repository root:

```sh
cd gno.land/r/pantani/renderdemo
gno test . -v
```

This checks that the realm compiles and that the import of
`gno.land/p/pantani/gnorender` resolves correctly in the workspace.

## Local Deploy And Manual Test

To run the demo in a local node with hot reload:

```sh
cd gno.land/r/pantani/renderdemo
gnodev
```

Then open:

```text
http://127.0.0.1:8888/r/pantani/renderdemo
```

You should see a page containing:

- `# Render Demo`
- sections for overview, lists, markdown helpers, links and callouts, ASCII helpers, and code samples
- a pager and tabs example
- badges, callouts, blockquotes, and a progress bar
- markdown tables created by both helper functions and `Table.Render()`
- fenced ASCII output for `DrawPanel`, `DrawEmptyState`, and ASCII `Table.Render()`

This is the quickest end-to-end way to verify the library visually.

## Remote Deployment

For remote deployment with `gnokey`, there is one important caveat:

- current official Gno docs say remote deployments should use an address-based namespace such as `gno.land/r/<your_address>/renderdemo`
- current official Gno docs also say username-based namespaces are not currently supported for deployment

Because this demo currently uses:

```toml
module = "gno.land/r/pantani/renderdemo"
```

you will likely need to switch it to your address-based path before deploying to
a remote network.

You will also need the helper package deployed on-chain under a matching import
path. Since the demo imports:

```go
import "gno.land/p/pantani/gnorender"
```

that package path must exist on the target network too. If you are deploying to
staging or another remote network, the usual flow is:

1. Deploy the pure package under your own address-based namespace.
2. Update the realm import to that deployed package path.
3. Update this realm's `gnomod.toml` module path to your address-based realm path.
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

If deployment succeeds, open the deployed realm in `gnoweb` at:

```text
https://gno.land/r/<your_address>/renderdemo
```

## References

- Running and testing code: https://docs.gno.land/resources/gno-testing/
- Configuring Gno projects: https://docs.gno.land/resources/configuring-gno-projects/
- Running a local dev node: https://docs.gno.land/builders/local-dev-with-gnodev/
- Deploying packages: https://docs.gno.land/builders/deploy-packages/
