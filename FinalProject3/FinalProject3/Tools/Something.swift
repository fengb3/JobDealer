//
// Created by Bohan Feng on 4/26/23.
//

import Foundation
import UIKit


//----

//func imageUploadRequest(imageView imageView: UIImageView, uploadUrl: URL, param: [String:String]?) {
//
//	//let myUrl = NSURL(string: "http://192.168.1.103/upload.photo/index.php");
//
//	let request = NSMutableURLRequest(url: uploadUrl);
//	request.httpMethod = "post"
//
//	let boundary = generateBoundaryString()
//
//	request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//	let imageData = imageView.image!.jpegData(compressionQuality: 0.5)
//
//	if(imageData==nil)  { return; }
//
//	request.HTTPBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
//
//	//myActivityIndicator.startAnimating();
//
//	let task =  URLSession.sharedSession.dataTaskWithRequest(request as URLRequest,
//	                                                             completionHandler: {
//		                                                             (data, response, error) -> Void in
//		                                                             if let data = data {
//
//			                                                             // You can print out response object
//			                                                             print("******* response = \(response)")
//
//			                                                             print(data.length)
//			                                                             // you can use data here
//
//			                                                             // Print out reponse body
//			                                                             let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//			                                                             print("****** response data = \(responseString!)")
//
//			                                                             let json =  try!NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
//
//			                                                             print("json value \(json)")
//
//			                                                             //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
//
//			                                                             dispatch_async(dispatch_get_main_queue(),{
//				                                                             //self.myActivityIndicator.stopAnimating()
//				                                                             //self.imageView.image = nil;
//			                                                             });
//
//		                                                             } else if let error = error {
//			                                                             print(error.description)
//		                                                             }
//	                                                             })
//	task.resume()
//
//
//}
//
//
//func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
//	let body = NSMutableData();
//
//	if parameters != nil {
//		for (key, value) in parameters! {
//			body.appendString(string: "--\(boundary)\r\n")
//			body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//			body.appendString(string: "\(value)\r\n")
//		}
//	}
//
//	let filename = "user-profile.jpg"
//
//	let mimetype = "image/jpg"
//
//	body.appendString(string: "--\(boundary)\r\n")
//	body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//	body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
//	body.append(imageDataKey as Data)
//	body.appendString(string: "\r\n")
//
//	body.appendString(string: "--\(boundary)--\r\n")
//
//	return body
//}
//
//func generateBoundaryString() -> String {
//	return "Boundary-\(NSUUID().uuidString)"
//}
//
//// extension for impage uploading
//
//extension NSMutableData {
//
//	func appendString(string: String) {
//		let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//		appendData(data!)
//	}
//}