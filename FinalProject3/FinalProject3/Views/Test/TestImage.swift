//
//  TestImage.swift
//  FinalProject3
//
//  Created by 生物球藻 on 4/26/23.
//

import SwiftUI

struct TestImage: View {
    var body: some View {
        Image("Spherule")
            .cornerRadius(60)
//            .frame(width: 500, height: 500)
    }
}

struct TestImage_Previews: PreviewProvider {
    static var previews: some View {
        TestImage()
    }
}
