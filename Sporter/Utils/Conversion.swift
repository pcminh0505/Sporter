//
//  Conversion.swift
//  Sporter
//
//  Created by Minh Pham on 17/09/2022.
//

import Foundation

class ConversionHelper {
    static func getAge(_ bod: TimeInterval) -> Int {
        let birthday = NSDate(timeIntervalSince1970: bod)
        let now = Date()
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday as Date, to: now)
        return ageComponents.year!
    }
}
