//
//  TagFakeDataSource.swift
//
//
//  Copyright (c) 2023 Kiyohito Nara. All rights reserved.
//

import Foundation
import os

public class TagFakeDataSource: TagDataSource {
    @Published public var tags = [
        Tag(name: "Example tag 1", note: "This is example tag 1.", timestamp: Date(timeIntervalSinceReferenceDate: 634224000)),
        Tag(name: "Example tag 2", note: "This is example tag 2.", timestamp: Date(timeIntervalSinceReferenceDate: 634310400)),
        Tag(name: "Example tag 3", note: "This is example tag 3.", timestamp: Date(timeIntervalSinceReferenceDate: 634396800)),
        Tag(name: "Example tag 4", note: "This is example tag 4.", timestamp: Date(timeIntervalSinceReferenceDate: 634483200)),
        Tag(name: "Example tag 5", note: "This is example tag 5.", timestamp: Date(timeIntervalSinceReferenceDate: 634569600)),
    ]
        
    private let logger = Logger(subsystem: "io.github.kiyohitonara.Bookmarks", category: "TagFakeDataSource")
    
    public init() {
        logger.info("Initializing TagFakeDataSource")
    }
    
    public func insert(_ tag: Tag) {
        logger.info("Inserting tag: \(tag.name)")
        
        tags.append(tag)
    }
    
    public func update(_ tag: Tag) {
        logger.info("Updating tag: \(tag.name)")
        
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags[index] = tag
        } else {
            logger.warning("Tag with ID \(tag.id) not found, skipping update")
        }
    }
    
    public func delete(_ tag: Tag) {
        logger.info("Deleting tag: \(tag.name)")
        
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags.remove(at: index)
        } else {
            logger.warning("Tag with ID \(tag.id) not found, skipping delete")
        }
    }
}
