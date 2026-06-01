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
import Tagged_Primitives
import Collection_Protocol_Primitives
import Index_Primitives
import Array_Primitives
import Tagged_Collection_Primitives

// A minimal `Collection.`Protocol`` conformer backed by an institute `Array`,
// standing in for the real consumers (graph node-storage, pool entries) to
// exercise the `Tagged` indexed-view bridge end to end.
private struct Payloads: Collection.`Protocol` {
    var storage: Array_Primitives.Array<Int>

    typealias Element = Int
    typealias Index = Index_Primitives.Index<Int>

    var startIndex: Index { storage.startIndex }
    var endIndex: Index { storage.endIndex }
    func index(after i: Index) -> Index { storage.index(after: i) }
    subscript(position: Index) -> Int { storage[position] }
}

private enum Node {}

@Suite struct TaggedIndexedViewTests {
    @Test func readsThroughPhantomTaggedIndices() {
        var storage = Array_Primitives.Array<Int>()
        storage.append(10)
        storage.append(20)
        storage.append(30)

        // `Tagged<Node, Payloads>` re-exposes Payloads through `Index<Node>`.
        let nodes = Tagged<Node, Payloads>(Payloads(storage: storage))

        #expect(!nodes.isEmpty)

        var collected: [Int] = []
        var i = nodes.startIndex
        while i < nodes.endIndex {
            collected.append(nodes[i])      // subscript by Index<Node>, not Index<Int>
            i = nodes.index(after: i)
        }
        #expect(collected == [10, 20, 30])
    }
}
