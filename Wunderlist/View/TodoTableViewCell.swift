//
//  TodoTableViewCell.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var completeToggleButton: UIButton!
    
    
    
    // MARK: - Actions
    @IBAction func completeToggleTapped(_ sender: Any) {
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
