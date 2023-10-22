import UIKit
import FirebaseFirestore
import FirebaseAuth

class OdemeYapVC: UIViewController {

	@IBOutlet weak var odemeYontemiLabel: UILabel!
	@IBOutlet weak var adresBilgisiLabel: UILabel!
	
	@IBOutlet weak var odemelerCollectionView: UICollectionView!
	@IBOutlet weak var adreslerimCollectionView: UICollectionView!
	
	@IBOutlet weak var fiyatStackView: UIStackView!
	
	@IBOutlet weak var sozlesmeButton: UIButton!
	@IBOutlet weak var kapiyaBirakButton: UIButton!
	@IBOutlet weak var ziliCalmaButton: UIButton!
	@IBOutlet weak var siparisiTamamlaButton: UIButton!
	
	@IBOutlet weak var tutarLabel: UILabel!
	
	var odemeler = [Odeme]()
	var adresler = [Adres]()
	var gelenSiparis: Siparis?
	
	var kapiyaBirak = true
	var sozlesme = true
	var ziliCalma = true
	
	var seciliAdres: Adres?
	var seciliOdeme: Odeme?
	
	let adresEkleLabel = UILabel()
	let adresEkleButton = UIButton()
	let odemeKayitLabel = UILabel()
	let odemeKayitButton = UIButton()
	
