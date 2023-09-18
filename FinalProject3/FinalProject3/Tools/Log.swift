//
// Created by Bohan Feng on 4/21/23.
//

import Foundation
import SignalRClient

class MyLogger: Logger
{
	func log(logLevel: SignalRClient.LogLevel, message: @autoclosure () -> String)
	{
		switch logLevel
		{
		case .debug:
			BDebug(message(), file:"SignalRClient", function: "~", line: 8)
		case .info:
			BInfo(message())
		case .warning:
			BWarning(message())
		case .error:
			BError(message())
		}
	}
}


func BDebug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line)
{
	let fileName = (file as NSString).lastPathComponent
	let str = .white + "👀 \(fileName):\(line) \(function) ~> \(message)"
	print(str)
}

func BInfo(_ message: Any)
{
	print(.green + "ℹ️ \(message)")
}

func BWarning(_ message: Any)
{
	print(.yellow + "⚠️ \(message)")
}

func BError(_ message: Any)
{
	print(.red + "💀 \(message)")
}

enum ANSIColors: String
{
	case black = "\u{001B}[0;30m"
	case red = "\u{001B}[0;31m"
	case green = "\u{001B}[0;32m"
	case yellow = "\u{001B}[0;33m"
	case blue = "\u{001B}[0;34m "
	case magenta = "\u{001B}[0;35m"
	case cyan = "\u{001B}[0;36m"
	case white = "\u{001B}[0;37m"
	case `default` = " \u{001B}[0;0m"

	func name() -> String
	{
		switch self
		{
		case .black: return "Black"
		case .red: return "Red"
		case .green: return "Green"
		case .yellow: return "Yellow"
		case .blue: return "Blue"
		case .magenta: return "Magenta"
		case .cyan: return "Cyan"
		case .white: return "White"
		case .default: return "Default"
		}
	}

}

func +(lhs: ANSIColors, rhs: String) -> String
{
	"\(lhs.rawValue) - \(rhs) - \(ANSIColors.default.rawValue)"
}
