//
//  JobPostEditView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/28/23.
//

import SwiftUI

struct JobPostEditView: View {

    @State var jobPost = JobPost()

    @State var isUpdate = false

    @State var alertMessage = ""
    @State var showingAlert = false

    init()
    {
        _jobPost = State(initialValue: JobPost(companyId: Globe.shared.company!.id, posterId: Globe.shared.user!.id))
        _isUpdate = State(initialValue: false)
    }

    init(jobPost: JobPost)
    {
        _jobPost = State(initialValue: jobPost)

        _isUpdate = State(initialValue: true)
    }

    var body: some View {
        ScrollView
        {
            VStack
            {
                VStack
                {
                    HStack
                    {
                        Text("Job Title")
                        Spacer()
                    }
                            .padding(.horizontal, 5)
                    TextField("Enter Name", text: $jobPost.title)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }.padding()

                VStack
                {
                    HStack
                    {
                        Text("Salary")
                        Spacer()
                    }
                            .padding(.horizontal, 5)
                    TextField("Enter Salary", value: $jobPost.salary, formatter: NumberFormatter())
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.numberPad)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }.padding()

                VStack
                {
                    HStack
                    {
                        Text("Location")
                        Spacer()
                    }
                            .padding(.horizontal, 5)
                    TextField("Enter Location", text: $jobPost.location)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.numberPad)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }.padding()

                VStack
                {
                    HStack
                    {
                        Text("Description")
                        Spacer()
                    }
                            .padding(.horizontal, 5)
                    TextField("Enter Location", text: $jobPost.description, axis: .vertical)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.numberPad)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }.padding()
            }

            if(isUpdate)
            {
                HStack(content: {
                    Button(action: onUpdate) {
                        Text("Update")
                                .padding()
                                .padding(.horizontal)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(10, antialiased: true)
                    }

                    Button(action: onDelete) {
                        Text("Delete")
                                .padding()
                                .padding(.horizontal)
                                .foregroundColor(Color.white)
                                .background(Color.red)
                                .cornerRadius(10, antialiased: true)
                    }
                })
            }
            else
            {
                Button(action: onCreate) {
                    Text("Create")
                            .padding()
                            .padding(.horizontal)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10, antialiased: true)
                }
            }
        }
                .alert($alertMessage.wrappedValue, isPresented: $showingAlert)
                {
                    Button("OK", role: .cancel)
                    {
                    }
                }
    }

    func onUpdate()
    {
        // jobPost.companyId = Globe.shared.company!.id

        ApiRequest()
                .subDomains(["jobpost","update"])
                .method(.post)
                .body(jobPost)
                .onSuccess
                { _, _, _ in

                    alertMessage = "Update Success"
                    showingAlert = true
                    MessageCenter.shared.post( "RefreshPostListView2")
                }
                .onBadResponse
                {
                    data, _, _ in

                   if let data = data
                   {
                       alertMessage = String(data: data, encoding: .utf8) ?? "Update Failed"
                   }
                   else
                   {
                       alertMessage = "Update Failed"
                   }

                    showingAlert = true

                }
                .send()
    }

    func onDelete()
    {
        // jobPost.companyId = Globe.shared.company!.id
        ApiRequest()
                .subDomains(["JobPost", "delete"])
                .method(.post)
                .body(jobPost)
                .onSuccess
                { _, _, _ in

                    alertMessage = "Delete Success"
                    showingAlert = true
                    MessageCenter.shared.post("RefreshPostListView2")
                }
                .onBadResponse
                {
                    data, _, _ in

                    if let data = data
                    {
                        alertMessage = String(data: data, encoding: .utf8) ?? "Update Failed"
                    }
                    else
                    {
                        alertMessage = "Update Failed"
                    }

                    showingAlert = true
//                    MessageCenter.shared.post("RefreshPostListView2")
                }
                .send()
    }

    func onCreate()
    {
        jobPost.companyId = Globe.shared.company!.id
        ApiRequest()
                .subDomains(["jobpost","create"])
                .method(.post)
                .body(jobPost)
                .onSuccess
                { _, _, _ in

                    alertMessage = "Create Success"
                    showingAlert = true
                    MessageCenter.shared.post( "RefreshPostListView2")
                }
                .onBadResponse
                {
                    data, _, _ in

                    if let data = data
                    {
                        alertMessage = String(data: data, encoding: .utf8) ?? "Update Failed"
                    }
                    else
                    {
                        alertMessage = "Update Failed"
                    }

                    showingAlert = true
//                    MessageCenter.shared.post("RefreshPostListView2")
                }
                .send()
    }
}

struct JobPostEditView_Previews: PreviewProvider {
    static var previews: some View {
        JobPostEditView()
    }
}
