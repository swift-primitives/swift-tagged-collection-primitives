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

// Test Support shell per [MOD-011] / [MOD-024]. Re-exports the package's own
// product plus the Collection Primitives Test Support spine anchor (the TS of
// the collection dependency), which vends Collection.Fixture conformers.
@_exported public import Tagged_Collection_Primitives
@_exported public import Collection_Primitives_Test_Support
