//
//  ProfileView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/26/23.
//

import SwiftUI

struct ProfileView: View
{
	@ObservedObject var globe = Globe.shared

	@Environment(\.presentationMode) var presentationMode
	@Environment(\.dismiss) var dismiss

	var body: some View
	{
		ScrollView
		{
			VStack
			{
				ProfilePersonView()

				if((globe.user!.typeMask & 8) > 0)
				{
					ProfileSeekerView()
				}

				if((globe.user!.typeMask & 16) > 0)
				{
					ProfileCompanyView()
				}

                Spacer()
				Button(action : {
                   dismiss()
                })
				{
					Text("Logout")
							.font(.title2)
							.foregroundColor(.red)
				}
						.padding()
			}
					.padding()
		}


//		Spacer()
	}

	func fetchPerson()
	{
		ApiRequest()
				.method(.get)
				.subDomains(["user", "profile", "\(Globe.shared.user!.id)"])
				.onSuccess
				{ data, response, error in

					if let data = data
					{
						let json = try? JSONSerialization.jsonObject(with: data, options: [])

						if let dictionary = json as? [String: Any]
						{
							if let personDict = dictionary["person"] as? [String: Any]
							{
								let jsonPerson = try? JSONSerialization.data(withJSONObject: personDict, options: [])
								Globe.shared.person = try? JSONDecoder().decode(Person.self, from: jsonPerson!)
								BDebug(Globe.shared.person!.firstName)
							}
						}
					}

				}
				.send()
	}

	func onEdit()
	{
		BDebug("Edit")
	}
}

struct ProfileView_Previews: PreviewProvider
{
	static var previews: some View
	{
		Globe.shared.user = User(id: 1, userName: "bohan", typeMask: 16)
		Globe.shared.person?.imageUrl = "Ellipse 59-1"
		return ProfileView()
	}
}
