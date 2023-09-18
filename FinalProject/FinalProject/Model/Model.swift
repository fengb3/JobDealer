//
//  Model.swift
//  Model
//
//  Created by 生物球藻 on 4/18/23.
//

import SwiftUI

struct Company : Codable
{
	var id: Int64 = 0
	var name: String = ""
	var address: String = ""
	var description: String = ""
	var logoUrl: String = ""
}

struct User: Codable
{
	var id: Int64 = 0
	var userName: String = ""
	var password: String = ""
	var typeMask: Int64 = 0
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

struct Person: Codable
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

struct UserType
{
	var id: Int64 = 0
	var name: String = ""
	var mask: Int64 = 0
}

enum UserTypeMask: Int64
{
	case admin = 1
//	case employer = 2
//	case employee = 4
	case JobSeeker = 8
	case JobPoster = 16
}

struct Chat: Codable
{
	var id: Int64 = 0
	var senderId1: Int64 = 0
	var senderId2: Int64 = 0
	var lastCommunicatedTime: Int64 = 0
	var senderName1: String = ""
	var senderName2: String = ""
	var lastMessageContent: String = ""
}
