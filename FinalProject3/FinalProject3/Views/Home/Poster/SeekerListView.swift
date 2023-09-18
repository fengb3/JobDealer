//
//  SeekerListView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct SeekerListView: View
{
	@State var datas: [SeekerData] = []

	// private var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)

	var body: some View
	{
		VStack
		{
			HStack
			{
				Text("Job Seekers")
						.font(.title)
				Spacer()
			}

			LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20)
			{
				ForEach(datas)
				{
					data in
//                        NavigationLink(destination: SeekerDetailView(data: data))
//                        {
					SeekerListViewItem(data: data)
//                        }
//                                .foregroundColor(.primary)
				}
			}
		}
				.padding()
				.onAppear
				{
					fetchDatas()
				}
	}

	func fetchDatas()
	{
		BDebug("fetchDatas seekers")
		ApiRequest()
				.subDomains(["JobSeeker", "getAll"])
				.method(.get)
				.onSuccess
				{
					data, response, error in
					if let data = data
					{
						let json = try? JSONSerialization.jsonObject(with: data, options: [])

						if let list = json as? [Any]
						{
							var temp = [SeekerData]()
							for each in list
							{
								if let dict = each as? [String: Any]
								{
									let jsonSeeker = try? JSONSerialization.data(withJSONObject: dict["seeker"] as Any, options: [])
									let jsonPerson = try? JSONSerialization.data(withJSONObject: dict["person"] as Any, options: [])
									let seeker = try? JSONDecoder().decode(JobSeeker.self, from: jsonSeeker!)
									let person = try? JSONDecoder().decode(Person.self, from: jsonPerson!)

									let data = SeekerData()

									guard let seeker else
									{
										BError("seeker is nil")
										continue
									}
									guard let person else
									{
										BError("person is nil")
										continue
									}

									data.seeker = seeker
									data.person = person

									BDebug("seeker: \(seeker) - person: \(person)")

									temp.append(data)
								}
							}
							datas = temp
						}
					}
				}
				.send()
	}
}

struct SeekerListView_Previews: PreviewProvider
{
	static var previews: some View
	{
		SeekerListView()
	}
}
