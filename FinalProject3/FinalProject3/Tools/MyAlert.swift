//
// Created by Bohan Feng on 4/21/23.
//

import Foundation
import UIKit

public class MyAlert
{
	var alert: UIAlertController = UIAlertController()

	init()
	{
		alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
	}

	func title(_ title: String) -> MyAlert {
		alert.title = title
		return self;
	}

	func message(_ message: String) -> MyAlert {
		alert.message = message
		return self;
	}

	func addAction(_ title: String, _ handler: ((UIAlertAction) -> Void)?) -> MyAlert {
		alert.addAction(UIAlertAction(title: title, style: .default, handler: handler))
		return self;
	}

	func show(_ view: UIViewController?) {
		view?.present(alert, animated: true)
	}

	func show(_ view : UIView)
	{
		view.window?.rootViewController?.present(alert, animated: true)
	}
}
