//
// Created by Bohan Feng on 4/27/23.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable
{

	var onPick: (URL) -> Void

	func makeCoordinator() -> Coordinator
	{
		Coordinator(self)
	}

	func makeUIViewController(context: Context) -> UIDocumentPickerViewController
	{
		let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeData as String], in: .import)
		documentPicker.delegate = context.coordinator
		documentPicker.allowsMultipleSelection = false
		return documentPicker
	}

	func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context)
	{
		// No update needed
	}

	class Coordinator: NSObject, UIDocumentPickerDelegate
	{
		var parent: DocumentPicker

		init(_ parent: DocumentPicker)
		{
			self.parent = parent
		}

		func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
		{
			guard let selectedFileURL = urls.first else
			{
				return
			}
			parent.onPick(selectedFileURL)
		}
	}
}

