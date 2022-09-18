/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 17/09/2022
    Last modified: 18/09/2022
*/

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
