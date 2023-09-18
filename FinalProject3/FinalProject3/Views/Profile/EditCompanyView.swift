//
//  EditCompanyView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct EditCompanyView: View {

    @ObservedObject var globe = Globe.shared

    @State var company: Company

    @State var showingImagePicker = false

    @State var alertMessage = ""
    @State var showingAlert = false

    init()
    {
        _company = State(initialValue: Globe.shared.company!)

    }

    var body: some View {
        ScrollView
        {
            VStack
            {
                VStack
                {
                    HStack{
                        Text("Name")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter Name", text: $company.name)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }
                        .padding()

                VStack
                {
                    HStack{
                        Text("Enter Address")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Address", text: $company.address)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                }
                        .padding()

                VStack
                {
                    HStack{
                        Text("Description")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                    TextField("Enter Description", text: $company.description, axis: .vertical)
                            .padding()
                            .background(UIColor.systemFill.toSwiftUIColor())
                            .foregroundColor(Color.primary)
                            .cornerRadius(10, antialiased: true)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .lineLimit(10)
                }
                        .padding()

                VStack
                {
                    HStack
                    {
                        Text("Logo")
                        Spacer()
                    }
                            .padding(.horizontal,5)
                   HStack
                   {
                       Image(company.logoUrl)
                               .resizable()
                               .frame(width: 100, height: 100)
                               .background(Color.red)
                               .clipShape(Circle())
                       Spacer()
                       Button(action:{showingImagePicker = true})
                       {
                           Text("Upload")
                                   .padding()
                                   .padding(.horizontal)
                                   .foregroundColor(Color.white)
                                   .background(Color.blue)
                                   .cornerRadius(10, antialiased: true)
                       }
                               .sheet(isPresented: $showingImagePicker)
                               {
                                    DocumentPicker{ url in
                                        let fileName = url.lastPathComponent
                                        let fileExtension = url.pathExtension

                                        let nameWithoutExtension = fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")

                                        company.logoUrl = "\(nameWithoutExtension)"
                                    }
                               }
                   }
                }
                        .padding()
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
        BDebug(company)
        BDebug(Globe.shared.company!)

        ApiRequest()
                .subDomains(["company", "update"])
                .method(.post)
                .body(company)
                .onSuccess
                {
                    data, _, _ in

                    if let data = data
                    {
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                        let temp = try? JSONDecoder().decode(Company.self, from: data)

                        Globe.shared.company = temp

                        self.alertMessage = "Update Company Success"
                        self.showingAlert = true
                    }
                }
                .onBadResponse
                { data, response, error in

                    self.alertMessage = String(data: data!, encoding: .utf8) ?? "Update Company Failed"
                    self.showingAlert = true
                }
                .send()
    }
}

struct EditCompanyView_Previews: PreviewProvider {
    static var previews: some View {
        var comp = Company()
        comp.name = "Apple"
        comp.address = "1 Infinite Loop, Cupertino, CA 95014"
        comp.description = "Apple Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services."
        comp.logoUrl = "CloudWatch"

        Globe.shared.company = comp

        return EditCompanyView()
    }
}
