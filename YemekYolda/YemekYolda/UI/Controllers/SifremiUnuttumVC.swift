import UIKit
import FirebaseAuth

class SifremiUnuttumVC: UIViewController {

	@IBOutlet weak var sifirlaButton: UIButton!
	@IBOutlet weak var emailTextfield: UITextField!
	@IBOutlet weak var indicatorView: UIActivityIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		indicatorView.hidesWhenStopped = true
		appearance()
    }
}

// MARK: - ACTIONS
extension SifremiUnuttumVC{
	@IBAction func sifirlaAction(_ sender: Any) {
		indicatorView.startAnimating()
		sifirlaButton.isEnabled = false
		if emailTextfield.text != ""{
			Auth.auth().sendPasswordReset(withEmail: self.emailTextfield.text!,completion: { error in
				if error != nil{
					var alert = self.view.addAlert(title: "Uyarı!", message: error!.localizedDescription)
					self.present(alert, animated: true)
				}else{
					let alert = UIAlertController(title: "Başarılı", message: "Email adresinize şifrenizi sıfırlamanız için bir bağlantı gönderildi.", preferredStyle: .alert)
					let okeyAction = UIAlertAction(title: "Tamam", style: .default){ _ in
						self.dismiss(animated: true)
					}
					alert.addAction(okeyAction)
					self.present(alert, animated: true)
				}
				self.indicatorView.stopAnimating()
				self.sifirlaButton.isEnabled = true
			})
		}else{
			var alert = self.view.addAlert(title: "Uyarı!", message: "Lütfen gerekli alanları doldurunuz.")
			self.present(alert, animated: true)
			self.indicatorView.stopAnimating()
			sifirlaButton.isEnabled = true
		}
	}
	@objc func keyboardDismiss(){
		view.endEditing(true)
	}
	func appearance(){
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
		view.addGestureRecognizer(tapGesture)
	}
}
