//
// Created by Bohan Feng on 4/24/23.
//

import Foundation
import UIKit

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet var tableView: UITableView!


	override func viewDidLoad()
	{
		super.viewDidLoad()

		tableView.dataSource = self
		tableView.delegate = self

//		fetchContacts()
	}

	override func viewDidAppear(_ animated: Bool)
	{
//		super.viewDidAppear(animated)

		fetchContacts()
		BDebug("viewDidAppear")
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
//		fatalError("tableView(_:numberOfRowsInSection:) has not been implemented")
		contacts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
//		fatalError("tableView(_:cellForRowAt:) has not been implemented")
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell

		let chat = contacts[indexPath.row]

		var contactName = ""

		if chat.senderId1 == Global.shared.user!.id
		{
			contactName = chat.senderName2
		}
		else
		{
			contactName = chat.senderName1
		}

		cell.labelContactName.text = contactName
		cell.labelLastMessage.text = chat.lastMessageContent

		// convert unix timestamp to date
		let date = Date(timeIntervalSince1970: TimeInterval(chat.lastCommunicatedTime))

		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
		dateFormatter.locale = NSLocale.current

		if Calendar.current.isDateInToday(date)
		{
			dateFormatter.dateFormat = "HH:mm"
		}
		else if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
		{
			dateFormatter.dateFormat = "MMM-dd"
		}
		else
		{
			dateFormatter.dateFormat = "yyyy-MMM"
		}

		cell.labelTime.text = dateFormatter.string(from: date)

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)

		self.performSegue(withIdentifier: "ContactsToChat", sender: indexPath)

		BDebug("didSelectRowAt")

//		let vc = storyboard?.instantiateViewController(identifier: "ChatDetailVC") as! ChatDetailVC
//		vc.contactName = "Contact Name \(indexPath.row)"
//		vc.contactId = indexPath.row
//		navigationController?.pushViewController(vc, animated: true)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "ContactsToChat"
		{
			let navigation = segue.destination as! UINavigationController

			let vc = navigation.topViewController as! ChatVC

			let indexPath = sender as! IndexPath

			vc.chat = contacts[indexPath.row]
		}
	}

	var contacts: [Chat] = []

	func fetchContacts()
	{
		ApiRequest()
				.subDomains(["chat", "get", "\(Global.shared.user!.id)"])
				.method(.GET)
				.onSuccess
				{
					(data, response, error) in
					let chats = try! JSONDecoder().decode([Chat].self, from: data!)
					BDebug("GetChatList success with chats: \(chats)")

					self.contacts = chats

					self.tableView.reloadData()
				}
				.send()
	}
}
