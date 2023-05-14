//
//  TagFakeDataSourceTests.swift
//
//
//  Copyright (c) 2023 Kiyohito Nara. All rights reserved.
//

import BookmarksKit
import XCTest

class TagFakeDataSourceTests: XCTestCase {
    var dataSource: TagFakeDataSource!

    override func setUp() {
        super.setUp()
        
        dataSource = TagFakeDataSource()
    }

    override func tearDown() {
        dataSource = nil
        
        super.tearDown()
    }
    
    func testInsert() {
        let tag = Tag(name: "Test tag", note: "This is a test tag.", timestamp: Date())
        
        dataSource.insert(tag)
        
        XCTAssertTrue(dataSource.tags.contains(tag))
    }
    
    func testUpdate() {
        var tag = dataSource.tags[0]
        tag.name = "Updated tag"
        tag.note = "This is updated tag."
        
        dataSource.update(tag)
        
        XCTAssertTrue(dataSource.tags.contains(tag))
    }
    
    func testDelete() {
        let tag = dataSource.tags[0]
        
        dataSource.delete(tag)
        
        XCTAssertFalse(dataSource.tags.contains(tag))
    }
}
