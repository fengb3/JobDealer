//
//  ChatVC.swift
//  FinalProject
//
//  Created by 生物球藻 on 4/24/23.
//

import Foundation
import UIKit
import SwiftUI


class ChatVC: ViewController
{

	@IBOutlet var container: UIView!
    
    @IBOutlet weak var inputField: UITextField!

	@IBAction func onBackPressed(_ sender: Any)
	{
		self.dismiss(animated: true, completion: nil)
	}
    
    @IBAction func onSendPressed(_ sender: Any)
    {
		let messageText = inputField.text!

		if(messageText.isEmpty)
		{
			return
		}

		SignalRService.shared.sendMessage(Global.shared.user!.id, otherUserId, messageText)
		inputField.text = ""
		chatMessages.addMessage(message: ChatMessage(messageText, true))
    }

	var chat: Chat!
	var otherUserId: Int64! = 0;
    var chatMessages: ChatMessages!
    var chatView : ChatView!

	override func viewDidLoad()
	{
		super.viewDidLoad()
        
        title = chat.senderId1 == Global.shared.user?.id ? chat.senderName2 : chat.senderName1
        
        chatMessages = ChatMessages()

        chatView = ChatView(chatMessages: chatMessages, chatName: title!)

		let childView = UIHostingController(rootView: chatView)
		addChild(childView)
		childView.view.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(childView.view)

		NSLayoutConstraint.activate([
										childView.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
										childView.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
										childView.view.topAnchor.constraint(equalTo: container.topAnchor),
										childView.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
									])

		childView.didMove(toParent: self)

		BDebug("ChatVC is loaded with chat: \(chat ?? nil)")

		otherUserId = chat.senderId1 == Global.shared.user?.id ? chat.senderId2 : chat.senderId1

		SignalRService.shared.joinChat(Global.shared.user!.id, otherUserId)

		SignalRService.shared.registerReceivingMessage{ fromUserId, toUserId, s in
			if toUserId == Global.shared.user!.id
			{
				self.chatMessages.addMessage(message: ChatMessage(s,false))
			}
		}
	}

	override func viewDidAppear(_ animated: Bool)
	{
		// fetch ChatHistory
		ApiRequest()
				.subDomains(["chat", "getMessages", "\(chat.id)"])
				.method(.GET)
				.onSuccess
				{
					(data, response, error) in

					let chatHistories = try! JSONDecoder().decode([chatHistory].self, from: data!)

					BDebug(chatHistories)

					// convert chat Histories to ChatMessages
					var currMessages = [ChatMessage]()
					if(chatHistories.count > 0)
					{
						for chatHistory in chatHistories
						{
							let message = ChatMessage(chatHistory.message, chatHistory.senderId == Global.shared.user!.id)
							currMessages.append(message)
						}
					}

					self.chatMessages.setMessage(messages: currMessages)
				}
				.send()
	}

	private struct chatHistory : Codable
	{
		var id: Int64 = 0
		var chatId: Int64 = 0
		var message: String = ""
		var senderId: Int64 = 0
	}
}
