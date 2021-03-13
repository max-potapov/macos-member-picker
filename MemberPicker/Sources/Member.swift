//
//  Member.swift
//  MemberPicker
//
//  Created by Maxim Potapov on 13.03.2021.
//  Copyright © 2021 Monsters, Inc. All rights reserved.
//

import Foundation

struct Member: Equatable, Hashable, CustomStringConvertible {
    let id: Int
    let name: String?
    let email: String?

    var description: String {
        return "id: \(id)" + ", name: \(name ?? "-")" + ", email: \(email ?? "-")"
    }

    static func populated() -> [Self] {
        [
            .init(id: 0, name: "Jiří Mátl", email: "isteryonaten@apple.com"),
            .init(id: 1, name: "Jan Doležal", email: "ompardomagas@hp.com"),
            .init(id: 2, name: "Dita Kollárová", email: "romentismort@dell.com"),
            .init(id: 3, name: "Vlastimil Opava", email: "ablectiblasm@ibm.com"),
            .init(id: 4, name: "Daniel Lukeš", email: "candenthewic@lenovo.com"),
            .init(id: 5, name: "Renata Továrková", email: "chevalaropho@samsung.com"),
            .init(id: 6, name: "Adam Nastoupil", email: "tifthenerful@acer.com"),
            .init(id: 7, name: "Silvie Mudrochová", email: "narinyaperse@asustek.com")
        ]
    }
}
