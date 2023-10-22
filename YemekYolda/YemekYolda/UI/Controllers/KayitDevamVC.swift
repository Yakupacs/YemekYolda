import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase

class KayitDevamVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	@IBOutlet weak var myIndicator: UIActivityIndicatorView!
	@IBOutlet weak var myImageView: UIImageView!
	@IBOutlet weak var tamamlaButton: UIButton!
	@IBOutlet weak var tamAdLabel: UITextField!
	
	var kullanici = Kullanici()
	var imagePicker = UIImagePickerController()
	var imageSelected = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appearance()
	}
	
	@IBAction func onaylaActio(_ sender: Any) {
		myIndicator.startAnimating()
		tamamlaButton.isEnabled = false
		
		if tamAdLabel.text == "" {
			var alert = self.view.addAlert(title: "Uyarı!", message: "Lütfen gerekli yerleri doldurunuz.")
			self.present(alert, animated: true)
			myIndicator.stopAnimating()
			tamamlaButton.isEnabled = true
			return
		}
		let storage = Storage.storage()
		let storageReference = storage.reference()
		let mediaFolder = storageReference.child("userImages")
		
		if let data = myImageView.image?.jpegData(compressionQuality: 0.5){
			let uuid = UUID().uuidString
			
			let imageReference = mediaFolder.child("\(uuid).jpg")
			
			imageReference.putData(data, metadata: nil) { metadata, error in
				if error != nil{
					self.myIndicator.stopAnimating()
					self.tamamlaButton.isEnabled = true
					print(error!.localizedDescription)
				}
				else{
					imageReference.downloadURL { url, error in
						var firestorePost = [String: Any]()
						if error != nil{
							self.myIndicator.stopAnimating()
							self.tamamlaButton.isEnabled = true
							print(error!.localizedDescription)
						}
						else{
							let imageURL = url!.absoluteString
							let firestoreDatabase = Firestore.firestore()
							var firestoreReference: DocumentReference? = nil
							if self.imageSelected == true{
								firestorePost = [
													"mail": self.kullanici.mail!,
													"fotograf": imageURL,
													"kullaniciAdi": self.kullanici.kullaniciAdi!,
													"ad": self.tamAdLabel.text!,
													"kayitTarihi": self.kullanici.kayitTarihi!,
													] as [String: Any]
							}else{
								firestorePost = [
													"mail": self.kullanici.mail!,
													"fotograf": "https://cdn-icons-png.flaticon.com/512/3177/3177440.png",
													"kullaniciAdi": self.kullanici.kullaniciAdi!,
													"ad": self.tamAdLabel.text!,
													"kayitTarihi": self.kullanici.kayitTarihi!,
													] as [String: Any]
							}

							firestoreReference = firestoreDatabase.collection("Kullanici").addDocument(data: firestorePost, completion: { error in
								if error != nil{
									print(error!.localizedDescription)
								}else{
									print("Veri başarıyla kaydedildi.")
									self.performSegue(withIdentifier: "toHomepage", sender: nil)
								}
								self.myIndicator.stopAnimating()
								self.tamamlaButton.isEnabled = true
							})
						}
					}
				}
			}
		}
	}
	@objc func chooseImage(){
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .photoLibrary
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imageSelected = true
		myImageView.image = info[.originalImage] as? UIImage
		self.dismiss(animated: true)
	}
	@objc func keyboardDismiss(){
		view.endEditing(true)
	}
	func appearance(){
		myIndicator.hidesWhenStopped = true
		myImageView.layer.cornerRadius = 50
		myImageView.layer.borderWidth = 1
		myImageView.layer.borderColor = UIColor.black.cgColor
		myImageView.isUserInteractionEnabled = true
		
		let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
		myImageView.addGestureRecognizer(imageGestureRecognizer)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
		view.addGestureRecognizer(tapGesture)
	}
}

