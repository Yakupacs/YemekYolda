import UIKit

class SiparisiTamamlaVC: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var siparisIDLabel: UILabel!
	
	var gelenSiparis: Siparis?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appearance()
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toSiparisDetayi"{
			let destVC = segue.destination as! SiparisIzlemeVC
			destVC.gelenSiparis = gelenSiparis
		}
	}
}

// MARK: - ACTIONS
extension SiparisiTamamlaVC{
	@IBAction func siparisiIzleAction(_ sender: Any) {
		performSegue(withIdentifier: "toSiparisDetayi", sender: nil)
	}
	@IBAction func anasayfaAction(_ sender: Any) {
		performSegue(withIdentifier: "toBack", sender: nil)
	}
}

// MARK: - APPEARANCE()
extension SiparisiTamamlaVC{
	func appearance(){
		let jeremyGif = UIImage.gifImageWithName("done")
		imageView.image = jeremyGif
		siparisIDLabel.text = "Sipariş ID: " + gelenSiparis!.id!
	}
}
