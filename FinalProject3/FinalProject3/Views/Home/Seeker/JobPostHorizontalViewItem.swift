//
// Created by Bohan Feng on 4/27/23.
//


import Foundation
import SwiftUI

//import _MapKit_SwiftUI

struct JobPostHorizontalViewItem: View
{

	@ObservedObject var data: JobPostDetailViewData

	var body: some View
	{
		NavigationLink(destination: JobPostDetailView(data: data))
		{
			VStack(spacing: 10)
			{
				HStack
				{
					Image(data.company.logoUrl)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 70, height: 70)
							.foregroundColor(Color.blue)
							.background(.green)
							.cornerRadius(35)
					Text(data.jobPost.title)
							.font(.title2)
							.lineLimit(2)
							.frame(height: 70)
					Spacer()

				}
						.padding()
				HStack
				{
					Image(systemName: "building.2.crop.circle")
					Text("\(data.company.name)")
							.font(.title3)
							.lineLimit(1)
					Spacer()
				}
						.padding([.horizontal])
				HStack
				{
					Image(systemName: "dollarsign.circle")
					Text("Salary: \(Int(data.jobPost.salary))")
							.font(.title3)
							.lineLimit(1)
					Spacer()
				}
						.padding([.horizontal])
				HStack
				{
					Image(systemName: "location.circle")
					Text("\(data.jobPost.location)")
							.font(.title3)
							.lineLimit(1)
					Spacer()
				}
						.padding([.horizontal, .bottom])
			}
					.background(UIColor.systemGray5.toSwiftUIColor())
					.cornerRadius(10)
					.padding(10)
					.frame(width: 350, height: 300)
					.onAppear
					{
						data.fetchCompany()
					}
		}.foregroundColor(.primary)

	}
}

struct JobPostHorizontalViewItem_Previews: PreviewProvider
{
	static var previews: some View
	{
		let post = JobPost(
				title: "iOS Engineer long long long",
				description: "As an iOS Engineer, you will be responsible for designing and developing high-quality mobile applications for Apple's iOS platform. You will work closely with other engineers, designers, and product managers to create user-friendly, performant, and scalable applications that provide an excellent user experience.\n\nYour responsibilities will include:\n\nDeveloping and maintaining iOS applications using Swift, Objective-C, and other relevant technologies.\nCollaborating with cross-functional teams to identify and prioritize features, and to ensure that the product meets customer needs and requirements.\nWriting clean, reusable, and efficient code, and conducting code reviews to ensure quality and maintainability.\nImplementing new features, fixing bugs, and improving the performance of existing applications.\nStaying up-to-date with the latest iOS development trends and best practices, and sharing knowledge with the team.\nThe ideal candidate will have:\n\nAt least 3 years of experience in iOS development, with a strong understanding of Swift and Objective-C.\nexperience with iOS frameworks such as UIKit, Core Data, and Core Animation.\nFamiliarity with RESTful APIs, JSON, and networking concepts.\nKnowledge of software design patterns and architectural principles.\nStrong problem-solving and debugging skills.\nExcellent communication and collaboration skills, with the ability to work effectively in a team environment.",
				salary: 10000,
				location: "beijing, CN",
				companyId: 1
		)

		let company = Company(
				name: "Apple",
				address: "北京 中南海",
				description: "Apple Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services. It is considered one of the Big Five companies in the U.S. information technology industry, along with Amazon, Google, Microsoft, and Facebook.",
				logoUrl: "Acme Group"
		)

		let data = JobPostDetailViewData()

		data.jobPost = post

		data.company = company

		return JobPostHorizontalViewItem(data: data)
	}
}