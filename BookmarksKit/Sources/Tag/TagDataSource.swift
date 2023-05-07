//
//  TagDataSource.swift
//
//
//  Copyright (c) 2023 Kiyohito Nara. All rights reserved.
//

import Combine

protocol TagDataSource: ObservableObject {
    var tags: [Tag] { get set }

    func insert(_ tag: Tag)

    func update(_ tag: Tag)

    func delete(_ tag: Tag)
}
