//
//  SeekerListViewItem.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct SeekerListViewItem: View
{

	@ObservedObject var data: SeekerData

	var body: some View
	{

		NavigationLink(destination: SeekerDetailView(data: data))
		{
			VStack(spacing: 0)
			{
				HStack
				{
					Spacer()
					Image(data.person.imageUrl)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 80, height: 80)
							.foregroundColor(Color.blue)
							.background(.green)
							.cornerRadius(40)
							.padding()
					Spacer()
				}
				Text("\(data.person.firstName) \(data.person.lastName)")
						.font(.title2)
						.lineLimit(2)
						.padding([.horizontal])
						.frame(height: 50)
				Text("\(data.seeker.major)")
						.font(.footnote)
						.lineLimit(1)
						.padding(.bottom, 10)
			}
					.background(UIColor.systemGray6.toSwiftUIColor())
					.frame(width: .infinity)
					.cornerRadius(10)
		}
				.foregroundColor(.primary)
	}
}

struct SeekerListViewItem_Previews: PreviewProvider
{
	static var previews: some View
	{
		let data = SeekerData()
//        Globe.shared.user = User(id: 1, email: "email", password: "password", type: "type")
		data.seeker = JobSeeker(userId: 1, personId: 1, school: "school", major: "Physics", degree: "GGG")
		data.person = Person(id: 1, userId: 1, firstName: "Bohan", lastName: "Zhang", imageUrl: "Ellipse 22")
		return SeekerListViewItem(data: data)
	}
}

class SeekerData: ObservableObject, Identifiable
{
	@Published var seeker: JobSeeker = JobSeeker()
	@Published var person: Person = Person()
}
