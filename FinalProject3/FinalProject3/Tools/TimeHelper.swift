//
// Created by Bohan Feng on 4/26/23.
//

import Foundation

func getNow() -> Int64
{
	return Int64(Date().timeIntervalSince1970)
}

func getNowString() -> String
{
	return String(getNow())
}

extension Int64
{
	func toDateString(format: String = "yyyy-MMM-dd") -> String
	{
		let date = Date(timeIntervalSince1970: TimeInterval(self))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: date)
	}

	func toDateString() -> String
	{
		let date = Date(timeIntervalSince1970: TimeInterval(self))

		if(Calendar.current.isDateInToday(date))
		{
			return self.toDateString(format: "HH:mm")
		}
		else if(Calendar.current.isDateInYesterday(date))
		{
			return "Yesterday"
		}
		else if(Calendar.current.isDateInWeekend(date))
		{
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "EEEE"
			return dateFormatter.string(from: date)
		}
		else
		{
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM-dd"
			return dateFormatter.string(from: date)
		}
	}
}