	let siparisViewModel = SiparisViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		firstSetup()
		getOdeme()
		getAdres()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		firstSetup()
		getOdeme()
		getAdres()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toSiparisAlindi"{
			let destVC = segue.destination as! SiparisiTamamlaVC
			destVC.gelenSiparis = gelenSiparis
		}
	}
	
	@IBAction func siparisiTamamlaAction(_ sender: Any) {
		veritabaninaSiparisKaydet(gelenSiparis!)
		
		SepetViewModel.shared.sepetiTemizle(kullaniciAdi: AnasayfaViewModel.shared.yemekRepo.kullaniciNormal.kullaniciAdi!)
		
		performSegue(withIdentifier: "toSiparisAlindi", sender: nil)
	}
	
	
	@IBAction func ziliCalmaAction(_ sender: Any) {
		if ziliCalma == true{
			ziliCalma = false
			ziliCalmaButton.layer.backgroundColor = UIColor(named: "color")?.cgColor
		}else{
			ziliCalma = true
			ziliCalmaButton.layer.backgroundColor = UIColor.white.cgColor
		}
	}
	@IBAction func kapiyaBirakAction(_ sender: Any) {
		if kapiyaBirak == true{
			kapiyaBirak = false
			kapiyaBirakButton.layer.backgroundColor = UIColor(named: "color")?.cgColor
		}else{
			kapiyaBirak = true
			kapiyaBirakButton.layer.backgroundColor = UIColor.white.cgColor
		}
	}
	@IBAction func sozlesmeAction(_ sender: Any) {
		if sozlesme == true{
			sozlesme = false
			sozlesmeButton.layer.backgroundColor = UIColor(named: "color")?.cgColor
		}else{
			sozlesme = true
			sozlesmeButton.layer.backgroundColor = UIColor.white.cgColor
		}
		siparisTamamlaControl()
	}
	
	func siparisTamamlaControl(){
		if sozlesme == false && seciliAdres != nil && seciliOdeme != nil{
			siparisiTamamlaButton.isEnabled = true
		}else{
			siparisiTamamlaButton.isEnabled = false
		}
	}
	
	func firstSetup(){
		seciliAdres = nil
		seciliOdeme = nil
		odemelerCollectionView.delegate = self
		odemelerCollectionView.dataSource = self
		adreslerimCollectionView.dataSource = self
		adreslerimCollectionView.dataSource = self
		fiyatStackView.layer.cornerRadius = 10
		fiyatStackView.layer.borderColor = UIColor(named: "color")!.cgColor
		fiyatStackView.layer.borderWidth = 2
		ziliCalmaButton.layer.cornerRadius = 5
		kapiyaBirakButton.layer.cornerRadius = 5
		sozlesmeButton.layer.cornerRadius = 5
		sozlesmeButton.layer.backgroundColor = UIColor.white.cgColor
		kapiyaBirakButton.layer.backgroundColor = UIColor.white.cgColor
		ziliCalmaButton.layer.backgroundColor = UIColor.white.cgColor
		siparisiTamamlaButton.isEnabled = false
		tutarLabel.text = "₺\(gelenSiparis!.tutar!)"
	}
	
	func veritabaninaSiparisKaydet(_ siparis: Siparis){
		siparisViewModel.siparisKaydet(siparis: siparis)
	}
	
	func getOdeme(){
		let firestore = Firestore.firestore()
		firestore.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).addSnapshotListener { querySnapshot, error in
			if let error = error{
				print("Error: \(error.localizedDescription)")
			}else{
				self.odemeler = []
				for document in querySnapshot!.documents{
					if let adresler = document.get("odemeler") as? [[String: Any]]{
						for adres in adresler{
							let element = Odeme()
							for val in adres{
								if val.key == "kartAdi"{
									element.kartAdi = val.value as? String
								}else if val.key == "kartNumarasi"{
									element.kartNumarasi = val.value as? String
								}else if val.key == "kartCVV"{
									element.kartCVV = val.value as? String
								}else if val.key == "id"{
									element.id = val.value as? String
								}
							}
							self.odemeler.append(element)
						}
					}
				}
				self.odemeYontemiLabel.text = "Ödeme Yöntemi (\(self.odemeler.count))"
				self.odemelerCollectionView.reloadData()
				if self.odemeler.count == 0{
					self.odemeYok()
					self.odemeKayitLabel.isHidden = false
					self.odemeKayitButton.isHidden = false
				}else{
					self.odemeKayitLabel.isHidden = true
					self.odemeKayitButton.isHidden = true
				}
			}
		}
	}
	func getAdres(){
		let firestore = Firestore.firestore()
		firestore.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).addSnapshotListener { querySnapshot, error in
			if let error = error{
				print("Error: \(error.localizedDescription)")
			}else{
				self.adresler = []
				for document in querySnapshot!.documents{
					if let adresler = document.get("adresler") as? [[String: Any]]{
						for adres in adresler{
							let element = Adres()
							for val in adres{
								if val.key == "adresBasligi"{
									element.adresBasligi = val.value as? String
								}else if val.key == "adresTarifi"{
									element.adresTarifi = val.value as? String
								}else if val.key == "binaNo"{
									element.binaNo = val.value as? String
								}else if val.key == "daireNo"{
									element.daireNo = val.value as? String
								}else if val.key == "kat"{
									element.kat = val.value as? String
								}else if val.key == "mahalle"{
									element.mahalle = val.value as? String
								}else if val.key == "id"{
									element.id = val.value as? String
								}
							}
							self.adresler.append(element)
						}
					}
				}
				self.adresBilgisiLabel.text = "Adres Bilgisi (\(self.adresler.count))"
				self.adreslerimCollectionView.reloadData()
				if self.adresler.count == 0{
					self.adresYok()
					self.adresEkleLabel.isHidden = false
					self.adresEkleButton.isHidden = false
				}else{
					self.adresEkleLabel.isHidden = true
					self.adresEkleButton.isHidden = true
				}
			}
		}
	}
	func adresYok(){
		view.addSubview(adresEkleLabel)
		adresEkleLabel.text = "Adres bilginiz kayıtlı değil"
		adresEkleLabel.textAlignment = .center
		adresEkleLabel.font = UIFont(name: "System", size: 22)
		adresEkleLabel.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			adresEkleLabel.topAnchor.constraint(equalTo: adresBilgisiLabel.bottomAnchor, constant: 40),
			adresEkleLabel.heightAnchor.constraint(equalToConstant: 50),
			adresEkleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]
		NSLayoutConstraint.activate(constraints)
		
		view.addSubview(adresEkleButton)
		adresEkleButton.setTitle("Adres Bilgisi Ekle", for: .normal)
		adresEkleButton.backgroundColor = UIColor.tintColor
		adresEkleButton.setTitleColor(.white, for: .normal)
		adresEkleButton.layer.cornerRadius = 10
		adresEkleButton.translatesAutoresizingMaskIntoConstraints = false
		let constraintsButton = [
			adresEkleButton.topAnchor.constraint(equalTo: adresEkleLabel.bottomAnchor),
			adresEkleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			adresEkleButton.heightAnchor.constraint(equalToConstant: 40),
			adresEkleButton.widthAnchor.constraint(equalToConstant: 200)
		]
		NSLayoutConstraint.activate(constraintsButton)
		adresEkleButton.addTarget(self, action: #selector(toAdres), for: .touchUpInside)
	}
	func odemeYok(){
		view.addSubview(odemeKayitLabel)
		odemeKayitLabel.text = "Ödeme yönteminiz kayıtlı değil"
		odemeKayitLabel.textAlignment = .center
		odemeKayitLabel.font = UIFont(name: "System", size: 22)
		odemeKayitLabel.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			odemeKayitLabel.topAnchor.constraint(equalTo: odemeYontemiLabel.bottomAnchor, constant: 40),
			odemeKayitLabel.heightAnchor.constraint(equalToConstant: 50),
			odemeKayitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]
		NSLayoutConstraint.activate(constraints)
		
		view.addSubview(odemeKayitButton)
		odemeKayitButton.setTitle("Ödeme Yöntemi Ekle", for: .normal)
		odemeKayitButton.backgroundColor = UIColor.tintColor
		odemeKayitButton.setTitleColor(.white, for: .normal)
		odemeKayitButton.layer.cornerRadius = 10
		odemeKayitButton.translatesAutoresizingMaskIntoConstraints = false
		let constraintsButton = [
			odemeKayitButton.topAnchor.constraint(equalTo: odemeKayitLabel.bottomAnchor),
			odemeKayitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			odemeKayitButton.heightAnchor.constraint(equalToConstant: 40),
			odemeKayitButton.widthAnchor.constraint(equalToConstant: 200)
		]
		NSLayoutConstraint.activate(constraintsButton)
		odemeKayitButton.addTarget(self, action: #selector(toOdeme), for: .touchUpInside)
	}
	@objc func toAdres(){
		performSegue(withIdentifier: "adresEkle", sender: nil)
	}
	@objc func toOdeme(){
		performSegue(withIdentifier: "odemeEkle", sender: nil)
	}
	@IBAction func returnAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
	@objc func adresSec(_ sender: UIButton){
		seciliAdres = adresler[sender.tag]
		adreslerimCollectionView.reloadData()
		siparisTamamlaControl()
	}
	@objc func odemeSec(_ sender: UIButton){
		seciliOdeme = odemeler[sender.tag]
		odemelerCollectionView.reloadData()
		siparisTamamlaControl()
	}
}

