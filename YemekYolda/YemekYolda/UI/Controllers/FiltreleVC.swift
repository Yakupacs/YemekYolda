import UIKit

class FiltreleVC: UIViewController {

	@IBOutlet weak var varsayilanButton: UIButton!
	@IBOutlet weak var aDanZYeButton: UIButton!
	@IBOutlet weak var fiyatAzalanButton: UIButton!
	@IBOutlet weak var fiyatArtanButton: UIButton!
	@IBOutlet weak var zDenAYaButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appearance()
		if (AnasayfaViewModel.shared.yemekRepo.filterType == .ADANZYE){
			aDanZYe()
		}else if (AnasayfaViewModel.shared.yemekRepo.filterType == .VARSAYILAN){
			varsayilan()
		}else if (AnasayfaViewModel.shared.yemekRepo.filterType == .ARTANFIYAT){
			artanFiyat()
		}else if (AnasayfaViewModel.shared.yemekRepo.filterType == .AZALANFIYAT){
			azalanFiyat()
		}else if (AnasayfaViewModel.shared.yemekRepo.filterType == .ZDENAYA){
			zDenAYa()
		}
	}
}

// MARK: - ACTIONS
extension FiltreleVC{
	@IBAction func fiyatArtanAction(_ sender: Any) {
		artanFiyat()
		AnasayfaViewModel.shared.filter(filter: FilterType.ARTANFIYAT)
	}
	@IBAction func fiyatAzalanAction(_ sender: Any) {
		azalanFiyat()
		AnasayfaViewModel.shared.filter(filter: FilterType.AZALANFIYAT)
	}
	@IBAction func ZdenAYaAction(_ sender: Any) {
		zDenAYa()
		AnasayfaViewModel.shared.filter(filter: FilterType.ZDENAYA)
	}
	@IBAction func aDanZYeAction(_ sender: Any) {
		aDanZYe()
		AnasayfaViewModel.shared.filter(filter: FilterType.ADANZYE)
	}
	@IBAction func varsayilanAction(_ sender: Any) {
		varsayilan()
		AnasayfaViewModel.shared.filter(filter: FilterType.VARSAYILAN)
	}
	@IBAction func closeAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
}

// MARK: - APPEARANCE
extension FiltreleVC{
	func appearance(){
		fiyatArtanButton.layer.borderWidth = 1.5
		fiyatAzalanButton.layer.borderWidth = 1.5
		aDanZYeButton.layer.borderWidth = 1.5
		varsayilanButton.layer.borderWidth = 1.5
		zDenAYaButton.layer.borderWidth = 1.5
		fiyatArtanButton.layer.cornerRadius = 7
		fiyatAzalanButton.layer.cornerRadius = 7
		aDanZYeButton.layer.cornerRadius = 7
		varsayilanButton.layer.cornerRadius = 7
		zDenAYaButton.layer.cornerRadius = 7
		fiyatArtanButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		fiyatAzalanButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		aDanZYeButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		varsayilanButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		zDenAYaButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	}
	func aDanZYe(){
		fiyatArtanButton.layer.borderColor = UIColor.lightGray.cgColor
		fiyatAzalanButton.layer.borderColor = UIColor.lightGray.cgColor
		aDanZYeButton.layer.borderColor = UIColor.black.cgColor
		varsayilanButton.layer.borderColor = UIColor.lightGray.cgColor
		zDenAYaButton.layer.borderColor = UIColor.lightGray.cgColor
	}
	func varsayilan(){
		fiyatArtanButton.layer.borderColor = UIColor.lightGray.cgColor
		fiyatAzalanButton.layer.borderColor = UIColor.lightGray.cgColor
		aDanZYeButton.layer.borderColor = UIColor.lightGray.cgColor
		varsayilanButton.layer.borderColor = UIColor.black.cgColor
		zDenAYaButton.layer.borderColor = UIColor.lightGray.cgColor
	}
	func artanFiyat(){
		fiyatArtanButton.layer.borderColor = UIColor.black.cgColor
		fiyatAzalanButton.layer.borderColor = UIColor.lightGray.cgColor
		aDanZYeButton.layer.borderColor = UIColor.lightGray.cgColor
		varsayilanButton.layer.borderColor = UIColor.lightGray.cgColor
		zDenAYaButton.layer.borderColor = UIColor.lightGray.cgColor
	}
	func azalanFiyat(){
		fiyatArtanButton.layer.borderColor = UIColor.lightGray.cgColor
		fiyatAzalanButton.layer.borderColor = UIColor.black.cgColor
		aDanZYeButton.layer.borderColor = UIColor.lightGray.cgColor
		varsayilanButton.layer.borderColor = UIColor.lightGray.cgColor
		zDenAYaButton.layer.borderColor = UIColor.lightGray.cgColor
	}
	func zDenAYa(){
		fiyatArtanButton.layer.borderColor = UIColor.lightGray.cgColor
		fiyatAzalanButton.layer.borderColor = UIColor.lightGray.cgColor
		aDanZYeButton.layer.borderColor = UIColor.lightGray.cgColor
		varsayilanButton.layer.borderColor = UIColor.lightGray.cgColor
		zDenAYaButton.layer.borderColor = UIColor.black.cgColor
	}
}
