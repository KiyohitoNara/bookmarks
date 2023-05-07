//
//  Tag.swift
//
//
//  Copyright (c) 2023 Kiyohito Nara. All rights reserved.
//

import Foundation

public struct Tag: Identifiable, Hashable {
    public let id: UUID

    public var name: String
    public var note: String
    public var timestamp: Date

    public init(id: UUID = UUID(), name: String, note: String, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.note = note
        self.timestamp = timestamp
    }
}
