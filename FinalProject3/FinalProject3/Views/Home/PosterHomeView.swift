//
//  PosterHomw.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/26/23.
//

import SwiftUI

struct PosterHomeView: View {
    @State var showSearchView: Bool = false
    var body: some View {

        VStack(spacing: 0)
        {
            ScrollView
            {
                Button(action: {
                    showSearchView = true
                    BDebug("showSearchView = \(showSearchView)")
                })
                {
                    FakeSearchBar(placeHolder: "Search for Job Seekers")
                }

                SeekerListView()
            }
            NavigationLink(destination: SeekerSearchView(), isActive: $showSearchView)
            {
                EmptyView()
            }
        }

    }
}

struct PosterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PosterHomeView()
    }
}
