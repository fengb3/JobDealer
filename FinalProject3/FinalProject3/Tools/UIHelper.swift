//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import SwiftUI

extension UIColor
{
	func toSwiftUIColor() -> Color
	{
		return Color(self)
	}
}

struct ViewDidLoadModifier: ViewModifier {
	@State private var viewDidLoad = false
	let action: (() -> Void)?

	func body(content: Content) -> some View {
		content
				.onAppear {
					if viewDidLoad == false {
						viewDidLoad = true
						action?()
					}
				}
	}
}

extension View {
	func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
		self.modifier(ViewDidLoadModifier(action: action))
	}

//	func alert(isPresented: Binding<Bool>, _ message: String) -> some View {
//		self.alert(isPresented: isPresented) {
//			Alert(title: Text(message))
//		}
//	}
}