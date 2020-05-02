//
//  CompletionCell.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 5/1/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class CompletionCell: UICollectionViewCell {
    
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalProgress: UILabel!
    @IBOutlet weak var completionTag: UILabel!
    
    func setup(complete: Bool) {
        layer.borderWidth = 2
        layer.cornerRadius = 15
        
        if (complete) {
            completionTag.textColor = constants.optimalGreen
            completionTag.text = "Complete"
            layer.borderColor = constants.optimalGreen.cgColor
        } else {
            completionTag.textColor = constants.optimalRed
            completionTag.text = "Incomplete"
            layer.borderColor = constants.optimalRed.cgColor
        }
        goalName.textColor = constants.suboptimalBlue
        goalProgress.textColor = constants.suboptimalBlue
    }
    
}
