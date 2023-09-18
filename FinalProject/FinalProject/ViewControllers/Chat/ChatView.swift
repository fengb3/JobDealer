//
//  ChatView.swift
//  FinalProject
//
//  Created by 生物球藻 on 4/24/23.
//

import SwiftUI

struct ChatView: View
{
	@ObservedObject var chatMessages: ChatMessages
	var chatName: String

	init(chatMessages: ChatMessages, chatName: String)
	{
		self.chatMessages = chatMessages
		self.chatName = chatName
	}

	var body: some View
	{
		VStack
		{
//			Text(chatName)
//				.font(.title2)
////				.padding([.top], 10)
			ScrollViewReader
			{ scrollViewProxy in
				ScrollView
				{
					VStack
					{
						ForEach(self.chatMessages.messages, id: \.self)
						{ message in
							ChatBubbleView(chatMessage: message)
						}
					}
				}
						.onChange(of: self.chatMessages.messages)
						{ _ in
							if let lastMessage = chatMessages.messages.last
							{
								withAnimation
								{
									scrollViewProxy.scrollTo(lastMessage, anchor: .bottom)
								}
							}
						}
			} }
	}
}


struct ChatView_Previews: PreviewProvider
{
	static var previews: some View
	{
		let chatMessages = ChatMessages()
		chatMessages.setMessage(messages:
								[
									ChatMessage("hello", true),
									ChatMessage("Hi, how are you", false),
									ChatMessage("I'm fine, thanks", true),
									ChatMessage("I am your Daddy, who are you", false),
									ChatMessage("I am your son", true),
									ChatMessage("Great i'll fuck ur mon and make one more you", false),
                                    ChatMessage("Yee, Yeeeeeee \n", true)
								]
		)
		return ChatView(chatMessages: chatMessages, chatName:"Daddy Along")
	}
}

class ChatMessages: ObservableObject
{
	@Published var messages: [ChatMessage] = []

	func setMessage(messages: [ChatMessage])
	{
		self.messages = messages
	}

	func addMessage(message: ChatMessage)
	{
		messages.append(message)
	}
}
