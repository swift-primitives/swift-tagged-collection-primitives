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

// The bridge's public surface references `Tagged`, `Collection.\`Protocol\``,
// and `Index`, so consumers see them through this module per [PKG-DEP-003].
@_exported public import Tagged_Primitives
@_exported public import Collection_Protocol_Primitives
@_exported public import Index_Primitives
