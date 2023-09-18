//
//  SignalRService.swift
//  FinalProject
//
//  Created by bohan feng on 4/18/23.
//

import Foundation
import SignalRClient

public class SignalRService
{
	static let shared = SignalRService()

	var hubConnection: HubConnection

	init()
	{
		let url = URL(string: "http://0.0.0.0:7202/chatHub")!
		hubConnection = HubConnectionBuilder(url: url)
				//				.withHubConnectionDelegate(delegate: ConnectDelegate())
				.withLogging(minLogLevel: .info, logger: MyLogger())
				.build()

		hubConnection.on(method: "SubscribeUserId", callback: subscribeUserId)
		hubConnection.on(method: "ReceiveMessage", callback: receiveMessage)
		hubConnection.on(method: "ReceiveFile", callback: receiveFile)
	}

	func connectToChatServer()
	{
		hubConnection.start()
	}

	func disconnectFromChatServer()
	{
		hubConnection.stop()
	}

	func subscribeUserId()
	{
		hubConnection.send(method: "SubscribeUserId", Globe.shared.user?.id ?? 0)
		             { error in
			             if let error = error
			             {
				             BError("\(error) when subscribing user id")
			             }
			             else
			             {
				             BInfo("Subscribed user id to chat server")
			             }
		             }
	}

	func sendMessage(_ fromUserId: Int64, _ toUserId: Int64, _ message: String)
	{
		hubConnection.send(method: "SendMessage", fromUserId, toUserId, message)
		             { error in
			             if let error = error
			             {
				             BError("\(error) when sending message")
			             }
			             else
			             {
				             BInfo("Sent message to chat server")
			             }
		             }
	}

	func receiveMessage(_ fromUserId: Int64, _ toUserId: Int64, _ message: String, _ chatId: Int64, _ messageId: Int64)
	{
		// BInfo("Received message from chat server in chat \(chatId)")
		hubConnection.send(method: "ReceiveMessage", fromUserId, toUserId, message, chatId, messageId)
		             { error in
			             if let error = error
			             {
				             BError("\(error) when receiving message")
			             }
			             else
			             {
				             BInfo("Received message from chat server")
				             let callback = self.receivingCallbacks[chatId]
				             if let callback = callback
				             {
					             callback(fromUserId, toUserId, message, chatId, messageId)
				             }
				             else
				             {
					             BError("No callback for chat \(chatId)")
				             }
			             }
		             }
	}

	func joinChat(_ fromUserId: Int64, _ toUserId: Int64)
	{
		hubConnection.send(method: "JoinChat", fromUserId, toUserId)
		             { error in
			             if let error = error
			             {
				             BError("\(error) when joining chat")
			             }
			             else
			             {
				             BInfo("Joined chat")
			             }
		             }
	}

	func unregisterReceivingMessage(chatId: Int64)
	{
		BDebug("Unregistering receiving message callback for chat \(chatId)")
		receivingCallbacks.removeValue(forKey: chatId)
	}

	private var receivingCallbacks: [Int64: (Int64, Int64, String, Int64, Int64) -> Void] = [:]

	func registerReceivingMessage(chatId: Int64, callback: @escaping (Int64, Int64, String, Int64, Int64) -> Void)
	{
		BDebug("Registering receiving message callback for chat \(chatId)")
		receivingCallbacks[chatId] = callback
	}

	func sendFile(_ senderId: Int64, _ receiverId: Int64, _ fileData: Data, _ fileName: String, _ fileType: String)
	{
		hubConnection.invoke(method: "SendFile", senderId, receiverId, fileData, fileName, fileType)
		             {
			             error in
			             if let error = error
			             {
				             print("Error sending file: \(error)")
			             }
			             else
			             {
				             print("File sent successfully")
			             }
		             }
	}

	func receiveFile(_ senderId: Int64, _ fileName: String, _ fileType: String, _ fileData: Data)
	{
		hubConnection.send(method: "ReceiveFile", senderId, fileName, fileType, fileData)
		             { error in
			             if let error = error
			             {
				             print("Error receiving file: \(error)")
			             }
			             else
			             {
				             print("Received File From Server")
				             for callback in self.receivingFileCallbacks
				             {
					             callback(senderId, fileName, fileType, fileData)
				             }
			             }
		             }
	}

	private var receivingFileCallbacks: [(Int64, String, String, Data) -> Void] = []

	func registerReceivingFile(callback: @escaping (Int64, String, String, Data) -> Void)
	{
		BDebug("Registering receiving file callback")
		receivingFileCallbacks.append(callback)
	}


}

