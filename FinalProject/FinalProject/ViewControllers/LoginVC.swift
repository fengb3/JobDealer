//
//  LoginVC.swift
//  FinalProject
//
//  Created by 生物球藻 on 4/18/23.
//

import Foundation
import UIKit

class LoginVC: UIViewController
{
	@IBOutlet weak var inputUsername: UITextField!

	@IBOutlet weak var inputPassword: UITextField!

	override func viewDidLoad()
	{
		super.viewDidLoad()

		inputPassword.text = "1"
		inputUsername.text = "bohan"

		// Do any additional setup after loading the view.
	}


	@IBAction func onLoginPressed(_ sender: Any)
	{
		BDebug("Login pressed")

		ApiRequest()
				.subDomains(["User", "Login"])
				.method
				{
					.POST
				}
				.body
				{
					["username": self.inputUsername.text!,
					 "password": self.inputPassword.text!, ]
				}
				.onSuccess
				{
					(data, response, error) in
					let user = try! JSONDecoder().decode(User.self, from: data!)
					BDebug("Login success with user: \(user)")

					Global.shared.user = user

//					self.performSegue(withIdentifier: "LoginToMain", sender: user)

					switch user.typeMask
					{
						case 1:
							self.performSegue(withIdentifier: "LoginToMain_Admin", sender: self)
						case 8:
							self.performSegue(withIdentifier: "LoginToMain_Seeker", sender: self)
						case 16:
							self.performSegue(withIdentifier: "LoginToMain_Poster", sender: self)
						default:
							BDebug("Unknown user type")
					}

					SignalRService.shared.connectToChatServer()
				}
				.send()
	}


	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.


		if (segue.identifier == "LoginToMain")
		{
			// printContent("hello")
		}
	}


}
