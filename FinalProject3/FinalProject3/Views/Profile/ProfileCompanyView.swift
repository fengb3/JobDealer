//
//  ProfileCompanyView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct ProfileCompanyView: View
{
    @ObservedObject var globe = Globe.shared

	@State var isEditing = false

	var body: some View
	{
		VStack
		{
			HStack
			{
				Text("Company Information")
						.font(.title2)
						.bold()
				Spacer()
				Button(action: onEdit)
				{
					Text("Edit")
							.padding()
							.cornerRadius(10, antialiased: true)
				}
			}
			HStack
			{
				Image(globe.company?.logoUrl ?? "Ellipse 57")
						.resizable()
						.frame(width: 80, height: 80)
						//						.padding()
						.background(.red)
						.cornerRadius(75, antialiased: true)
				VStack
				{
					Text("\(globe.company?.name ?? "Company Name")")
							.font(.title2)
				}
						.padding()
				Spacer()
			}
			HStack
			{
				Image(systemName: "building.2.crop.circle")
				Text("\(globe.company?.name ?? "Company Name")")
						.font(.title3)
						.lineLimit(1)
				Spacer()
			}
			HStack
			{
				Image(systemName: "location.circle")
				Text("\(globe.company?.address ?? "Address")")
						.font(.title3)
						.lineLimit(1)
				Spacer()
			}
			HStack
			{
				Image(systemName: "person.circle")
				Text("\(globe.company?.description ?? "Description")")
						.font(.title3)
						.lineLimit(1)
				Spacer()
			}
		}
				.padding()
				.background(UIColor.systemGray6.toSwiftUIColor())
				.onAppear(perform: fetchCompany)
				.cornerRadius(15)
				.sheet(isPresented: $isEditing){
					EditCompanyView()
				}
	}

	func fetchCompany()
	{
		ApiRequest()
				.subDomains(["JobPoster", "Profile", "\(Globe.shared.user!.id)"])
				.method(.get)
				.onSuccess({ data, response, error in
					if let data = data
					{
						let json = try? JSONSerialization.jsonObject(with: data, options: [])

						if let dictionary = json as? [String: Any]
						{
							if let companyDict = dictionary["company"] as? [String: Any]
							{
								let jsonCompany = try? JSONSerialization.data(withJSONObject: companyDict, options: [.prettyPrinted])
								let company = try? JSONDecoder().decode(Company.self, from: jsonCompany!)
								Globe.shared.company = company

                                BDebug(jsonCompany!)
							}
						}
					}
				})
				.send()
	}

	func onEdit()
	{
		BInfo("open edit company view")
		isEditing = true
	}
}

struct ProfileCompanyView_Previews: PreviewProvider
{
	static var previews: some View
	{
		Globe.shared.user = User(id: 1, userName: "bohan", typeMask: 24)

		return ProfileCompanyView()
	}
}
