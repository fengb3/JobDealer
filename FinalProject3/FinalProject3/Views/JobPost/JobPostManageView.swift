//
//  JobPostManageView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/28/23.
//

import SwiftUI

struct JobPostManageView: View {

    @State var isAdding = false

    var body: some View {

        VStack
        {
            ScrollView
            {

                VStack
                {
                    JobPostListView2()
                }
                        .padding([.top, .horizontal])

                Button(action: onAddJobPost)
                {
                    HStack
                    {
                        Spacer()
                        Image(systemName: "plus")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        Spacer()
                    }
                            .padding()
                            .background(UIColor.systemGray4.toSwiftUIColor())
                            .cornerRadius(10)
                }
                        .padding([.horizontal])


            }
                    .sheet(isPresented: $isAdding)
                    {
                        JobPostEditView()
                    }
        }

    }

    func onAddJobPost()
    {
        BDebug("onAddJobPost")
        isAdding = true
    }
}

struct JobPostManageView_Previews: PreviewProvider {
    static var previews: some View {
        Globe.shared.user = User(id:2)
        return JobPostManageView()
    }
}
