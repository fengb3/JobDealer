//
// Created by Bohan Feng on 4/25/23.
//

import Foundation
import UIKit
import SwiftUI

class JobPostDetailVC: UIViewController
{
	@IBOutlet var container: UIView!

	var jobPost: JobPost? = nil
	var jobPostDetailView: JobPostDetailView? = nil
	var jobPostDetailViewData: JobPostDetailViewData? = nil

	override func viewDidLoad()
	{
		super.viewDidLoad()

		jobPostDetailViewData = JobPostDetailViewData()
		jobPostDetailViewData?.jobPost = jobPost!

		jobPostDetailView = JobPostDetailView(data: jobPostDetailViewData!, onApply: onApply)

		let childView = UIHostingController(rootView: jobPostDetailView)
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

	func onApply()
	{
//		self.dismiss(animated: true, completion: nil)

		SignalRService.shared.joinChat(Global.shared.user!.id, jobPost!.posterId)

		ApiRequest()
				.subDomains(["chat", "get", "\(Global.shared.user!.id)"])
				.method(.GET)
				.onSuccess
				{
					(data, response, error) in

					let chats = try! JSONDecoder().decode([Chat].self, from: data!)
					BDebug(chats)
					BDebug(self.jobPost)

					var chat: Chat! = nil

					for c in chats
					{
						if (c.senderId1 == self.jobPost?.posterId || c.senderId2 == self.jobPost?.posterId)
						{
							chat = c
							break
						}
					}

					if (chat == nil)
					{
						BError("chat is nil")
					}
					else
					{
						self.performSegue(withIdentifier: "PostDetailToChat", sender: chat)
					}
				}
				.send()


	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if (segue.identifier == "PostDetailToChat")
		{
			BDebug("PostDetailToChat")

			let chatVC = segue.destination as! ChatVC
			chatVC.chat = (sender as! Chat)

		}
	}
}
