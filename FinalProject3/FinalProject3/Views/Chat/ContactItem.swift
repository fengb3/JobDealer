//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import SwiftUI

struct ContactItem: View
{
	var chat: Chat
	@State var imageUrl: String = ""

	var contactName: String
	{
		if(chat.senderId1 == Globe.shared.user!.id)
		{
			return chat.senderName2
		}
		else
		{
			return chat.senderName1
		}
	}

	var contactId: Int64
	{
		if(chat.senderId1 == Globe.shared.user!.id)
		{
			return chat.senderId2
		}
		else
		{
			return chat.senderId1
		}
	}

	var body: some View
	{
			HStack
			{
				Image($imageUrl.wrappedValue)
						.resizable()
						.frame(width: 80, height: 80)
						.foregroundColor(Color.blue)
						//						.padding()
						.background(.green)
						.cornerRadius(40)
				VStack
				{
					HStack
					{
						Text("\(contactName)")
								.font(.title2)
								// .frame()
						Spacer()
						Text("\(chat.lastCommunicatedTime.toDateString())")
								.font(.subheadline)
								.foregroundColor(Color.gray)
					}
					HStack
					{
						Text("\(chat.lastMessageContent)")
								.font(.subheadline)
								.foregroundColor(Color.gray)
                                .lineLimit(1)
						Spacer()
					}
							.padding([.top],1)
				}
						.padding([.trailing], 5)
			}
					.padding(5)
					.background(UIColor.systemGray5.toSwiftUIColor())
					.cornerRadius(10)
					.onAppear()
					{
						fetchImage()
					}

	}

	func fetchImage()
	{
		ApiRequest()
				.subDomains(["user", "imageUrl", "\(contactId)"])
				.method(.get)
				.onSuccess
				{
					data, response, error in
					if let data = data
					{
						imageUrl = String(data: data, encoding: .utf8)!
						BInfo("get image url success \(imageUrl)")
					}
				}
				.send()
	}
}

struct ContactItem_Previews: PreviewProvider
{
	static var previews: some View
	{
        _ = Date().addingTimeInterval(-86400)

		let theDayBeforeYesterday = Date().addingTimeInterval(-86400 * 2)

        _ = Date().addingTimeInterval(-86400 * 7)

		let chat = Chat(
				senderId1: 1,
				senderId2: 2,
				lastCommunicatedTime: Int64(theDayBeforeYesterday.timeIntervalSince1970 ),
				senderName1: "Bohan Feng",
				senderName2: "Bohan Zhang",
				lastMessageContent: "Hello"
		)

		Globe.shared.user! = User(id: 1, userName: "Bohan", password: "123", typeMask: 1)
		Globe.shared.person! = Person(id: 1, userId: 1, firstName: "Bohan", lastName: "Zhang")
		return ContactItem(chat:chat)
	}
}

