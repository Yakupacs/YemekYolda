import UIKit
import FirebaseFirestore
import FirebaseAuth

class AdresEkleVC: UIViewController {
	
	@IBOutlet weak var adresBasligiLabel: UITextField!
	@IBOutlet weak var mahalleLabel: UITextField!
	@IBOutlet weak var binaNoLabe: UITextField!
	@IBOutlet weak var katLabel: UITextField!
	@IBOutlet weak var daireNoLabel: UITextField!
	@IBOutlet weak var adresTarifiLabel: UITextField!
	
	var adresViewModel = AdresViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appearance()
	}
	
	@IBAction func kaydetAction(_ sender: Any) {
		if adresTarifiLabel.text?.isEmpty == false && mahalleLabel.text?.isEmpty == false && binaNoLabe.text?.isEmpty == false && katLabel.text?.isEmpty == false && daireNoLabel.text?.isEmpty == false && adresTarifiLabel.text?.isEmpty == false {
			adresViewModel.adresEkle(adresBasligi: adresBasligiLabel.text!, adresTarifi: adresTarifiLabel.text!, binaNo: binaNoLabe.text!, daireNo: daireNoLabel.text!, kat: katLabel.text!, mahalle: mahalleLabel.text!)
			self.dismiss(animated: true)
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
