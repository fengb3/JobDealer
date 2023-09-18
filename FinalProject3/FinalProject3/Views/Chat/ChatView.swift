//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import SwiftUI

import MobileCoreServices
import UIKit

struct ChatView: View
{
//	@State var chat: Chat = Chat()

	@ObservedObject var globe: Globe = Globe.shared
	@ObservedObject var chatMessages: ChatMessages = ChatMessages(chat: Chat())

	@State var inPutMessage: String = ""
	@State private var showDocumentPicker = false


	var otherUserId: Int64
	{
		chatMessages.chat.senderId1 == Globe.shared.user!.id ? chatMessages.chat.senderId2 : chatMessages.chat.senderId1
	}

	var body: some View
	{
		VStack
		{
			VStack
			{
				ScrollViewReader
				{
					scrollViewProxy in
					ScrollView
					{
						VStack
						{
							ForEach(chatMessages.messages)
							{
								message in
								ChatBubbleView(chatMessage: message)
							}
						}
					}
							.onChange(of: chatMessages.messages)
							{
								_ in
								scrollToBottom(scrollViewProxy: scrollViewProxy)
							}
							.onAppear
							{
								DispatchQueue.main.async
								{
									scrollToBottom(scrollViewProxy: scrollViewProxy)
								}
							}
				}
			}
			HStack
			{
				TextField("Message", text: $inPutMessage, axis: .vertical)
						.padding(10)
						.background(Color.gray.opacity(0.2))
						.cornerRadius(10)
						.onSubmit(onSendMessage)
				Button(action: onSendMessage)
				{
					Image(systemName: "paperplane.fill")
							.padding([.horizontal], 5)
							.padding(10)
							.foregroundColor(Color.white)
							.background(Color.blue)
							.cornerRadius(10)
				}
				Button(action: onSendAttachment)
				{
					Image(systemName: "paperclip")
							.padding([.horizontal], 5)
							.padding(10)
							.foregroundColor(Color.white)
							.background(Color.blue)
							.cornerRadius(10)
				}
			}
					.padding([.horizontal, .bottom])
					// .background()
			// .shadow(radius: 1)
		}
				.onAppear
				{
					if (chatMessages.chat.id == 0)
					{
						return
					}

					fetchMessages()
					SignalRService.shared.registerReceivingMessage(chatId: chatMessages.chat.id, callback: onReceiveMessage)
					SignalRService.shared.registerReceivingFile(callback: onReceiveFile)
				}
				.onViewDidLoad
				{
					registerForJoinChat()
					BDebug("view did load")
				}
				.onDisappear()
				{
//					SignalRService.shared.leaveChat(globe.user!.id, otherUserId)
					SignalRService.shared.unregisterReceivingMessage(chatId: chatMessages.chat.id)
					BDebug("view did disappear")
				}
				.navigationBarTitle(chatMessages.chat.senderId1 == Globe.shared.user!.id ? chatMessages.chat.senderName2 : chatMessages.chat.senderName1, displayMode: .inline)
				.sheet(isPresented: $showDocumentPicker) {
					DocumentPicker { url in
						sendFile(selectedFileURL: url)
					}
				}
	}

	func registerForJoinChat()
	{
		SignalRService.shared.joinChat(globe.user!.id, otherUserId)
		SignalRService.shared.registerReceivingMessage(chatId: chatMessages.chat.id, callback: onReceiveMessage)
	}

	func scrollToBottom(scrollViewProxy: ScrollViewProxy)
	{
		if let lastMessage = chatMessages.messages.last
		{
			withAnimation
			{
				scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
			}
		}
	}

	func onSendMessage()
	{
		if (inPutMessage == "")
		{
			return
		}

		BDebug("send message \(inPutMessage)")

		SignalRService.shared.sendMessage(Globe.shared.user!.id, otherUserId, inPutMessage)

		inPutMessage = ""

	}

	func onReceiveMessage(fromUserId: Int64, toUserId: Int64, message: String, chatId: Int64, messageId: Int64)
	{
		let receivedMessage = ChatMessage(id: messageId, chatId: chatId, message: message, time: getNow(), senderId: fromUserId)
		chatMessages.messages.append(receivedMessage)
		BDebug("receive message \(message)")
	}

	func fetchMessages()
	{
		ApiRequest()
				.subDomains(["chat", "getMessages", "\(chatMessages.chat.id)"])
				.method(.get)
				.onSuccess
				{
					(data, response, error) in

					let currMessages = try! JSONDecoder().decode([ChatMessage].self, from: data!)
					// BDebug(currMessages)
					BDebug("fetch messages success with messages: \(currMessages)")

					chatMessages.messages = currMessages
				}
				.send()
	}

	func onSendAttachment()
	{
		BDebug("send attachment")
		pickDocument()
	}

	func pickDocument() {
		showDocumentPicker = true
	}

	func sendFile(selectedFileURL: URL) {
		do {
			let fileData = try Data(contentsOf: selectedFileURL)
			let fileName = selectedFileURL.lastPathComponent
			let resourceValues = try selectedFileURL.resourceValues(forKeys: Set([.typeIdentifierKey]))
			let fileType = resourceValues.typeIdentifier ?? "unknown"

			SignalRService.shared.sendFile(Globe.shared.user!.id, otherUserId, fileData, fileName, fileType)
		} catch {
			BDebug("Failed to read the file: \(error)")
		}
	}

	func onReceiveFile(fromUserId: Int64, fileName: String, fileType: String, fileData: Data)
	{
		// Process the received file, e.g., display it in the chat or save it to the device

		if(fromUserId == Globe.shared.user!.id)
		{
			BDebug("Notified that the file was sent successfully")
			return
		}
		BDebug("Received file: \(fileName) with type: \(fileType) from user: \(fromUserId) with data: \(fileData.count) bytes)")
		saveFileToDevice(data: fileData, fileName: fileName, fileType: fileType)
	}


    func saveFileToDevice(data: Data, fileName: String, fileType: String) {
        let fileManager = FileManager.default
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.bohan.finalProject")

        guard let fileURL = containerURL?.appendingPathComponent(fileName) else {
            print("Error: Failed to create file URL.")
            return
        }

        do {
            try data.write(to: fileURL)
            print("File saved to \(fileURL)")
            var filesToShare = [Any]()
            filesToShare.append(fileURL)
            let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)

        } catch {
            print("Error saving file: \(error)")
        }
    
    }
}

struct ChatView_Previews: PreviewProvider
{
	static var previews: some View
	{
		let chat = Chat(id: 1, senderId1: 1, senderId2: 2, senderName1: "Bohan", senderName2: "John")
		let chatMessages = ChatMessages(chat: chat)
		chatMessages.messages = [
			ChatMessage(id: 1, chatId: 1, message: "Hello", time: getNow(), senderId: 1),
			ChatMessage(id: 2, chatId: 1, message: "Hi", time: getNow(), senderId: 2),
			ChatMessage(id: 3, chatId: 1, message: "How are you?", time: getNow(), senderId: 1),
			ChatMessage(id: 4, chatId: 1, message: "I'm fine", time: getNow(), senderId: 2)
		]

		Globe.shared.user?.id = 1

		return ChatView(chatMessages: chatMessages)
	}
}

class ChatMessages: ObservableObject
{
	@Published var chat: Chat = Chat()
	@Published var messages: [ChatMessage] = []
	@Published var chatName: String = ""

	init(chat: Chat, messages: [ChatMessage] = [])
	{
		self.chat = chat
		self.messages = messages
	}
}

