//
//  ContactListCell.swift
//  FinalProject
//
//  Created by 生物球藻 on 4/24/23.
//

import Foundation
import UIKit

class ChatListCell : UITableViewCell
{
    @IBOutlet var labelContactName : UILabel!
    @IBOutlet var labelLastMessage : UILabel!
    @IBOutlet var imageHead : UIImageView!
    @IBOutlet var labelTime : UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code

        // set image to circle
        imageHead.layer.cornerRadius = imageHead.frame.size.width / 2
    }
}
