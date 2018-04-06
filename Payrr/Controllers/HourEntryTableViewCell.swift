//
//  HourEntryTableViewCell.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/26/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit

class HourEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
