import UIKit
import FirebaseAuth

class GirisVC: UIViewController {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextfield: UITextField!
	@IBOutlet weak var myIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		appearance()
    }
}

// MARK: - ACTIONS
extension GirisVC{ 
	@IBAction func girisYapAction(_ sender: Any) {
		myIndicator.startAnimating()
		
		if emailTextField.text != "" && passwordTextfield.text != ""{
			Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!) { authData, error in
				if error != nil
				{
					let alert = self.view.addAlert(title: "Uyarı!", message: error!.localizedDescription)
					self.present(alert, animated: true)
					self.myIndicator.stopAnimating()
				}
				else{
					self.emailTextField.text = ""
					self.passwordTextfield.text = ""
					self.performSegue(withIdentifier: "toLogin", sender: nil)
					self.myIndicator.stopAnimating()
				}
			}
		}
		else{
			let alert = self.view.addAlert(title: "Uyarı!", message: "Lütfen gerekli yerleri doldurunuz.")
			self.present(alert, animated: true)
			self.myIndicator.stopAnimating()
		}
	}
	@objc func keyboardDismiss(){
		view.endEditing(true)
	}
	func appearance(){
		myIndicator.hidesWhenStopped = true
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
		view.addGestureRecognizer(tapGesture)
	}
}
