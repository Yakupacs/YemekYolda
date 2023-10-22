import UIKit
import FirebaseAuth

class KayitVC: UIViewController {
	
	@IBOutlet weak var emailTextfield: UITextField!
	@IBOutlet weak var passwordTextfield: UITextField!
	@IBOutlet weak var usernameTextfield: UITextField!
	@IBOutlet weak var myIndicatior: UIActivityIndicatorView!
	@IBOutlet weak var kayitOlButton: UIButton!
	
	var kullanici = Kullanici()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		appearance()
	}
}

// MARK: - ACTIONS
extension KayitVC{
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toKayitDevam"{
			if let destVC = segue.destination as? KayitDevamVC{
				destVC.kullanici = kullanici
			}
		}
	}
	@IBAction func kayitOlAction(_ sender: Any) {
		myIndicatior.startAnimating()
		kayitOlButton.isEnabled = false
		if emailTextfield.text != "" && passwordTextfield.text != "" && usernameTextfield.text != ""{
			Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { authdata, error in
				if error != nil
				{
					let alert = self.view.addAlert(title: "Warning!", message: error!.localizedDescription)
					self.present(alert, animated: true)
					self.myIndicatior.stopAnimating()
					self.kayitOlButton.isEnabled = true
				}
				else{
					self.kullanici.ad = "Kullanıcı"
					self.kullanici.image = "https://cdn-icons-png.flaticon.com/512/1077/1077114.png"
					self.kullanici.kayitTarihi = Date()
					self.kullanici.kullaniciAdi = self.usernameTextfield.text!
					self.kullanici.mail = self.emailTextfield.text!
					
					self.emailTextfield.text = ""
					self.usernameTextfield.text = ""
					self.passwordTextfield.text = ""
					self.myIndicatior.stopAnimating()
					self.kayitOlButton.isEnabled = true
					self.performSegue(withIdentifier: "toKayitDevam", sender: nil)
				}
			}
		}else{
			let alert = self.view.addAlert(title: "Uyarı!", message: "Lütfen gerekli yerleri doldurunuz")
			self.present(alert, animated: true)
			self.myIndicatior.stopAnimating()
			kayitOlButton.isEnabled = true
		}
	}
	@objc func keyboardDismiss(){
		view.endEditing(true)
	}
	func appearance(){
		myIndicatior.hidesWhenStopped = true
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
		view.addGestureRecognizer(tapGesture)
	}
}
