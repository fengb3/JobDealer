//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import SwiftUI

struct LoginView: View
{
	@State var username: String = ""
	@State var password: String = ""

	@State var isLogin: Bool = false
	@State var isRegister: Bool = false

	@State var isAlert: Bool = false
	@State var alertMessage: String = ""

	var mainView: MainView? = MainView(globe: Globe.shared)

	var body: some View
	{
		NavigationView
		{
			VStack
			{
				// MARK: - User Name
				VStack
				{
					Text("User Name")
							.padding()
							.font(.title)
					TextField("Enter User Name", text: $username)
							.padding()
							.background(UIColor.systemFill.toSwiftUIColor())
							.foregroundColor(Color.primary)
							.cornerRadius(10, antialiased: true)
							.keyboardType(.default)
							.disableAutocorrection(true)
							.autocapitalization(.none)
				}

				// MARK: - Password
				VStack
				{
					Text("Password")
							.padding()
							.font(.title)
					SecureField("Enter Password", text: $password)
							.padding()
							.background(UIColor.systemFill.toSwiftUIColor())
							.foregroundColor(Color.primary)
							.cornerRadius(10, antialiased: true)
							.keyboardType(.default)
							.disableAutocorrection(true)
							.autocapitalization(.none)
							.textContentType(.password)
				}

				// MARK: - Login & Register Buttons
				HStack
				{
					Button(action: onLogin)
					{
						Text("Login")
								.padding(10)
								.padding([.horizontal])
								.background(.blue)
								.cornerRadius(10)
								.foregroundColor(.white)
								.frame(width: 120)
					}
//							.padding()
					Spacer()
					Button(action: onRegister)
					{
						Text("Register")
								.padding(10)
								.padding([.horizontal])
								.background(.blue)
								.cornerRadius(10)
								.foregroundColor(.white)
								.frame(width: 120)
					}
				}
						.padding(50)


				NavigationLink(destination: mainView, isActive: $isLogin)
				{
					EmptyView()
				}

				NavigationLink(destination: RegisterView(), isActive: $isRegister)
				{
					EmptyView()
				}
			}
					.padding()
		}
				.navigationTitle("Login")
				.alert(isPresented: $isAlert)
				{
					Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
				}
	}

	func onLogin()
	{
		BDebug("Login \(username) \(password)")
		ApiRequest()
				.subDomains(["user","login"])
				.method(.post)
				.body(["userName": username, "password": password])
				.onSuccess
				{
					(data, response, error) in
					BDebug("Login Success")

					let user = try? JSONDecoder().decode(User.self, from: data!)
					BDebug("User: \(user!.userName) - \(user!.typeMask)")

					Globe.shared.user = user

					isLogin = true
					// self.mainView?.updateTabs()
					SignalRService.shared.connectToChatServer()
				}
				.onBadResponse
				{
					data, _, _ in

					BDebug("Login Bad Response")

					guard let data else { return }

					let message = try? String(data: data, encoding: .utf8)

					guard let message else { return }

					isAlert = true
					alertMessage = message

//					var message : String = ""
//					if let data = data
//					{
//						message = try String(data: data, encoding: .utf8)!
//					}
//					else
//					{
//						message = "Unknown Error"
//					}
//
//					isAlert = true
//					alertMessage = message
				}
				.send()
	}

	func onRegister()
	{
		isRegister = true
	}
}

struct LoginView_Previews: PreviewProvider
{
	static var previews: some View
	{
		LoginView()
	}
}
