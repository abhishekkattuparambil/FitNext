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
    static let CGoptimalBlue: CGColor = CGColor(srgbRed: 142/255, green: 219/255, blue: 239/255, alpha: 1)
    static let subOptimalBlue: UIColor = UIColor.rgb(6,123,139)
    static let topColor: UIColor = UIColor.cyan
    static let bottomColor: UIColor = UIColor.systemBlue
}
func checkUsername(_ username: String) -> Bool {
    return username != "" && (username.isAlphanumeric || username.contains("_") || username.contains("-"))
}
