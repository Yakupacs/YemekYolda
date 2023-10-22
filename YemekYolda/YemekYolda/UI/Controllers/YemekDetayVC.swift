import UIKit
import RxSwift

class YemekDetayVC: UIViewController {
	
	@IBOutlet weak var sepetViewBackground: UIView!
	@IBOutlet weak var yemekImage: UIImageView!
	@IBOutlet weak var yemekSirketiPuaniLabel: UILabel!
	@IBOutlet weak var yemekFiyatiLabel: UILabel!
	@IBOutlet weak var yemekAdiLabel: UILabel!
	@IBOutlet weak var yemekAciklamasiLabel: UILabel!
	@IBOutlet weak var yemekSiparisSuresiLabel: UILabel!
	@IBOutlet weak var yemekSepetAdediLabel: UILabel!
	@IBOutlet weak var sepeteEkleButton: UIButton!
	@IBOutlet weak var sepetArtirButton: UIButton!
	@IBOutlet weak var sepetEksiltButton: UIButton!
	
	var secilenYemek = Yemek()
	var sepetMiktari = 0
	var sepettekiYemeklerim = [SepetYemekler]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
		
		_ = SepetViewModel.shared.sepetYemekler.subscribe(onNext: { list in
			self.sepettekiYemeklerim = list
		})
	}
	override func viewWillAppear(_ animated: Bool) {
		KullaniciViewModel.shared.kullaniciDoldur()
		SepetViewModel.shared.sepettekiYemekleriYukle(kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
	}
}
// MARK: - ACTIONS
extension YemekDetayVC {
	@IBAction func sepeteEkleAction(_ sender: Any) {
		if sepetMiktari != 0{
			let oncekiAdet = deepControl()
			var toplamFiyat = 0
			for _ in 1...sepetMiktari{
				toplamFiyat += Int(secilenYemek.yemek_fiyat!)!
			}
			toplamFiyat += oncekiAdet * Int(secilenYemek.yemek_fiyat!)!
			SepetViewModel.shared.sepeteYemekEkle(
				yemekAdi: secilenYemek.yemek_adi!,
				yemekResimAdi: secilenYemek.yemek_resim_adi!,
				yemekFiyat: String(toplamFiyat),
				yemekSiparisAdet: sepetMiktari + oncekiAdet,
				kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
			self.dismiss(animated: true)
		}
	}
	@IBAction func azaltAction(_ sender: Any) {
		if (sepetMiktari > 0){
			sepetMiktari -= 1
			yemekSepetAdediLabel.text = String(sepetMiktari)
		}
	}
	@IBAction func artirAction(_ sender: Any) {
		sepetMiktari += 1
		yemekSepetAdediLabel.text = String(sepetMiktari)
	}
}

// MARK: - FUNCTIONS
extension YemekDetayVC {
	func deepControl() -> Int{
		for yemek in sepettekiYemeklerim{
			if yemek.yemek_adi == secilenYemek.yemek_adi{
				print("Eşleşti!")
				let adet = Int(yemek.yemek_siparis_adet!)!
				SepetViewModel.shared.sepetteYemekSilme(sepet_yemek_id: yemek.sepet_yemek_id!, 0, kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
				return adet
			}
		}
		return (0)
	}
	func configure(){
		if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(secilenYemek.yemek_resim_adi!)") {
			DispatchQueue.main.async {
				self.yemekImage.kf.setImage(with: url)
			}
		}
		yemekFiyatiLabel.text = secilenYemek.yemek_fiyat! + "₺"
		yemekAdiLabel.text = secilenYemek.yemek_adi
	}
}
