//
//  Extension+Date.swift
//  GitHubApplication
//
//  Created by Consultant on 1/13/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import Foundation

enum DateFormatters {
    static var toStringFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
    static var toDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return f
    }()
}

extension Date {
    func toString() -> String {
        return DateFormatters.toStringFormatter.string(from: self)
    }
}
extension String {
    func toDate() -> Date? {
        return DateFormatters.toDateFormatter.date(from: self)
    }
}
