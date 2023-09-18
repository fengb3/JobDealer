//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import SwiftUI

struct ImageView: View
{
	@State private var image: UIImage? = nil
	@State private var imageURL: URL? = nil
	@State private var showingImagePicker = false
	@State private var downloadedImage: UIImage? = nil

	@State private var imageFileName: String? = nil

	var body: some View
	{
		VStack
		{
			if let image = image
			{
				Image(uiImage: image)
						.resizable()
						.scaledToFit()
			}

			Button("Select Image")
			{
				showingImagePicker = true
			}
					.sheet(isPresented: $showingImagePicker)
					{
						ImagePicker(image: $image,imageFileName: $imageFileName )
					}

			Button("Upload Image")
			{
				uploadImage()
			}

			if let downloadedImage = downloadedImage
			{
				Image(uiImage: downloadedImage)
						.resizable()
						.scaledToFit()
			}
		}
	}

	func uploadImage()
	{
		guard let image = image, let imageData = image.jpegData(compressionQuality: 0), let imageURL = imageURL else { return }

		// print out the image file size
		print("Image file size: \(imageData.count / 1024)KB")

		let boundary = generateBoundary()
		let contentType = "multipart/form-data; boundary=\(boundary)"
		let multipartBody = createMultipartFormDataBody(imageData: imageData, fileName: imageURL.lastPathComponent, boundary: boundary)

		ApiRequest()
				.subDomains(["api", "image", "upload"])
				.method(.post)
				.headers(["Content-Type": contentType, "Content-Length": "\(multipartBody.count)"])
				.body(multipartBody)
				.onSuccess
				{ data, response, error in
					guard let data = data, error == nil else
					{
						print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
						return
					}

					if let fileName = try? JSONDecoder().decode([String: String].self, from: data)["FileName"]
					{
						print("Uploaded image with file name: \(fileName)")
						downloadImage(fileName: fileName)
					}
					else
					{
						print("Error decoding server response.")
					}
				}
				.send()
	}

	func downloadImage(fileName: String)
	{
		ApiRequest()
				.subDomains(["api", "image", fileName])
				.method(.get)
				.onSuccess
				{ data, response, error in
					guard let data = data, let image = UIImage(data: data), error == nil else
					{
						print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
						return
					}

					downloadedImage = image
					print("Image successfully downloaded.")
				}
				.send()
	}


	func mimeType(forExtension fileExtension: String) -> String
	{
		let ext = fileExtension.lowercased()
		BDebug(ext)
		switch ext
		{
		case "jpeg", "jpg":
			return "image/jpeg"
		case "png":
			return "image/png"
		case "gif":
			return "image/gif"
		default:
			return "application/octet-stream"
		}
	}

	func generateBoundary() -> String {
		return "Boundary-\(UUID().uuidString)"
	}

	func createMultipartFormDataBody(imageData: Data, fileName: String, boundary: String) -> Data {
		var body = Data()
		let fileURL = URL(fileURLWithPath: fileName)
		let mimeType = mimeType(forExtension: fileURL.pathExtension)

		// Add image data
		body.append("--\(boundary)\r\n".data(using: .utf8)!)
		body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
		body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
		body.append(imageData)
		body.append("\r\n".data(using: .utf8)!)

		// Add end boundary
		body.append("--\(boundary)--\r\n".data(using: .utf8)!)

		return body
	}

}

struct ImageView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ImageView()
	}
}
