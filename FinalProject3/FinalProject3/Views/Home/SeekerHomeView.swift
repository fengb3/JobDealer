//
//  SeekerHomeView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/26/23.
//

import SwiftUI

struct SeekerHomeView: View {
    @State var showSearchView: Bool = false
    var body: some View {
        ScrollView {
            VStack
            {
                Button(action: {
                    showSearchView = true
                    BDebug("showSearchView = \(showSearchView)")
                })
                {
                    FakeSearchBar(placeHolder: "Search for Job Seekers")
                }
            }
            JobPostHorizontalListView()
            JobPostsListView()
            NavigationLink(destination: JobPostSearchView(), isActive: $showSearchView)
            {
                EmptyView()
            }
        }

    }
}

struct SeekerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        Globe.shared.user = User(id: 1, userName: "Bohan", password: "123", typeMask: 1)
        return SeekerHomeView()
    }
}
