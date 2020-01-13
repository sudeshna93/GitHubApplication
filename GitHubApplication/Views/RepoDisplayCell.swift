//
//  RepoDisplayCell.swift
//  GitHubApplication
//
//  Created by Consultant on 1/11/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import UIKit

class RepoDisplayCell: UITableViewCell {

    @IBOutlet weak var numberOfStar: UILabel!
    @IBOutlet weak var numberOfForks: UILabel!
    @IBOutlet weak var repositoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
