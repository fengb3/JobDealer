//
//  RegisterView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/28/23.
//

import SwiftUI

struct RegisterView: View {

    @State var user: User = User()
    @State var person: Person = Person()

    @State var options = ["Looking for Jobs", "Posting Jobs"] // 1
    @State var selectedItem = "Looking for Jobs" // 2

    @State var showingImagePicker = false

    @State var alertMessage = ""
    @State var showingAlert = false
    @State var alertTitle = ""

    @State var isRegisterSuccess = false
    
    var mainView: MainView? = MainView(globe: Globe.shared)

    var body: some View {
        ScrollView
        {
            VStack
            {
                VStack
                {
                    VStack
                    {
                        HStack{
                            Text("User Name")
                            Spacer()
                        }
                                .padding(.horizontal,5)
                        TextField("Enter Name", text: $user.userName)
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
                            Text("Password")
                            Spacer()
                        }
                                .padding(.horizontal,5)
                        SecureField("Enter Password", text: $user.password)
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
                            Text("You are :")
                            Spacer()
                        }
                        Picker("Choose your role", selection: $selectedItem)
    //                    Picker("Choose your role", selection: $selectedItem)
                        {
                            ForEach(options, id: \.self)
                            {
                                Text($0)
                            }
                        }
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
                            Text("First Name")
                            Spacer()
                        }
                                .padding(.horizontal,5)
                        TextField("Enter First Name", text: $person.firstName)
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
                            Text("Last Name")
                            Spacer()
                        }
                                .padding(.horizontal,5)
                        TextField("Enter Last Name", text: $person.lastName)
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
                            Text("Email")
                            Spacer()
                        }
                                .padding(.horizontal,5)
                        TextField("Enter Email", text: $person.email)
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
                            Text("Phone Number")
                            Spacer()
                        }
                                .padding(.horizontal,5)
                        TextField("Enter Phone Number", text: $person.phone)
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
                            Text("Address")
                            Spacer()
                        }
                                .padding(.horizontal,5)
                        TextField("Enter Address", text: $person.location)
                                .padding()
                                .background(UIColor.systemFill.toSwiftUIColor())
                                .foregroundColor(Color.primary)
                                .cornerRadius(10, antialiased: true)
                                .keyboardType(.default)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                    }.padding()

                    HStack
                    {
                        Image(person.imageUrl)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .background(Color.red)
                                .clipShape(Circle())
                        Spacer()
                        Button(action: { showingImagePicker = true })
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
                                    DocumentPicker
                                    { url in
                                        let fileName = url.lastPathComponent
                                        let fileExtension = url.pathExtension
                                        let nameWithoutExtension = fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")

                                        person.imageUrl = "\(nameWithoutExtension)"
                                    }
                                }
                    }
                            .padding()

                }

                Button(action: onRegister)
                {
                    Text("Register")
                            .padding()
                            .padding(.horizontal)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10, antialiased: true)
                }
            }
            NavigationLink(destination: mainView, isActive: $isRegisterSuccess)
            {
                EmptyView()
            }
        }
                .alert($alertTitle.wrappedValue, isPresented: $showingAlert)
                {
                    // Text($alertMessage.wrappedValue)
                    Button("OK", role: .cancel)
                    {
                    }
                }
        
        
    }

    struct UserAndPerson: Codable
    {
        var user: User
        var person: Person
    }

    func onRegister()
    {

        BDebug("\(selectedItem)")


        if(selectedItem == "Looking for a job")
        {
            user.typeMask = 8
        }
        else
        {
            user.typeMask = 16
        }

        let userAndPerson = UserAndPerson(user: user, person: person)

        ApiRequest()
                .subDomains(["user","register"])
                .method(.post)
                .body(userAndPerson)
                .onSuccess
                {
                    data, _, _ in

                    if let data = data
                    {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])

                        if let dictionary = json as? [String: Any]
                        {
                            if let userDict = dictionary["user"] as? [String: Any]
                            {
                                let jsonUser = try? JSONSerialization.data(withJSONObject: userDict, options: [])
                                Globe.shared.user = try? JSONDecoder().decode(User.self, from: jsonUser!)
                                BDebug("fetch user: \(Globe.shared.user)")
                            }

                            if let personDict = dictionary["person"] as? [String: Any]
                            {
                                let jsonPerson = try? JSONSerialization.data(withJSONObject: personDict, options: [])
                                Globe.shared.person = try? JSONDecoder().decode(Person.self, from: jsonPerson!)
                                BDebug("fetch person: \(Globe.shared.person)")
                            }
                        }

//                        alertTitle = "Success"
//                        alertMessage = "You have successfully registered"
//                        showingAlert = true
                        isRegisterSuccess = true
                    }
                }
                .onBadResponse
                {
                    data, _, _ in

                    guard let data else { return }

                    let message = String(data: data, encoding: .utf8)

                    alertTitle = "Failed\n\(message ?? "Unknown error")"
                    alertMessage = message ?? "Unknown error"
                    showingAlert = true
                }
                .send()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
