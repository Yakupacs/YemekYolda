import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfiliDuzenleVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var emailTxt: UITextField!
	@IBOutlet weak var kullaniciAdiTxt: UITextField!
	@IBOutlet weak var tamAdTxt: UITextField!
	@IBOutlet weak var kullaniciImage: UIImageView!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var kaydetButton: UIButton!
	@IBOutlet weak var myIndicator: UIActivityIndicatorView!
	
	var kullanici = Kullanici()
	var degisiklikVarmi = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		emailTxt.delegate = self
		kullaniciAdiTxt.delegate = self
		tamAdTxt.delegate = self
		myIndicator.hidesWhenStopped = true
		appearance()
		AnasayfaViewModel.shared.yemekRepo.kullaniciDoldur()
		_ = AnasayfaViewModel.shared.yemekRepo.kullanici.subscribe(onNext: { liste in
			self.kullanici = liste
			self.tamAdTxt.text = liste.ad
			self.kullaniciAdiTxt.text = liste.kullaniciAdi
			self.emailTxt.text = liste.mail
			if let image = liste.image{
				if let url = URL(string: "\(image)") {
					DispatchQueue.main.async {
						self.kullaniciImage.kf.setImage(with: url)
					}
				}
			}
		})
	}
	
	@IBAction func kaydetAction(_ sender: Any) {
		if (degisiklikVarmi == false) { self.dismiss(animated: true) }
		myIndicator.startAnimating()
		kaydetButton.isEnabled = false
		if tamAdTxt.text == "" ||
			kullaniciAdiTxt.text == "" ||
			emailTxt.text == ""{
			var alert = self.view.addAlert(title: "Uyarı!", message: "Lütfen gerekli yerleri doldurunuz")
			self.present(alert, animated: true)
			myIndicator.stopAnimating()
		}
		else{
			kaydetButton.isEnabled = false
			closeButton.isEnabled = false
			self.closeButton.isEnabled = false
			
			let firestore = Firestore.firestore()
			
			let storage = Storage.storage()
			let storageReference = storage.reference()
			let mediaFolder = storageReference.child("userImages")
			
			if let data = kullaniciImage.image?.jpegData(compressionQuality: 0.5){
				let uuid = UUID().uuidString
				
				let imageReference = mediaFolder.child("\(uuid).jpg")
				
				imageReference.putData(data, metadata: nil) { metadata, error in
					if error != nil{
						self.myIndicator.stopAnimating()
						print(error!.localizedDescription)
					}
					else{
						imageReference.downloadURL { url, error in
							if error != nil{
								self.myIndicator.stopAnimating()
								print(error!.localizedDescription)
							}else{
								let imageURL = url!.absoluteString
								let firestoreDatabase = Firestore.firestore()
								var firestoreReference: DocumentReference? = nil
								let firestorePost = [
									"mail": self.emailTxt.text!,
									"fotograf": imageURL,
									"kullaniciAdi": self.kullaniciAdiTxt.text!,
									"ad": self.tamAdTxt.text!
								] as [String: Any]
								firestoreDatabase.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { querySnapshot, error in
									if let error = error{
										self.myIndicator.stopAnimating()
										print(error.localizedDescription)
									}else{
										guard let querySnapshot = querySnapshot else { return }
										
										for document in querySnapshot.documents{
											let documentRef = document.reference
											
											documentRef.updateData(
												["kullaniciAdi": self.kullaniciAdiTxt.text!,
												"ad": self.tamAdTxt.text!,
												"mail": self.emailTxt.text!,
												 "fotograf": imageURL]) { error in
													 if let error = error{
														 print(error.localizedDescription)
													 }else{
														 self.dismiss(animated: true)
													 }
													 self.closeButton.isEnabled = true
													 self.kaydetButton.isEnabled = true
													 self.myIndicator.stopAnimating()
											}
										}
									}
								}
								
							}
						}
					}
				}
			}else{
				self.myIndicator.stopAnimating()
			}
		}
		kaydetButton.isEnabled = true
		closeButton.isEnabled = true
	}
	@IBAction func closeAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
	@IBAction func fotografiDegistirAction(_ sender: Any) {
		chooseImage()
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		degisiklikVarmi = true
		kullaniciImage.image = info[.originalImage] as? UIImage
		self.dismiss(animated: true)
	}
	@objc func chooseImage(){
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .photoLibrary
		present(pickerController, animated: true)
	}
	@objc func keyboardDismiss(){
		view.endEditing(true)
	}
	func textFieldDidChangeSelection(_ textField: UITextField) {
		degisiklikVarmi = true
	}
	func appearance(){
		kullaniciImage.layer.cornerRadius = 64
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
		view.addGestureRecognizer(tapGesture)
	}
}
