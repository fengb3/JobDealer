//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI

struct JobPostDetailView : View
{
	@ObservedObject var data: JobPostDetailViewData = JobPostDetailViewData()
	// @ObservedObject var chatMessages: ChatMessages = ChatMessages(chat: Chat())

	var chatView: ChatView = ChatView(chatMessages: ChatMessages(chat: Chat()))

	@State var isApply: Bool = false

	var body: some View
	{
		ScrollView
		{
			VStack
			{
				HStack
				{
					Image(systemName: "dollarsign.circle")
					Text("Salary: \(Int(data.jobPost.salary))")
							.font(.body)
					Spacer()
				}
						.padding([.vertical], 5)
				HStack
				{
					Image(systemName: "building.2.crop.circle")
					Text("\(data.company.name)")
							.font(.body)
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
					Text(data.jobPost.description)
							.font(.body)
					Spacer()
				}
						.padding([.vertical], 5)
				HStack
				{
					Map(coordinateRegion: .constant(MKCoordinateRegion(
							center: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude),
							span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
					    interactionModes: [])
							.frame(width: 350, height: 300)
							.cornerRadius(20)

				}
				HStack(alignment: .center, spacing:10)
				{
					NavigationLink(destination: chatView, isActive: $isApply) {
						Button(action: onApply) {
							Text("Apply")
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
			}.padding(10)
		}
				.navigationBarTitle(data.jobPost.title, displayMode: .inline)
				.onAppear
				{
					data.fetchCoordinates()
					data.fetchCompany()
					data.reportUserViewed()
				}

	}

	func onApply()
	{
		BDebug("on apply clicked")
		isApply = true

		ApiRequest()
				.subDomains(["chat", "create"])
				.method(.post)
				.body(
						["senderId1": Globe.shared.user!.id,
						 "senderId2": data.jobPost.posterId,
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

struct JobPostDetailView_Previews: PreviewProvider
{
	static var previews: some View
	{
		let post = JobPost(
				title: "iOS Engineer long long long",
				description: "As an iOS Engineer, you will be responsible for designing and developing high-quality mobile applications for Apple's iOS platform. You will work closely with other engineers, designers, and product managers to create user-friendly, performant, and scalable applications that provide an excellent user experience.\n\nYour responsibilities will include:\n\nDeveloping and maintaining iOS applications using Swift, Objective-C, and other relevant technologies.\nCollaborating with cross-functional teams to identify and prioritize features, and to ensure that the product meets customer needs and requirements.\nWriting clean, reusable, and efficient code, and conducting code reviews to ensure quality and maintainability.\nImplementing new features, fixing bugs, and improving the performance of existing applications.\nStaying up-to-date with the latest iOS development trends and best practices, and sharing knowledge with the team.\nThe ideal candidate will have:\n\nAt least 3 years of experience in iOS development, with a strong understanding of Swift and Objective-C.\nexperience with iOS frameworks such as UIKit, Core Data, and Core Animation.\nFamiliarity with REST ful APIs, JSON, and networking concepts.\nKnowledge of software design patterns and architectural principles.\nStrong problem-solving and debugging skills.\nExcellent communication and collaboration skills, with the ability to work effectively in a team environment.",
				salary: 10000,
				location: "Boston, Ma",
				companyId: 1
		)

		let data = JobPostDetailViewData()

		data.jobPost = post

//		data.company = company

		data.fetchCoordinates()

		return JobPostDetailView(data: data)
	}
}

class JobPostDetailViewData: ObservableObject, Identifiable
{
	@Published var jobPost: JobPost = JobPost()
	@Published var company: Company = Company()
	@Published var longitude: Double = 0.0
	@Published var latitude: Double = 0.0

	func fetchCoordinates()
	{
		let geoCoder = CLGeocoder()
		geoCoder.geocodeAddressString(jobPost.location)
		        { placemark, error in
			        guard let placemarks = placemark,
			              let location = placemarks.first?.location
			        else
			        {
				        // handle no location found
				        BError("No location found \(self.jobPost.location)")
				        return
			        }

			        DispatchQueue.main.async
			        {
				        self.longitude = location.coordinate.longitude
				        self.latitude = location.coordinate.latitude
			        }

			        BDebug("\(self.longitude) - \(self.latitude)")
		        }
	}

	func fetchCompany()
	{
		ApiRequest()
				.subDomains(["Company", "get", "\(jobPost.companyId)"])
				.method(.get)
				.onSuccess
				{ data, response, error in
					if let data = data
					{
						do
						{
							let company = try JSONDecoder().decode(Company.self, from: data)
							self.company = company
						} catch
						{
							BDebug(error)
						}
					}
				}
				.send()
	}

	func reportUserViewed()
	{
		ApiRequest()
				.subDomains(["JobPost", "viewed", "\(Globe.shared.user!.id)","\(jobPost.id)"])
				.method(.get)
				.onSuccess({ data, response, error in
					BInfo("Reported user viewed success")
				})
				.send()
	}
}