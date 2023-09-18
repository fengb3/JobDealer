//
// Created by Bohan Feng on 4/24/23.
//

import Foundation
import UIKit

class ChatCellSelf : UITableViewCell
{
	@IBOutlet var labelMessage : UILabel!
//	@IBOutlet var viewBubble : UIView!

	override func awakeFromNib()
	{
		super.awakeFromNib()
		// Initialization code

        labelMessage.layer.cornerRadius = 10
        
		// set bubble to round corner
		// viewBubble.layer.cornerRadius = 10
	}
}
