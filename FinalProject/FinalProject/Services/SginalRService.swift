//
//  SignalRService.swift
//  FinalProject
//
//  Created by 生物球藻 on 4/18/23.
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
		hubConnection.send(method: "SubscribeUserId", Global.shared.user?.id ?? 0)
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

	func receiveMessage(_ fromUserId: Int64, _ toUserId: Int64, _ message: String)
	{
		hubConnection.send(method: "ReceiveMessage", fromUserId, toUserId, message)
		{ error in
			if let error = error
			{
				BError("\(error) when receiving message")
			}
			else
			{
				BInfo("Received message from chat server")
				for callback in self.receivingCallbacks
				{
					callback(fromUserId, toUserId, message)
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


	private var receivingCallbacks: [(Int64, Int64, String) -> Void] = []

	func registerReceivingMessage( callback: @escaping (Int64, Int64, String) -> Void)
	{
		receivingCallbacks.append(callback)
	}
}

