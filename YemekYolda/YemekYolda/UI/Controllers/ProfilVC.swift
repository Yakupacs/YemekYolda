import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfilVC: UIViewController {
	
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userEmailLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appearance()
		
		_ = AnasayfaViewModel.shared.yemekRepo.kullanici.subscribe(onNext: { kullanici in
			if let image = kullanici.image{
				if let url = URL(string: "\(image)") {
					DispatchQueue.main.async {
						self.userImageView.kf.setImage(with: url)
					}
				}
			}
			if let adi = kullanici.ad{
				self.userNameLabel.text = adi
			}
			if let email = kullanici.mail{
				self.userEmailLabel.text = email
			}
		})
	}
	override func viewWillAppear(_ animated: Bool) {
		AnasayfaViewModel.shared.yemekRepo.kullaniciDoldur()
	}
	@IBAction func hesabimiSilAction(_ sender: Any) {
		let alert = UIAlertController(title: "Hesabı Sil", message: "Hesabınızı gerçekten silmek istiyor musunuz?", preferredStyle: .alert)
		
		let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { (action) in
			if let user = Auth.auth().currentUser {
				let userEmail = user.email
				
				user.delete { (error) in
					if let error = error {
						print("Hesap silme hatası: \(error.localizedDescription)")
					} else {
						do {
							try Auth.auth().signOut()
						} catch let signOutError as NSError {
							print("Çıkış yapma hatası: \(signOutError.localizedDescription)")
						}
						
						if let userEmail = userEmail {
							let db = Firestore.firestore()
							let userCollection = db.collection("Kullanici")
							let userQuery = userCollection.whereField("mail", isEqualTo: userEmail)
							
							userQuery.getDocuments { (querySnapshot, error) in
								if let error = error {
									print("Firestore sorgu hatası: \(error.localizedDescription)")
								} else {
									for document in querySnapshot!.documents {
										document.reference.delete { error in
											if let error = error {
												print("Firestore belgesi silme hatası: \(error.localizedDescription)")
											} else {
												print("Firestore belgesi başarıyla silindi.")
												self.performSegue(withIdentifier: "toBack", sender: nil)
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
		
		alert.addAction(deleteAction)
		alert.addAction(cancelAction)
		
		present(alert, animated: true, completion: nil)
	}
	@IBAction func cikisYapAction(_ sender: Any) {
		do {
			try Auth.auth().signOut()
			performSegue(withIdentifier: "toBack", sender: nil)
		} catch{
			print(error.localizedDescription)
		}
	}
}

// MARK: - APPEARANCE()
extension ProfilVC{
	func appearance(){
		userImageView.layer.cornerRadius = 40
		userImageView.layer.borderWidth = 1
		userImageView.layer.borderColor = UIColor.black.cgColor
	}
}
