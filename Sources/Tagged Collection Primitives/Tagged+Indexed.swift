// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
public import Collection_Protocol_Primitives
public import Index_Primitives
public import Tagged_Primitives

// ============================================================================
// MARK: - Tagged as a phantom-typed indexed collection view
// ============================================================================
//
// When `Tagged`'s `Underlying` is an institute collection whose index domain
// is the default `Index<Element>`, `Tagged<Tag, Underlying>` re-exposes that
// collection through `Index<Tag>` instead of `Index<Element>`. The phantom
// `Tag` distinguishes this collection's positions from any other's — e.g.
// `Tagged<Node, Array<Payload>>` indexes by `Index<Node>`, not `Index<Payload>`.
//
// This is the single, generic replacement for the per-container
// `*.Indexed<Tag>` wrappers: the mechanism is `Tagged`'s own `retag`, applied
// to the `Tagged`-based `Index` (`Index<T> == Tagged<T, Ordinal>`).
//
// The view is READ-ONLY: `Tagged.underlying` is `package(set)`, so a settable
// subscript cannot write through it from this package. Mutable consumers keep
// a plain collection and `retag` at the call site.

// `Tagged` already declares a member `Index` (via its `Swift.Collection`
// conformance: `typealias Index = Underlying.Index`), so the bare name `Index`
// inside this extension resolves to THAT, shadowing the top-level generic
// `Index_Primitives.Index<>`. References to the phantom index are therefore
// fully qualified per [API-IMPL-019].
extension Tagged
where
    Tag: ~Copyable & ~Escapable,
    Underlying: Collection.`Protocol`,
    Underlying.Element: Copyable,
    Underlying.Index == Index_Primitives.Index<Underlying.Element>
{
    /// The phantom-typed element count, for typed bounds checking.
    public var count: Index_Primitives.Index<Tag>.Count {
        underlying.count.retag(Tag.self)
    }

    /// Whether the collection is empty.
    public var isEmpty: Bool {
        underlying.isEmpty
    }

    /// The position of the first element, in the `Tag` index domain.
    public var startIndex: Index_Primitives.Index<Tag> {
        underlying.startIndex.retag(Tag.self)
    }

    /// The collection's "past the end" position, in the `Tag` index domain.
    public var endIndex: Index_Primitives.Index<Tag> {
        underlying.endIndex.retag(Tag.self)
    }

    /// Returns the position immediately after `i`.
    public func index(after i: Index_Primitives.Index<Tag>) -> Index_Primitives.Index<Tag> {
        underlying.index(after: i.retag(Underlying.Element.self)).retag(Tag.self)
    }

    /// Accesses the element at the given phantom-typed index.
    public subscript(position: Index_Primitives.Index<Tag>) -> Underlying.Element {
        underlying[position.retag(Underlying.Element.self)]
    }
}
