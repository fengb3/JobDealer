//
//  SeekerDetailView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct SeekerDetailView: View
{
	@ObservedObject var data: SeekerData
    var chatView: ChatView = ChatView(chatMessages: ChatMessages(chat: Chat()))

    @State var isCommunicate: Bool = false

    var body: some View
	{
		ScrollView
		{
			VStack
            {
                HStack
                {
                    Image(data.person.imageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding()
                    HStack
                    {
                        Text("\(data.person.firstName) \(data.person.lastName)")
                                .font(.title)
//                                .bold()
                        Spacer()
                    }
                }

                VStack
                {
                    HStack
                    {
                        Image(systemName: "graduationcap.circle")
                        Text("\(data.seeker.school)")
                                .font(.title3)
                                .lineLimit(1)
                        Spacer()
                    }
                            .padding([.vertical], 5)
                    HStack
                    {
                        Image(systemName: "book.circle")
                        Text("\(data.seeker.major)")
                                .font(.title3)
                                .lineLimit(1)
                        Spacer()
                    }
                            .padding([.vertical], 5)
                    HStack
                    {
                        Image(systemName: "person.2.circle")
                        Text("\(data.seeker.degree)")
                                .font(.title3)
                                .lineLimit(1)
                        Spacer()
                    }
                            .padding([.vertical], 5)
                    HStack
                    {
                        Image(systemName: "calendar.circle")
                        Text("\(data.seeker.graduationYear)")
                                .font(.title3)
                                .lineLimit(1)
                        Spacer()
                    }
                            .padding([.vertical], 5)
                    HStack
                    {
                        Image(systemName: "hammer.circle")
                        Text("\(data.seeker.skills)")
                                .font(.title3)
                                .lineLimit(1)
                        Spacer()
                    }
                            .padding([.vertical], 5)
                    HStack
                    {
                        VStack
                        {
                            Image(systemName: "")
                            Spacer()
                        }
                        Text("\(data.seeker.description)")
                                .font(.title3)
//                                .lineLimit()
//                        Spacer()
                    }
                            .padding([.vertical], 5)

                }
                HStack(alignment: .center, spacing:10)
                {
                    NavigationLink(destination: chatView, isActive: $isCommunicate) {
                        Button(action: onCommunicate) {
                            Text("Communicate")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(minWidth: 0, maxWidth: 350)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                        }
                                .padding([.vertical], 10)
                    }

                }
            }
                    .padding(10)
		}
	}

    func onCommunicate() {
        BDebug("on communicate clicked")
        isCommunicate = true

        ApiRequest()
                .subDomains(["chat", "create"])
                .method(.post)
                .body(
                        ["senderId1": Globe.shared.user!.id,
                         "senderId2": data.seeker.userId,
                        ])
                .onSuccess
                { data, response, error in

//					BDebug("apply success")

                    let chat = try! JSONDecoder().decode(Chat.self, from: data!)

                    BDebug(chat)

                    chatView.chatMessages.chat = chat
                    chatView.registerForJoinChat()

                    chatView.fetchMessages()
                }
                .send()

    }
}

struct SeekerDetailView_Previews: PreviewProvider
{
	static var previews: some View
	{
		let data = SeekerData()
		data.seeker = JobSeeker(
				school: "school",
				major: "major",
				degree: "degree",
				graduationYear: 2021,
				skills: "skills1 skills2 skills3",
				description: "Experienced software engineer with expertise in Java, Python, and SQL."
		)
		data.person = Person(
				firstName: "bohan",
				lastName: "feng",
				imageUrl: "Ellipse 59-1"
		)

		return SeekerDetailView(data: data)
	}
}
