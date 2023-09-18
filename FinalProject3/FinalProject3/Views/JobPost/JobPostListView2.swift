//
//  JobPostListView2.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/28/23.
//

import SwiftUI

struct JobPostListView2: View {

    @ObservedObject var globe = Globe.shared

    @State var datas: [JobPostDetailViewData] = []

    var body: some View {

            VStack
            {
                if(datas.count == 0)
                {
                    Text("No Job Posts")
                }
                else
                {
                    ForEach(datas)
                    {
                        data in
                        JobPostListViewItem2(data: data)
                    }
                }
            }.onAppear(perform: fetchDatas)
             .onViewDidLoad
             {
                 MessageCenter.shared.register("RefreshPostListView2")
                 {
                     _ in
                     self.fetchDatas()
                 }
             }
    }

    func fetchDatas()
    {
        BDebug("fetchDatas")
        datas = []
        ApiRequest()
                .subDomains(["jobpost","getByPoster", "\(globe.user!.id)"])
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

struct JobPostListView2_Previews: PreviewProvider {
    static var previews: some View {

        Globe.shared.user = User(id:2)

        return JobPostListView2()
    }
}
