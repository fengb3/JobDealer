//
// Created by Bohan Feng on 4/8/23.
//

import Foundation

//
// Created by Bohan Feng on 4/7/23.
//

import Foundation

struct ApiRequest
{
	var subDomains: [String] = []
	var method: HTTPMethod = .GET
	var body: Data? = nil
	var onError: ((Data?, URLResponse?, Error?) -> Void)? = nil
	var onBadResponse: ((Data?, URLResponse?, Error?) -> Void)? = nil
	var onSuccess: ((Data?, URLResponse?, Error?) -> Void)? = nil

	init()
	{
	}

	func subDomains(_ subDomains: [String]) -> ApiRequest
	{
		var request = self
		request.subDomains = subDomains
		return request
	}

	func subDomain(_ subDomains: @escaping () -> [String]) -> ApiRequest
	{
		var request = self
		request.subDomains = subDomains()
		return request
	}

	func method(_ method: HTTPMethod) -> ApiRequest
	{
		var request = self
		request.method = method
		return request
	}

	func method(_ method: @escaping () -> HTTPMethod) -> ApiRequest
	{
		var request = self
		request.method = method()
		return request
	}

	func body(_ body: [String: Any]) -> ApiRequest
	{
		var request = self
		request.body = try? JSONSerialization.data(withJSONObject: body)
		return request
	}

	func body(_ body: @escaping () -> [String: Any]) -> ApiRequest
	{
		var request = self
		request.body = try? JSONSerialization.data(withJSONObject: body())
		return request
	}

	func body(_ body: Codable) -> ApiRequest
	{
		var request = self
		request.body = try? JSONEncoder().encode(body)
		return request
	}

	func body(_ body: @escaping () -> Codable) -> ApiRequest
	{
		var request = self
		request.body = try? JSONEncoder().encode(body())
		return request
	}

	func body(_ body: Data?) -> ApiRequest
	{
		var request = self
		request.body = body
		return request
	}

	func onError(_ onError: @escaping (Data?, URLResponse?, Error?) -> Void) -> ApiRequest
	{
		var request = self
		request.onError = onError
		return request
	}

	func onBadResponse(_ onBadResponse: @escaping (Data?, URLResponse?, Error?) -> Void) -> ApiRequest
	{
		var request = self
		request.onBadResponse = onBadResponse
		return request
	}

	func onSuccess(_ onSuccess: @escaping (Data?, URLResponse?, Error?) -> Void) -> ApiRequest
	{
		var request = self
		request.onSuccess = onSuccess
		return request
	}

	func send()
	{
		var url = "http://0.0.0.0:7202"

		for sub in subDomains
		{
			url += "/\(sub)"
		}

		sendApiRequest(url, method, body, onError, onBadResponse, onSuccess)
	}
}

func sendApiRequest(_ url: String, _ method: HTTPMethod, _ body: Data?,
					_ onError: ((Data?, URLResponse?, Error?) -> Void)?,
					_ onBadResponse: ((Data?, URLResponse?, Error?) -> Void)?,
					_ onSuccess: ((Data?, URLResponse?, Error?) -> Void)?)
{
	var request = URLRequest(url: URL(string: url)!)
	request.httpMethod = method.rawValue
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	request.httpBody = body ?? Data()

	BInfo("::: \(request.httpMethod ?? "NIL METHOD") ::: request to \(request) ::: \(String(data: body ?? Data(), encoding: .utf8) ?? "Bad Body") :::")

//	let group = DispatchGroup()
//	group.enter()

	let task = URLSession.shared.dataTask(with: request)
	{
		data, response, error in

		if let error = error
		{
			BError("::: \(request.httpMethod ?? "NIL") ::: error : \(error.localizedDescription) :::")
			DispatchQueue.main.async
			{
				onError?(data, response, error)
			}
			return
		}

		if let httpResponse = response as? HTTPURLResponse
		{
			// Log.info("::: response status code: \(httpResponse.statusCode) :::")

			if (httpResponse.statusCode >= 400)
			{
				BError("::: \(request.httpMethod ?? "NIL") ::: response code : \(httpResponse.statusCode) ::: \(String(data: data!, encoding: .utf8) ?? "NIL DATA") :::")

				DispatchQueue.main.async
				{
					onBadResponse?(data, response, error)
				}

				return
			}

			if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 400)
			{
				BInfo("::: \(request.httpMethod ?? "NIL") ::: response code : \(httpResponse.statusCode) :::")

				DispatchQueue.main.async
				{
					onSuccess?(data, response, error)
				}
			}
		}

	}

	task.resume()
}

enum HTTPMethod: String
{
	case GET
	case POST
	case PATCH
	case PUT
	case DELETE
}
