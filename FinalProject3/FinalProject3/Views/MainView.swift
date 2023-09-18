//
//  MainView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/26/23.
//

import SwiftUI

struct Tab: Identifiable, Hashable
{
	var id: Int
	var title: String
	var content: AnyView
	var icon: String = ""

	private static var count: Int = 0;

	init(title: String, content: AnyView, icon: String = "")
	{
		Tab.count += 1
		id = Tab.count
		self.title = title
		self.content = content
		self.icon = icon
	}

	func hash(into hasher: inout Hasher)
	{
		hasher.combine(id)
	}

	static func ==(lhs: Tab, rhs: Tab) -> Bool
	{
		lhs.id == rhs.id
	}
}

class ObservedTabs: ObservableObject
{
	@Published var tabs: [Tab] = []
}

struct MainView: View
{

	@ObservedObject var globe: Globe
	@ObservedObject var obTabs: ObservedTabs = ObservedTabs()

	@Environment(\.presentationMode) var presentationMode
	@Environment(\.dismiss) var dismiss

	@State private var selectedTab = 0

	init(globe: Globe)
	{
		self.globe = globe

		globe.mainView = self

		UINavigationBar.appearance().barTintColor = UIColor.systemBackground
		UITabBar.appearance().barTintColor = UIColor.systemBackground
		UITabBar.appearance().tintColor = UIColor.systemBlue
	}

	var body: some View
	{
		TabView(selection: $selectedTab)
		{
			ForEach(obTabs.tabs)
			{ tabItem in
				tabItem.content
				       .tabItem
				       {
					       Image(systemName: tabItem.icon)
					       Text(tabItem.title)
				       }
				       .tag(tabItem.id)

			}
		}
				.navigationBarBackButtonHidden()
				.onAppear(perform: updateTabs)

	}

	func updateTabs()
	{
		BDebug("updateTabs")
		obTabs.tabs.removeAll()

		if globe.user!.typeMask & 8 > 0
		{
			obTabs.tabs.append(Tab(title: "Explore", content: AnyView(SeekerHomeView()), icon: "magnifyingglass"))
		}

		if(globe.user!.typeMask & 16 > 0)
		{
			fetchPosterDatas()
			obTabs.tabs.append(Tab(title: "Explore", content: AnyView(PosterHomeView()), icon: "person.2.fill"))
			obTabs.tabs.append(Tab(title: "Job Posts", content: AnyView(JobPostManageView()), icon: "doc.text"))
		}

		obTabs.tabs.append(Tab(title: "Contact", content: AnyView(ContactView()), icon: "bubble.right.fill"))
		obTabs.tabs.append(Tab(title: "Profile", content: AnyView(ProfileView()), icon: "person.fill"))

	}

	func fetchPosterDatas()
	{
		BDebug("fetchPosterDatas")
//		ApiRequest()
//				.subDomains(["jobpost","getByPoster", "\(globe.user!.id)"])
//				.method(.get)
//				.onSuccess
//				{
//					(data, response, error) in
//
//					let jobs = try! JSONDecoder().decode([JobPost].self, from: data!)
//				}
//				.send()

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

								BDebug("Fetch company success on login: \(jsonCompany!)")
							}
						}
					}
				})
				.send()
	}
}

struct MainView_Previews: PreviewProvider
{
	static var previews: some View
	{
		Globe.shared.user = User(typeMask: 24)

		return MainView(globe: Globe.shared)
	}
}
