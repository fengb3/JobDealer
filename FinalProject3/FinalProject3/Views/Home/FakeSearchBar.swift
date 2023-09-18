//
//  FakeSearchBar.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/27/23.
//

import SwiftUI

struct FakeSearchBar: View
{
	@State var placeHolder: String

	init(placeHolder: String = "Search")
	{
		self.placeHolder = placeHolder
	}

	var body: some View
    {
        HStack
        {
            Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            Text($placeHolder.wrappedValue)
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
            Spacer()
        }

                .frame(height: 60)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding()

	}
}

struct FakeSearchBar_Previews: PreviewProvider
{
	static var previews: some View
	{
		FakeSearchBar()
	}
}
