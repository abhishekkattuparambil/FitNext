//
//  CalendarCell.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/29/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    func color(completed: Bool) {
        if completed {
            self.backgroundColor = constants.optimalGreen
        } else {
            self.backgroundColor = constants.suboptimalRed
        }
    }
}
