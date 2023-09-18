import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
	@Binding var image: UIImage?
	@Binding var imageFileName: String?

	func makeCoordinator() -> PHPickerCoordinator {
		PHPickerCoordinator(self)
	}

	func makeUIViewController(context: Context) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.filter = .images
		configuration.selectionLimit = 1
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
		// No update needed.
	}
}


class PHPickerCoordinator: NSObject, PHPickerViewControllerDelegate {
	var parent: ImagePicker

	init(_ parent: ImagePicker) {
		self.parent = parent
	}

	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true, completion: nil)

		guard let result = results.first else { return }
		let itemProvider = result.itemProvider

		if itemProvider.canLoadObject(ofClass: UIImage.self) {
			itemProvider.loadObject(ofClass: UIImage.self) { image, error in
				DispatchQueue.main.async {
					if let uiImage = image as? UIImage {
						self.parent.image = uiImage
					}
				}
			}
		}

		if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") || itemProvider.hasItemConformingToTypeIdentifier("public.png") {
			itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { url, error in
				if let fileURL = url {
					let fileName = fileURL.lastPathComponent
					let x = fileURL.lastPathComponent
					print("Original file name: \(fileName)")
					self.parent.imageFileName = fileName
				}
			}
		}
	}
}
