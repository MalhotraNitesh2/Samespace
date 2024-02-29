//
//  TrackTableViewCell.swift
//  Samespace
//
//  Created by Nitesh Malhotra on 26/02/24.
//

import Foundation
import UIKit
class TrackTableViewCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
            
            trackImage.layer.cornerRadius = trackImage.frame.size.width / 2
            trackImage.clipsToBounds = true
        }
}
