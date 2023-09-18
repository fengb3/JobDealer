//
//  ProfileSeekerView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct ProfileSeekerView: View
{

	@ObservedObject var globe = Globe.shared

	@State var isEditing = false

	var body: some View
	{
		VStack
        {
            HStack
            {
                Text("Resume Information")
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
                Image(systemName: "graduationcap.circle")
                Text("\(globe.jobSeeker?.school ?? "Education")")
                        .font(.title3)
                        .lineLimit(1)
                Spacer()
            }
            HStack
            {
                Image(systemName: "calendar.circle")
                Text("Graduate at \(globe.jobSeeker?.graduationYear ?? 1970)")
                        .font(.title3)
                        .lineLimit(1)
                Spacer()
            }
            HStack
            {
                Image(systemName: "book.circle")
                Text("\(globe.jobSeeker?.major ?? "Major")")
                        .font(.title3)
                        .lineLimit(1)
                Spacer()
            }
            HStack
            {
                Image(systemName: "person.circle")
                Text("\(globe.jobSeeker?.experience ?? "Experience")")
                        .font(.title3)
                        .lineLimit(1)
                Spacer()
            }
            HStack
            {
                Image(systemName: "hammer.circle")
                Text("\(globe.jobSeeker?.skills ?? "Skills")")
                        .font(.title3)
                        .lineLimit(1)
                Spacer()
            }
        }
                .padding()
                .background(UIColor.systemGray6.toSwiftUIColor())
                .cornerRadius(15)
				.onAppear(perform: fetchSeeker)
                .sheet(isPresented: $isEditing){
	                EditSeekerView()
                }
	}

    func onEdit()
    {
	    BInfo("open edit seeker view")
	    isEditing = true
    }

	func fetchSeeker()
	{
		ApiRequest()
				.method(.get)
				.subDomains(["JobSeeker", "profile", "\(Globe.shared.user!.id)"])
				.onSuccess
                { data, response, error in

                    if let data = data
                    {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])

                        if let dictionary = json as? [String: Any]
                        {
                            if let seekerDict = dictionary["seeker"] as? [String: Any]
                            {
                                let jsonSeeker = try? JSONSerialization.data(withJSONObject: seekerDict, options: [])
                                Globe.shared.jobSeeker = try? JSONDecoder().decode(JobSeeker.self, from: jsonSeeker!)
                                BDebug(Globe.shared.jobSeeker!)
                            }
                        }
                    }
                }
                .send()
	}
}

struct ProfileSeekerView_Previews: PreviewProvider
{
	static var previews: some View
	{
		Globe.shared.user = User(id: 1, userName: "bohan", password: "password")


		return ProfileSeekerView()
	}
}
