//
// Created by Bohan Feng on 4/26/23.
//

import Foundation

import SwiftUI

struct ChatBubbleView: View
{

	var chatMessage: ChatMessage
	var isCurrentUser: Bool
	{
		return chatMessage.senderId == Globe.shared.user?.id
	}

	init(chatMessage: ChatMessage)
	{
		self.chatMessage = chatMessage
	}

	var body: some View
	{
		HStack(alignment: .bottom, spacing: 15)
		{
			if (isCurrentUser)
			{
				Spacer()
			}
			Text(chatMessage.message)
					.padding(10)
					.foregroundColor(isCurrentUser ? Color.white : Color.black)
					.background(isCurrentUser ? Color.blue : Color(UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1.0)))
					.cornerRadius(10)
			if (!isCurrentUser)
			{
				Spacer()
			}
		}
				.padding([.horizontal], 20)
				.padding([.vertical], 10)
	}
}

struct ChatBubbleView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ChatBubbleView(chatMessage: ChatMessage(
				id: 1,
				chatId: 1,
				message: "Hello",
				time: getNow(),
				senderId: 1
				))
	}
}
