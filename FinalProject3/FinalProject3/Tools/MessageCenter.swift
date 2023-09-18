//
// Created by Bohan Feng on 4/28/23.
//

import Foundation

class MessageCenter : ObservableObject
{
	static var shared = MessageCenter()

	func register(_ name: String, _ callback: @escaping (Any) -> Void)
	{
		BDebug("register \(name)")
		NotificationCenter.default.addObserver(forName: NSNotification.Name(name), object: nil, queue: nil)
		{
			notification in
			callback(notification.object)
		}
	}

	func post(_ name: String, _ object: Any? = nil)
	{
		BDebug("post \(name)")
		NotificationCenter.default.post(name: NSNotification.Name(name), object: object)
	}
}