//
//  ContactView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/26/23.
//

import SwiftUI

struct ContactView: View
{
	@ObservedObject var globe: Globe = Globe.shared

	var body: some View
	{
		VStack
		{
			ScrollViewReader
			{
				scrollViewProxy in
				ScrollView
				{
					ForEach(globe.contacts)
					{
						chat in

						let chatMessages: ChatMessages = ChatMessages(chat: chat)

						NavigationLink(destination: ChatView(chatMessages: chatMessages))
						{
							ContactItem(chat: chat)
						}
								.foregroundColor(.primary)

					}.padding()
				}
						.onAppear(perform: fetchContact)
						.onChange(of: globe.contacts.count)
						{
							_ in
							scrollViewProxy.scrollTo(globe.contacts.count - 1)
						}
			}
		}
	}

	func fetchContact()
	{
		ApiRequest()
				.subDomains(["chat", "get", "\(Globe.shared.user!.id)"])
				.method(.get)
				.onSuccess
				{
					(data, response, error) in
					let chats = try! JSONDecoder().decode([Chat].self, from: data!)
					// BDebug("GetChatList success with chats: \(chats)")

					Globe.shared.contacts = chats

					var messages : [Int64: ChatMessages] = [:]

					for i in 0..<chats.count
					{
						let chat = chats[i]
						let chatId = chat.id
						let chatMessage = ChatMessages(chat: chat)
						if(chat.senderId1==Globe.shared.user!.id)
						{
							chatMessage.chatName = chat.senderName2
						}
						else
						{
							chatMessage.chatName = chat.senderName1
						}
						messages[chatId] = chatMessage
					}
				}
				.send()
	}
}

struct ContactView_Previews: PreviewProvider
{
	static var previews: some View
	{
		Globe.shared.user = User(id: 1, userName: "bohan", password: "1", typeMask: 1)
		return ContactView()
	}
}
