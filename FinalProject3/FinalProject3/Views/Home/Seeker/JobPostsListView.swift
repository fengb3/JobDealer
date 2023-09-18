//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import SwiftUI

struct JobPostsListView :View
{
	var globe: Globe = Globe.shared

	@State var datas: [JobPostDetailViewData] = []

	var body: some View
	{
		VStack
		{
			HStack
			{
				Text("Recommend")
						.font(.title)
				Spacer()
			}
					.padding([.horizontal])
//			ScrollView
//			{
				VStack
				{
					ForEach(datas)
					{
						data in
//						NavigationLink(destination: JobPostDetailView(data: data))
//						{
							JobPostListViewItem(data: data)
//						}
//								.foregroundColor(.primary)
					}
				}
						.padding(10)
//			}
		}
				.navigationBarTitle("Job Posts List")
				.onAppear
				{
					fetchDatas()
					BDebug("JobPostsListView onAppear")
				}

	}

	func fetchDatas()
	{
		ApiRequest()
				.subDomains(["jobPost", "GetRecommend", "\(Globe.shared.user!.id)"])
				.method(.get)
				.onSuccess
				{
					(data, response, error) in

					let jobs = try! JSONDecoder().decode([JobPost].self, from: data!)
//					BDebug(jobs)

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

struct JobPostsListView_Previews: PreviewProvider
{
	static var previews: some View
	{
		Globe.shared.user = User(id: 1, userName: "Bohan", password: "123", typeMask: 1)
		return JobPostsListView()
	}
}