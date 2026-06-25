import Collection_Primitives_Test_Support
import Index_Primitives
import Tagged_Collection_Primitives
import Tagged_Primitives
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
import Testing

private enum Node {}

@Suite struct TaggedIndexedViewTests {
    // The bridge is generic over ANY `Collection.`Protocol`` conformer, so it is
    // tested against `Collection.Fixture.Source` (vended by Collection Primitives
    // Test Support — the spine anchor) rather than any concrete container package.
    // `Tagged<Node, Source>` re-exposes the collection through `Index<Node>`.
    @Test func indexedViewOverACollectionConformer() {
        let source = Collection.Fixture.Source<Int>([10, 20, 30])
        let nodes = Tagged<Node, Collection.Fixture.Source<Int>>(source)

        #expect(!nodes.isEmpty)

        var collected: [Int] = []
        var i = nodes.startIndex
        while i < nodes.endIndex {
            collected.append(nodes[i])  // subscript by Index<Node>, not Index<Int>
            i = nodes.index(after: i)
        }
        #expect(collected == [10, 20, 30])
    }
}
