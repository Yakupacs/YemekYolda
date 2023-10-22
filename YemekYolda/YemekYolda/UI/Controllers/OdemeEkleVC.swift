import UIKit
import FirebaseFirestore
import FirebaseAuth

class OdemeEkleVC: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var kartCVVTextfield: UITextField!
	@IBOutlet weak var kartNumarasiTextfield: UITextField!
	@IBOutlet weak var kartAdiTextfield: UITextField!
	
	var odemeViewModel = OdemeViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		kartNumarasiTextfield.delegate = self
		kartCVVTextfield.delegate = self
    }

	@IBAction func saveAction(_ sender: Any) {
		if kartNumarasiTextfield.text?.count != 16{
			let alert = view.addAlert(title: "Uyarı", message: "Kart numarası yalnızca 16 rakam olmalıdır. ")
			self.present(alert, animated: true)
			return
		}
		if kartCVVTextfield.text?.isEmpty == false && kartNumarasiTextfield.text?.isEmpty == false && kartAdiTextfield.text?.isEmpty == false{
			odemeViewModel.odemeEkle(kartCVV: kartCVVTextfield.text!, kartNumarasi: kartNumarasiTextfield.text!, kartAdi: kartAdiTextfield.text!)
			self.dismiss(animated: true)
		}
	}
	@IBAction func closeAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
}
