//
//  EmailExtractor.swift
//  MemberPicker
//
//  Created by Maxim Potapov on 13.03.2021.
//  Copyright © 2021 Monsters, Inc. All rights reserved.
//

import Foundation

struct EmailExtractor {
    struct NoMatchesError: Swift.Error {}

    static func extract(_ string: String) -> String? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let range = NSRange(string.startIndex..<string.endIndex, in: string)
            let matches = detector.matches(in: string, options: [], range: range)
            guard
                let match = matches.first(where: { $0.url?.scheme == "mailto" }),
                let url = match.url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else {
                throw NoMatchesError()
            }
            return components.path.lowercased()
        } catch {
            return nil
        }
    }
}
