//
// Created by Bohan Feng on 4/27/23.
//

import Foundation
import SwiftUI

struct JobPostHorizontalListView : View
{
	var globe: Globe = Globe.shared

	@State var datas: [JobPostDetailViewData] = []

	var body: some  View
	{
		VStack
		{
			if(datas.count != 0)
			{
				HStack
				{
					Text("Recently Viewed")
							.font(.title)
					Spacer()
				}
						.padding([.horizontal])
				ScrollView(.horizontal)
				{
					HStack()
					{
						ForEach(datas)
						{
							data in
//						NavigationLink(destination: JobPostDetailView(data: data))
//						{
							JobPostHorizontalViewItem(data: data)
//						}
//								.foregroundColor(.primary)
						}
					}
							.frame(height: 250)

				}
						.background(UIColor.systemGray6.toSwiftUIColor())
			}
		}
				.onAppear
				{
					fetchDatas()
					BDebug("JobPostsHorizontalListView onAppear")
				}


	}

	func fetchDatas()
	{
		BDebug("fetchDatas user view history")
		ApiRequest()
				.subDomains(["jobPost", "getViewHistory", "\(Globe.shared.user!.id)"])
				.method(.get)
				.onSuccess
				{
					(data, response, error) in

					let jobs = try! JSONDecoder().decode([JobPost].self, from: data!)
					BDebug("GetViewHistory success with jobs (\(jobs.count)): \(jobs)")

					self.datas = jobs.map
					                 {
						                 job in
						                 let data = JobPostDetailViewData()
						                 data.jobPost = job
						                 return data
					                 }
				}
				.send()
	}
}

struct JobPostHorizontalListView_Previews: PreviewProvider {
	static var previews: some View {
		Globe.shared.user = User(id: 1, userName: "Bohan", password: "123", typeMask: 1)
		return JobPostHorizontalListView()
	}
}