//
//  JobPostDetailView.swift
//  FinalProject
//
//  Created by 生物球藻 on 4/25/23.
//

import SwiftUI
import _MapKit_SwiftUI

struct JobPostDetailView: View
{
	@ObservedObject var data: JobPostDetailViewData

	var onApply: () -> Void = {}

	init(data: JobPostDetailViewData, onApply: @escaping () -> Void = {})
	{
		self.data = data
		self.onApply = onApply

		data.fetchCompany()
		data.fetchCoordinates()
	}

	var body: some View
	{
		ScrollView
		{
			VStack
			{
				HStack
				{
					Spacer()
					Text(data.jobPost.title)
							.font(.largeTitle)
					Spacer()
				}
						.padding([.vertical], 5)
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
					// make this on horizontal fill

					Button(action: self.onApply)
					{
						Text("Apply")
								.font(.title)
								.foregroundColor(.white)
								.padding(10)
								.frame(minWidth: 0, maxWidth: 350)
								.background(Color.blue)
								.cornerRadius(10)
					}
							.padding([.vertical], 10)
				}
			}.padding(10)
		}
	}
}

struct JobPostDetailView_Previews: PreviewProvider
{
	static var previews: some View
	{
		let post = JobPost(
				title: "iOS Engineer with long long long long long long longlong long long long",
				description: "As an iOS Engineer, you will be responsible for designing and developing high-quality mobile applications for Apple's iOS platform. You will work closely with other engineers, designers, and product managers to create user-friendly, performant, and scalable applications that provide an excellent user experience.\n\nYour responsibilities will include:\n\nDeveloping and maintaining iOS applications using Swift, Objective-C, and other relevant technologies.\nCollaborating with cross-functional teams to identify and prioritize features, and to ensure that the product meets customer needs and requirements.\nWriting clean, reusable, and efficient code, and conducting code reviews to ensure quality and maintainability.\nImplementing new features, fixing bugs, and improving the performance of existing applications.\nStaying up-to-date with the latest iOS development trends and best practices, and sharing knowledge with the team.\nThe ideal candidate will have:\n\nAt least 3 years of experience in iOS development, with a strong understanding of Swift and Objective-C.\nExperience with iOS frameworks such as UIKit, Core Data, and Core Animation.\nFamiliarity with RESTful APIs, JSON, and networking concepts.\nKnowledge of software design patterns and architectural principles.\nStrong problem-solving and debugging skills.\nExcellent communication and collaboration skills, with the ability to work effectively in a team environment.",
				salary: 10000,
				location: "beijing, CN",
				companyId: 1
		)

		let company = Company(
				name: "Apple",
				address: "北京 中南海",
				description: "Apple Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services. It is considered one of the Big Five companies in the U.S. information technology industry, along with Amazon, Google, Microsoft, and Facebook.",
				logoUrl: "apple_logo"
		)

		let data = JobPostDetailViewData()
		data.jobPost = post
		data.company = company
		data.fetchCoordinates()

		return JobPostDetailView(data: data)
	}
}

class JobPostDetailViewData: ObservableObject
{
	@Published var jobPost: JobPost = JobPost()
	@Published var company: Company = Company()
	@Published var longitude: Double = 0.0
	@Published var latitude: Double = 0.0

	func fetchCoordinates()
	{
		let geoCoder = CLGeocoder()
		geoCoder.geocodeAddressString(jobPost.location)
		{ placemarks, error in
			guard let placemarks = placemarks,
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
				.method(.GET)
				.onSuccess({ data, response, error in
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
				})
				.send()
	}
}
