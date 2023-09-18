//
//  MyVC.swift
//  FianlProject2
//
//  Created by 生物球藻 on 4/26/23.
//

import Foundation
import UIKit
import SwiftUI

class MyVC<V:View> : UIViewController
{
    @IBOutlet var container : UIView!
    
    var rootView : V? = nil
    
    override func viewDidLoad() {
        
        if(rootView==nil)
        {
            BError("Root View Can Not Be Nil")
        }
        
        let childView = UIHostingController(rootView: self.rootView!)
                addChild(childView)
                childView.view.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(childView.view)

                NSLayoutConstraint.activate([
                                                childView.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                                childView.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                                                childView.view.topAnchor.constraint(equalTo: container.topAnchor),
                                                childView.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
                                            ])

                childView.didMove(toParent: self)
    }
}
