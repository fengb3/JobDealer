//
//  SeekerSearchView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct SeekerSearchView: View
{

	var globe: Globe = Globe.shared
	@State var datas: [SeekerData] = []

	@State var searchText: String = ""
	@State var placeHolder: String = "Search by Degree, Major, or Skills"

	var body: some View
	{
		VStack(spacing: 0)
		{
			ScrollView
			{
//                FakeSearchBar(placeHolder: "Search for Job Seekers")
				HStack
				{
					Image(systemName: "magnifyingglass")
							.foregroundColor(.gray)
							.padding(.leading, 8)
					TextField(placeHolder, text: $searchText)
							.foregroundColor(.gray)
							.font(.system(size: 20))
							.padding(.leading, 8)
							.onSubmit()
							{
								BDebug("searchText = \(searchText)")
								searchSeekers()
							}
				}
						.frame(width: .infinity, height: 60)
						.background(Color(.systemGray5))
						.cornerRadius(10)
						.padding()

				LazyVStack
				{
					if (datas.count == 0)
					{
						Text("No Result")
								.font(.title3)
								.foregroundColor(.gray)
								.padding()
					}
					LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20)
					{
						ForEach(datas)
						{
							data in
							SeekerListViewItem(data: data)
						}
					}
				}
						.padding()
			}
		}
				.navigationBarTitle("")
	}

	func searchSeekers()
	{
        BDebug("searchSeekers()")
		ApiRequest()
				.subDomains(["JobSeeker", "search"])
                .body(["keyword": searchText])
				.method(.post)
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

struct SeekerSearchView_Previews: PreviewProvider
{
	static var previews: some View
	{
		SeekerSearchView()
	}
}
