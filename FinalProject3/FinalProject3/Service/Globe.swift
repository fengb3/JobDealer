//
// Created by Bohan Feng on 4/26/23.
//

import Foundation

class Globe : ObservableObject
{
	@Published var user: User? = User()
	@Published var person: Person? = Person()
	@Published var contacts: [Chat] = []

	// for job poster
	@Published var company: Company? = Company()
	@Published var datas: [JobPostDetailViewData] = []


	// for seeker
	@Published var jobSeeker: JobSeeker? = JobSeeker()

	// var chatMessages: [Int64: ChatMessages] = [:]

	static var shared = Globe()

	var mainView: MainView?
}
