//
//  UserDisplayCell.swift
//  GitHubApplication
//
//  Created by Consultant on 1/10/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import UIKit

class UserDisplayCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var prevTag: Int? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
