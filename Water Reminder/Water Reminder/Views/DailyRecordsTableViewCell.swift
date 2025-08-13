//
//  DailyRecordsTableViewCell.swift
//  Water Reminder
//
//  Created by iMac on 08/08/25.
//

import UIKit

class DailyRecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var uiVIew: UIView!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        uiVIew.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
