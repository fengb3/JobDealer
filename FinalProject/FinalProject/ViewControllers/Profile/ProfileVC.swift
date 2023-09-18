//
// Created by Bohan Feng on 4/21/23.
//

import Foundation
import UIKit

class ProfileVC: UIViewController
{
    var person: Person?
    
    @IBOutlet weak var imageHead: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    
	override func viewDidLoad()
	{
		super.viewDidLoad()

		fetchPerson()
	}

	func fetchPerson()
	{
		ApiRequest()
				.method(.GET)
				.subDomains(["user", "profile", "\(Global.shared.user!.id)"])
				.onSuccess
				{ data, response, error in

					if let data = data
					{
						let json = try? JSONSerialization.jsonObject(with: data, options: [])

						if let dictionary = json as? [String: Any]
						{
							if let personDict = dictionary["person"] as? [String: Any]
							{
								let jsonPerson = try? JSONSerialization.data(withJSONObject: personDict, options: [])
								self.person = try? JSONDecoder().decode(Person.self, from: jsonPerson!)
								BDebug(self.person!)
							}
						}
					}

					self.refresh()

				}
				.send()
	}

	func refresh()
	{
		imageHead.image = UIImage(named: "head")
		labelName.text = "\(person?.firstName ?? "") \(person?.lastName ?? "")"
		labelLocation.text = person?.location
		labelEmail.text = person?.email
		//  format phone number with 000-000-0000
		labelPhone.text = "\(person?.phone.prefix(3) ?? "???")-\(person?.phone.prefix(6).suffix(3) ?? "???")-\(person?.phone.suffix(4) ?? "????")"
	}


}
