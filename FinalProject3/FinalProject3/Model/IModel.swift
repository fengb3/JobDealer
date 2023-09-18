//
// Created by Bohan Feng on 4/26/23.
//

import Foundation

protocol IModel
{
	var id: Int64
	{
		get set
	}
}

struct User: IModel, Codable
{
	var id: Int64 = 0;
	var userName: String = ""
	var password: String = ""
	var typeMask: Int64 = 0
}

struct Person: IModel, Codable
{
	var id: Int64 = 0

	var userId: Int64 = 0

	var firstName: String = ""
	var lastName: String = ""

	var email: String = ""
	var phone: String = ""

	var imageUrl: String = ""
	var location: String = ""
}

struct Chat: IModel, Codable, Identifiable
{
	var id: Int64 = 0
	var senderId1: Int64 = 0
	var senderId2: Int64 = 0
	var lastCommunicatedTime: Int64 = 0
	var senderName1: String = ""
	var senderName2: String = ""
	var lastMessageContent: String = ""
}

struct ChatMessage: IModel, Codable, Identifiable, Hashable
{
	var id: Int64 = 0
	var chatId: Int64 = 0
	var message: String = ""
	var time: Int64 = 0
	var senderId: Int64 = 0
}

struct JobPost: Codable
{
	var id: Int64 = 0
	var title: String = ""
	var description: String = ""
	var salary: Double = 0
	var location: String = ""
	var companyId: Int64 = 0
	var posterId: Int64 = 0

	// -- Optional
}

struct Company : Codable
{
	var id: Int64 = 0
	var name: String = ""
	var address: String = ""
	var description: String = ""
	var logoUrl: String = ""
}

struct JobPoster : Codable, Hashable
{
	var id: Int64 = 0
	var userId: Int64 = 0
	var personId: Int64 = 0
	var companyId: Int64 = 0
}

struct JobSeeker : Codable
{
	var id: Int64 = 0
	var userId: Int64 = 0
	var personId: Int64 = 0

	var school: String = ""
	var major: String = ""
	var degree: String = ""
	var graduationYear: Int64 = 0

	var experience: String = ""
	var skills: String = ""
	var description: String = ""
}

