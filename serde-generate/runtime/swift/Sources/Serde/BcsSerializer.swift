//  Copyright (c) Facebook, Inc. and its affiliates.

import Foundation

public class BcsSerializer: BinarySerializer {
    public let MAX_LENGTH = Int64(Int.max)
    public let MAX_CONTAINER_DEPTH: Int64 = 500

    public init() {
        super.init(maxContainerDepth: MAX_CONTAINER_DEPTH)
    }

    private func serialize_u32_as_uleb128(value: UInt32) throws {
        var input = value
        while input >= 0x80 {
            try writeByte(UInt8((value & 0x7F) | 0x80))
            input >>= 7
        }
        try writeByte(UInt8(input))
    }

    override public func serialize_len(value len: Int64) throws {
        try serialize_u32_as_uleb128(value: UInt32(len))
    }

    override public func serialize_variant_index(value: Int) throws {
        try serialize_u32_as_uleb128(value: UInt32(value))
    }

    override public func sort_map_entries(offsets _: [Int]) {
        // TODO:
    }
}