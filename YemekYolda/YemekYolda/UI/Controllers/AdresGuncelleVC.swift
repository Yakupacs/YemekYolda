import UIKit
import FirebaseFirestore
import FirebaseAuth

class AdresGuncelleVC: UIViewController {
	
	@IBOutlet weak var adresBasligiTxt: UITextField!
	@IBOutlet weak var mahalleTxt: UITextField!
	@IBOutlet weak var binaTxt: UITextField!
	@IBOutlet weak var katTxt: UITextField!
	@IBOutlet weak var daireTxt: UITextField!
	@IBOutlet weak var adresTarifiTxt: UITextField!
	
	var gelenAdres : Adres?
	var adresViewModel = AdresViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		appearance()
	}
	@IBAction func closeAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
	@IBAction func guncelleAction(_ sender: Any)
	{
		if adresTarifiTxt.text?.isEmpty == false && mahalleTxt.text?.isEmpty == false && binaTxt.text?.isEmpty == false && katTxt.text?.isEmpty == false && daireTxt.text?.isEmpty == false && adresTarifiTxt.text?.isEmpty == false {
			adresViewModel.adresGuncelle(gelenAdres: gelenAdres!, adresBasligi: adresBasligiTxt.text!, adresTarifi: adresTarifiTxt.text!, binaNo: binaTxt.text!, daireNo: daireTxt.text!, kat: katTxt.text!, mahalle: mahalleTxt.text!)
			self.dismiss(animated: true)
		}
	}
	func appearance(){
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
		view.addGestureRecognizer(tapGesture)
		
		guard let gelenAdres = gelenAdres else { return }
		
		adresBasligiTxt.text = gelenAdres.adresBasligi
		mahalleTxt.text = gelenAdres.mahalle
		binaTxt.text = gelenAdres.binaNo
		katTxt.text = gelenAdres.kat
		daireTxt.text = gelenAdres.daireNo
		adresTarifiTxt.text = gelenAdres.adresTarifi
	}
	@objc func keyboardDismiss(){
		view.endEditing(true)
	}
}
