//
//  EditPersonView.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct EditPersonView: View
{

	@ObservedObject var globe = Globe.shared

	@State var person: Person

	@State var showingImagePicker = false

	@State var alertMessage = ""
	@State var showingAlert = false

	init()
	{
		_person = State(initialValue: Globe.shared.person!)
	}

	var body: some View
	{
		ScrollView
		{
			VStack
			{
				VStack
				{
					HStack
					{
						Text("First Name")
						Spacer()
					}
							.padding()
					TextField("Enter Name", text: $person.firstName)
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
					HStack
					{
						Text("Last Name")
						Spacer()
					}
							.padding()
					TextField("Enter Name", text: $person.lastName)
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
					HStack
					{
						Text("Email")
						Spacer()
					}
							.padding()
					TextField("Enter email", text: $person.email)
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
					HStack
					{
						Text("Phone Number")
						Spacer()
					}
							.padding()
					TextField("Enter Phone Number", text: $person.phone)
							.padding()
							.background(UIColor.systemFill.toSwiftUIColor())
							.foregroundColor(Color.primary)
							.cornerRadius(10, antialiased: true)
							.keyboardType(.numberPad)
							.disableAutocorrection(true)
							.autocapitalization(.none)

				}
						.padding()

				VStack
				{
					HStack
					{
						Text("Location")
						Spacer()
					}
							.padding()
					TextField("Enter Location", text: $person.location)
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
					HStack
					{
						Text("Logo")
						Spacer()
					}
							.padding()

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
		ApiRequest()
                .subDomains(["User", "update"])
                .method(.post)
                .body(person)
                .onSuccess
                {
                    data, _, _ in
                    if let data = data
                    {
                        if let person = try? JSONDecoder().decode(Person.self, from: data)
                        {
                            Globe.shared.person = person

                            alertMessage = "Update personal information success"
                            showingAlert = true
                        }
                    }
                }
                .onBadResponse
                {
                    data, _, _ in
                    if let data = data
                    {
                        if let error = String(data: data, encoding: .utf8)
                        {
                            alertMessage = error
                            showingAlert = true
                        }
                    }
                }
                .send()
	}

}

struct EditPersonView_Previews: PreviewProvider
{
	static var previews: some View
	{
		EditPersonView()
	}
}