extension OdemeYapVC: UICollectionViewDelegate, UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch collectionView {
		case adreslerimCollectionView:
			return adresler.count
		case odemelerCollectionView:
			return odemeler.count
		default:
			return 0
		}
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch collectionView {
		case adreslerimCollectionView:
			let cell = adreslerimCollectionView.dequeueReusableCell(withReuseIdentifier: "adres", for: indexPath) as! OdemeAdresCell
			cell.setup(indexPath: indexPath, gelenAdresler: adresler)
			cell.secButton.addTarget(self, action: #selector(adresSec), for: .touchUpInside)
			if seciliAdres != nil{
				if seciliAdres?.id == adresler[indexPath.row].id{
					cell.secButton.setTitle("Seçildi", for: .normal)
					cell.secButton.setTitleColor(.systemGray2, for: .normal)
				}else{
					cell.secButton.setTitle("Seç", for: .normal)
					cell.secButton.setTitleColor(.white, for: .normal)
				}
			}
			return cell
		case odemelerCollectionView:
			let cell = odemelerCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OdemeEkraniCell
			cell.setup(indexPath: indexPath, gelenOdemeler: odemeler)
			cell.secButton.addTarget(self, action: #selector(odemeSec), for: .touchUpInside)
			if seciliOdeme != nil{
				if seciliOdeme?.kartNumarasi == odemeler[indexPath.row].kartNumarasi{
					cell.secButton.setTitle("Seçildi", for: .normal)
					cell.secButton.setTitleColor(.systemGray2, for: .normal)
				}else{
					cell.secButton.setTitle("Seç", for: .normal)
					cell.secButton.setTitleColor(.white, for: .normal)
				}
			}
			return cell
		default:
			return UICollectionViewCell()
		}
	}
}
