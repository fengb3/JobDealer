//
//  ProfilePersonView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct ProfilePersonView: View
{

	@ObservedObject var globe = Globe.shared
	@State var isEditing = false

	var body: some View
	{
		VStack
		{
			HStack
			{
				Text("Personal Information")
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
				Image(globe.person?.imageUrl ?? "Ellipse 57")
						.resizable()
						.frame(width: 80, height: 80)
						//						.padding()
						.background(.red)
						.cornerRadius(75, antialiased: true)
				VStack
				{
					Text("\(globe.person?.firstName ?? "First Name") \(globe.person?.lastName ?? "Last Name")")
							.font(.title2)
				}
						.padding()
				Spacer()
			}
			HStack
			{
				Image(systemName: "location.circle")
				Text("\(globe.person?.location ?? "Location")")
						.font(.title3)
						.lineLimit(1)
				Spacer()
			}
			HStack
			{
				Image(systemName: "envelope.circle")
				Text("\(globe.person?.email ?? "Email")")
						.font(.title3)
						.lineLimit(1)
				Spacer()
			}
			HStack
			{
				Image(systemName: "phone.circle")
				Text("\(globe.person?.phone ?? "Phone")")
						.font(.title3)
						.lineLimit(1)
				Spacer()
			}

		}
				.padding()
				.background(UIColor.systemGray6.toSwiftUIColor())
                .onAppear(perform: fetchPerson)
				.cornerRadius(15)
				.sheet(isPresented: $isEditing){
					EditPersonView()
				}
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
        isEditing = true
    }
}

struct ProfilePersonView_Previews: PreviewProvider
{
	static var previews: some View
	{
        Globe.shared.user = User(id: 1, userName: "bohan", typeMask: 1)
        Globe.shared.person?.imageUrl = "Ellipse 59-1"
		return ProfilePersonView()
	}
}
