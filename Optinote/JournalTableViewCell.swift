//
//  JournalTableViewCell.swift
//  Optinote
//
//  Created by Christopher Fiegel on 7/6/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    @IBOutlet weak var journalData: UILabel!
    @IBOutlet weak var journalDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
