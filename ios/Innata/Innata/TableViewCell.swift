//
//  TableViewCell.swift
//  Innata
//
//  Created by Ivan Chau on 1/21/17.
//  Copyright © 2017 Innata. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var merchant : UILabel!
    @IBOutlet weak var dolla : UILabel!
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var desc : UILabel!
    @IBOutlet weak var amountNum : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        amountNum.clipsToBounds = true
        amountNum.layer.cornerRadius = 12
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
