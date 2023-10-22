import UIKit
import RxSwift
import FirebaseFirestore
import FirebaseAuth

class SepetVC: UIViewController {
	
	@IBOutlet weak var view1: UIView!
	@IBOutlet weak var view2: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var sepetTutariLabel: UILabel!
	@IBOutlet weak var kdvLabel: UILabel!
	@IBOutlet weak var teslimatUcretiLabel: UILabel!
	@IBOutlet weak var toplamTutarLabel: UILabel!
	@IBOutlet weak var sepetimHeaderLabel: UILabel!
	@IBOutlet weak var sepetTabBarItem: UITabBarItem!
	@IBOutlet weak var odemeSayfasiButton: UIButton!
	
	var sepettekiYemekler = [SepetYemekler]()
	let imageView = UIImageView(image: UIImage(named: 	"sepetBos"))
	let label = UILabel()
	var toplamTutar = 0
	var siparis = Siparis()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		appearance()
		noneSepet()
		_ = SepetViewModel.shared.sepetYemekler.subscribe(onNext: { list in
			self.sepettekiYemekler = list
			self.tableView.reloadData()
			self.toplamTutarHesaplama()
			self.appearance()
			if (list.count == 0){
				self.imageView.isHidden = false
				self.label.isHidden = false
				self.sepetTabBarItem.badgeValue = nil
			}else{
				self.imageView.isHidden = true
				self.label.isHidden = true
				self.sepetTabBarItem.badgeValue = "\(list.count)"
				self.sepetTabBarItem.badgeColor = UIColor.red
			}
			if (self.sepettekiYemekler.count != 0){
				self.setNotification()
			}
		})
	}
	override func viewWillAppear(_ animated: Bool) {
		sepettekiYemekler = []
		tableView.reloadData()
		self.sepetTabBarItem.badgeValue = nil
		sepetimHeaderLabel.text = "Sepetim (\(sepettekiYemekler.count))"
		
		KullaniciViewModel.shared.kullaniciDoldur()
		SepetViewModel.shared.sepettekiYemekleriYukle(kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
		toplamTutarHesaplama()
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
	@IBAction func odemeSayfasinaGitAction(_ sender: Any) {
		var yemekler = [[String: Int]]()
		for i in sepettekiYemekler{
			yemekler.append([i.yemek_adi!: Int(i.yemek_siparis_adet!)!])
		}
		siparis = Siparis(id: UUID().uuidString, tutar: toplamTutar, teslimEdildi: false, yemekler: yemekler, tarih: Date().formatted())
		appearance()
		performSegue(withIdentifier: "toOdeme", sender: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toOdeme"{
			let destVC = segue.destination as! OdemeYapVC
			destVC.gelenSiparis = siparis
		}
	}
}

// MARK: - FUNCTIONS
extension SepetVC{
	func noneSepet(){
		imageView.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 200, width: 150, height: 150)
		imageView.contentMode = .scaleAspectFit
		view.addSubview(imageView)
		label.frame = CGRect(x: view.frame.size.width / 2 - 125, y: 300, width: 250, height: 150)
		label.text = "Sepetinizde hiç ürün bulunmamaktadır!"
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .black
		label.font = UIFont(name: "Arial", size: 18)
		view.addSubview(label)
	}
	func toplamTutarHesaplama(){
		var sepetTutari = 0
		var kdv = 0
		var teslimatUcreti = 0
		toplamTutar = 0
		for yemek in sepettekiYemekler{
			sepetTutari += Int(yemek.yemek_fiyat!)!
		}
		sepetTutariLabel.text = String(sepetTutari) + "₺"
		kdv = Int(Double(sepetTutari) * 0.2)
		if (sepetTutari >= 100){
			teslimatUcreti = 0
		}else{
			teslimatUcreti = 20
		}
		kdvLabel.text = String(kdv) + "₺"
		teslimatUcretiLabel.text = String(teslimatUcreti) + "₺"
		toplamTutar = sepetTutari + kdv + teslimatUcreti
		toplamTutarLabel.text = String(toplamTutar) + "₺"
		if (sepetTutari == 0){
			odemeSayfasiButton.isEnabled = false
			toplamTutarLabel.text = "0₺"
		}else{
			odemeSayfasiButton.isEnabled = true
		}
	}
	func appearance()
	{
		view2.layer.cornerRadius = 20
		sepetimHeaderLabel.text = "Sepetim (\(sepettekiYemekler.count))"
	}
	@objc func silTarget(_ sender: UIButton){
		if (sepettekiYemekler.count == 1){
			SepetViewModel.shared.sepetteYemekSilme(sepet_yemek_id: sepettekiYemekler[sender.tag].sepet_yemek_id!, 1, kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
		}else{
			SepetViewModel.shared.sepetteYemekSilme(sepet_yemek_id: sepettekiYemekler[sender.tag].sepet_yemek_id!, 0, kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
		}
		SepetViewModel.shared.sepettekiYemekleriYukle(kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
		appearance()
	}
}

// MARK: - TableView
extension SepetVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sepettekiYemekler.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SepetCell
		cell.setup(indexPath: indexPath, yemek: sepettekiYemekler[indexPath.row])
		cell.silButton.tag = indexPath.row
		cell.silButton.addTarget(self, action: #selector(silTarget), for: .touchUpInside)
		return cell
	}
}

// MARK: - Notifications
extension SepetVC: UNUserNotificationCenterDelegate{
	func setNotification(){
		UNUserNotificationCenter.current().delegate = self
		if TabBarControllerYemek.notificationAccess{
			let content = UNMutableNotificationContent()
			content.title = "Sepetinde Ürün Var!"
			content.body = "Sepetinde \(sepettekiYemekler.count) adet ürün kaldı, gel ve alışverişine devam et."
			content.badge = 1
			content.sound = .default
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
			let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
			UNUserNotificationCenter.current().add(request)
		}
	}
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let app = UIApplication.shared
		app.applicationIconBadgeNumber = 0
		completionHandler()
	}
}
