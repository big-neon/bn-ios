// MARK: remove this file.....

import UIKit

extension ProfileViewController {
    
    /*
     These are future functions for profile image capturing
     **/
    /*
    @objc internal func handleUploadImage() {
        let alertController = UIAlertController(title: "Upload a Profile Picture",
                                                message: nil, preferredStyle: .actionSheet)

        let takePhotoButton = UIAlertAction(title: "Take a photo", style: .default, handler: { (_) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.delegate = self
                self.picker.allowsEditing = true
                self.picker.sourceType = .camera
                self.picker.cameraDevice = .front
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            }
        })

        let  photoLibraryButton = UIAlertAction(title: "Pick from library", style: .default, handler: { (_) -> Void in
            self.picker.delegate = self
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        })

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
        })

        alertController.addAction(takePhotoButton)
        alertController.addAction(photoLibraryButton)
        alertController.addAction(cancelButton)

        self.present(alertController, animated: true, completion: nil)
    }

    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var imageToUpload: UIImage?
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileHeaderView.userImageView.contentMode = .scaleAspectFill
            self.profileHeaderView.userImageView.image = chosenImage
            imageToUpload = chosenImage
        } else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileHeaderView.userImageView.contentMode = .scaleAspectFill
            self.profileHeaderView.userImageView.image = chosenImage
            imageToUpload = chosenImage
        }
        dismiss(animated: true) {
            //  Set the image in the viewModel to the image here
        }
    }
    */
}
