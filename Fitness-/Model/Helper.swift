//
//  Helper.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/6/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import Foundation
import UIKit

enum constants{
    static let deadlift: UIImage? = UIImage(named: "barbell")
    static let bench: UIImage? = UIImage(named: "bench")
    static let squat: UIImage? = UIImage(named: "squat")
    static let dumbbell: UIImage? = UIImage(named: "dumbbell")
    static let optimalBlue: UIColor = UIColor.rgb(142, 219, 236)
    static let optimalGreen: UIColor = UIColor.rgb(129,206,151)
    static let optimalRed: UIColor = UIColor.rgb(204,51,51)
    static let suboptimalBlue: UIColor = UIColor.rgb(6,123,139)
    static let verySuboptimalBlue: UIColor = UIColor.rgb(208,241,249)
    static let calendar = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    static let suboptimalRed: UIColor = UIColor.rgb(255, 128, 128)
}
func checkUsername(_ username: String) -> Bool {
    return username != "" && (username.isAlphanumeric || username.contains("_") || username.contains("-"))
}

func currentDate() -> String {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "MM-dd-yyyy"
    let formattedDate = format.string(from: date)
    return formattedDate
}

func currentMonth() -> Int {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "MM"
    let formattedDate = format.string(from: date)
    return formattedDate.toInt()!
}

func currentYear() -> Int {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "yyyy"
    let formattedDate = format.string(from: date)
    return formattedDate.toInt()!
}

func currentTime() -> String {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "h:mm a"
    let formattedDate = format.string(from: date)
    return formattedDate
}

func getDate(date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "MM-dd-yyyy"
    let formattedDate = format.string(from: date)
    return formattedDate
}

func getPreviousDate(days: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: -days, to: Date())!
}

