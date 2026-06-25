# Tagged Collection Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Re-exposes an institute collection through a phantom-typed index — `Tagged<Tag, Underlying>` indexes by `Index<Tag>` instead of `Index<Element>`, so positions from one collection can never be confused with another's.

---

## Quick Start

This package is a single, generic bridge between [Tagged Primitives](https://github.com/swift-primitives/swift-tagged-primitives), [Collection Protocol Primitives](https://github.com/swift-primitives/swift-collection-primitives), and [Index Primitives](https://github.com/swift-primitives/swift-index-primitives). When `Tagged`'s `Underlying` is a collection whose index domain is the default `Index<Element>`, `Tagged<Tag, Underlying>` re-exposes that collection through `Index<Tag>`. The phantom `Tag` distinguishes this collection's positions from any other's, caught at compile time rather than runtime.

```swift
import Tagged_Collection_Primitives

enum Node {}

// Any `Collection.Protocol` conformer whose Index is `Index<Element>`.
let source = Collection.Fixture.Source<Int>([10, 20, 30])

// `Tagged<Node, …>` re-exposes the collection through `Index<Node>`.
let nodes = Tagged<Node, Collection.Fixture.Source<Int>>(source)

#expect(!nodes.isEmpty)

var collected: [Int] = []
var i = nodes.startIndex
while i < nodes.endIndex {
    collected.append(nodes[i])      // subscript by Index<Node>, not Index<Int>
    i = nodes.index(after: i)
}
// collected == [10, 20, 30]
```

The bridge is a read-only view: `Tagged.underlying` is `package(set)`, so the subscript cannot write through it from a consumer. The mechanism is `Tagged`'s own `retag`, applied to the `Tagged`-based `Index` (`Index<T> == Tagged<T, Ordinal>`) — it is the single generic replacement for per-container `*.Indexed<Tag>` wrappers. Mutable consumers keep a plain collection and `retag` at the call site.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-tagged-collection-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Tagged Collection Primitives", package: "swift-tagged-collection-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

One library product plus a test-support product. The package is pure integration — it adds a single generic extension on `Tagged` and re-exports its three dependencies.

| Product | Target | Purpose |
|---------|--------|---------|
| `Tagged Collection Primitives` | `Sources/Tagged Collection Primitives/` | The phantom-typed indexed-collection view: an extension on `Tagged` exposing `count`, `isEmpty`, `startIndex`, `endIndex`, `index(after:)`, and `subscript(position:)` in the `Index<Tag>` domain. Re-exports `Tagged Primitives`, `Collection Protocol Primitives`, and `Index Primitives`. |
| `Tagged Collection Primitives Test Support` | `Tests/Support/` | Re-exports the main target plus the `Collection Primitives Test Support` spine, which vends `Collection.Fixture` conformers for tests. |

Dependencies: [swift-tagged-primitives](https://github.com/swift-primitives/swift-tagged-primitives), [swift-collection-primitives](https://github.com/swift-primitives/swift-collection-primitives), [swift-index-primitives](https://github.com/swift-primitives/swift-index-primitives).

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
