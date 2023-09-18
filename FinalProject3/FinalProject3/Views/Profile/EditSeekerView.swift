//
//  EditSeekerView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct EditSeekerView: View {

    @ObservedObject var globe = Globe.shared
    @State var jobSeeker: JobSeeker

    @State var showingImagePicker = false

    @State var alertMessage = ""
    @State var showingAlert = false

    init()
    {
        _jobSeeker = State(initialValue: Globe.shared.jobSeeker!)
    }

    var body: some View {
        ScrollView
        {
            VStack
            {
                VStack
                {
                    HStack{
                        Text("School")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter School", text: $jobSeeker.school)
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
                    HStack{
                        Text("Major")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter major", text: $jobSeeker.major)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }.padding()

                // degree
                VStack
                {
                    HStack{
                        Text("Degree")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter degree", text: $jobSeeker.degree)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }.padding()

                // graduation year
                VStack
                {
                    HStack{
                        Text("Graduate At")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter School", value: $jobSeeker.graduationYear, formatter: NumberFormatter())
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
                    HStack{
                        Text("Experience")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter Experience", text: $jobSeeker.experience, axis: .vertical)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .lineLimit(10)
                }.padding()

                VStack
                {
                    HStack{
                        Text("Skills")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter Skills", text: $jobSeeker.skills, axis: .vertical)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .lineLimit(10)
                }.padding()

                VStack
                {
                    HStack{
                        Text("Description")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter Description", text: $jobSeeker.description, axis: .vertical)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .lineLimit(10)
                }.padding()
            }
            Button(action: onSave)
            {
                Text("Save")
                        .padding()
                        .padding(.horizontal)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10, antialiased: true)
            }

        }
                .alert($alertMessage.wrappedValue, isPresented: $showingAlert)
                {
                    Button("OK", role: .cancel)
                    {
                    }
                }
    }

    func onSave()
    {
        BInfo("Update Job Seeker")
        ApiRequest()
                .subDomains(["jobSeeker", "update"])
                .method(.post)
                .body(jobSeeker)
                .onSuccess
                {
                    data, _, _ in
                    BInfo("Update Job Seeker Success")

                    if let data = data
                    {
                        if let jobSeeker = try? JSONDecoder().decode(JobSeeker.self, from: data)
                        {
                            Globe.shared.jobSeeker = jobSeeker
                        }
                    }

                    alertMessage = "Update Resume Information Success"
                    showingAlert = true
                }
                .onBadResponse
                {
                    data, _, _ in
                    BError("Update Job Seeker Failed")
                    if let data = data
                    {
                        if let message = String(data: data, encoding: .utf8)
                        {
                            alertMessage = message
                            showingAlert = true
                        }
                    }
                }
                .send()

    }
}

struct EditSeekerView_Previews: PreviewProvider {
    static var previews: some View {
        EditSeekerView()
    }
}
