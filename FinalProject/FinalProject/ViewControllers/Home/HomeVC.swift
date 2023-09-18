//
// Created by Bohan Feng on 4/18/23.
//

import Foundation
import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

	@IBOutlet var myTable: UITableView!
    

	override func viewDidLoad()
	{
		super.viewDidLoad()
		myTable.dataSource = self
		myTable.delegate = self

		myTable.separatorColor = .clear

		fetchJobs()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return jobs.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCell", for: indexPath) as! JobTableViewCell

		cell.labelTitle?.text = jobs[indexPath.row].title

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)

//		let post = jobs[indexPath.row]

		performSegue(withIdentifier: "ToJobDetail", sender: indexPath)

		// show chat messages
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if(segue.identifier == "ToJobDetail")
		{
			BDebug("ToJobDetail")

			let vc = segue.destination as! JobPostDetailVC
			let path = sender as! IndexPath
			vc.jobPost = jobs[path.row]
		}
	}

//	@IBAction func onBtbPressed(_ sender: Any)
//	{
//		SignalRService.shared.joinChat(1)
//	}


	var jobs: [JobPost] = []

	func fetchJobs()
	{
		ApiRequest()
				.subDomains(["jobPost", "GetRecommend", "\(Global.shared.user!.id)"])
				.method(.GET)
				.onSuccess
				{
					(data, response, error) in

					let jobs = try! JSONDecoder().decode([JobPost].self, from: data!)
					BDebug(jobs)

					self.jobs = jobs

                    self.refresh()
				}
				.send()
	}

    func refresh()
    {
        self.myTable.reloadData()
    }

}
