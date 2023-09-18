//
//  JobPostSearchView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct JobPostSearchView: View {

    var globe: Globe = Globe.shared
    @State var datas: [JobPostDetailViewData] = []

    @State var searchText: String = ""
    @State var placeHolder: String = "Search by Title and Description"

    var body: some View {
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
                                searchJobPost()
                            }
                }
                        .frame(width: .infinity, height: 60)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                        .padding()

                LazyVStack
                {
                    if(datas.count == 0)
                    {
                        Text("No Result")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .padding()
                    }
                    ForEach(datas)
                    {
                        data in
                        JobPostListViewItem(data: data)
                    }
                }
                        .padding()
            }
        }
                .navigationBarTitle("")
    }

    func searchJobPost()
    {
        ApiRequest()
                .subDomains(["JobPost", "search"])
                .method(.post)
                .body(["keyword": searchText, "userId": Globe.shared.user!.id])
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

struct JobPostSearchView_Previews: PreviewProvider {
    static var previews: some View {
        Globe.shared.user = User(id: 1, userName: "Bohan", password: "123", typeMask: 1)
        return JobPostSearchView()
    }
}
