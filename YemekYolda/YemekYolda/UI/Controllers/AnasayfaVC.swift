import UIKit
import FirebaseFirestore
import FirebaseAuth

class AnasayfaVC: UIViewController{
	
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var filterButton: UIButton!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var hosgeldinLabel: UILabel!
	
	var yemeklerListesi = [Yemek]()
	var sepettekiYemekler = [SepetYemekler]()
	var favoriYemekler = [Yemek]()
	var secilenYemek = Yemek()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		accessNotification()
		
		_ = AnasayfaViewModel.shared.yemekRepo.kullanici.subscribe(onNext: { kullanici in
			self.kullaniciGeldi(kullanici: kullanici)
		})
		_ = AnasayfaViewModel.shared.yemekler.subscribe(onNext: { liste in
			self.yemeklerListesi = liste
			self.tableView.reloadData()
		})
	}
	override func viewWillAppear(_ animated: Bool) {
		favoriFirebaseSnapshot()
		appearance()
		AnasayfaViewModel.shared.yemekleriYukle()
		AnasayfaViewModel.shared.yemekRepo.kullaniciDoldur()
	}
}

// MARK: - FUNCTIONS
extension AnasayfaVC{
	@objc func favAction(_ sender: UIButton){
		var sign = false
		for i in favoriYemekler{
			if (i.yemek_adi == yemeklerListesi[sender.tag].yemek_adi){
				sign = true
			}
		}
		if sign == true{
			FavoriViewModel.shared.favoriSil(yemek: yemeklerListesi[sender.tag])
		}else{
			FavoriViewModel.shared.favoriEkle(yemek: yemeklerListesi[sender.tag])
		}
	}
	func accessNotification(){
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			TabBarControllerYemek.notificationAccess = granted
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toDetails"{
			let destVC = segue.destination as! YemekDetayVC
			destVC.secilenYemek = secilenYemek
		}
	}
	func kullaniciGeldi(kullanici: Kullanici){
		if let image = kullanici.image{
			if let url = URL(string: "\(image)") {
				DispatchQueue.main.async {
					self.userImageView.kf.setImage(with: url)
				}
			}
		}
		if let ad = kullanici.ad{
			self.hosgeldinLabel.text = "Hoş geldin \(ad)"
		}else{
			self.hosgeldinLabel.text = ""
		}
	}
	func favoriFirebaseSnapshot(){
		let firestore = Firestore.firestore()
		firestore.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).addSnapshotListener { querySnapshot, error in
			if let error = error{
				print("Error: \(error.localizedDescription)")
			}else{
				self.favoriYemekler = []
				for document in querySnapshot!.documents{
					if let adresler = document.get("favoriler") as? [[String: Any]]{
						for adres in adresler{
							let element = Yemek()
							for val in adres{
								if val.key == "yemek_id"{
									element.yemek_id = val.value as? String
								}else if val.key == "yemek_adi"{
									element.yemek_adi = val.value as? String
								}else if val.key == "yemek_resim_adi"{
									element.yemek_resim_adi = val.value as? String
								}else if val.key == "yemek_fiyat"{
									element.yemek_fiyat = val.value as? String
								}
							}
							self.favoriYemekler.append(element)
						}
					}
					
				}
				self.tableView.reloadData()
			}
		}
	}
}

// MARK: - SearchBar
extension AnasayfaVC: UISearchBarDelegate{
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		AnasayfaViewModel.shared.yemekAra(searchText: searchText)
	}
}

// MARK: - TableView
extension AnasayfaVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return yemeklerListesi.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var sign = false
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomepageCell
		cell.setup(indexPath: indexPath, yemek: yemeklerListesi[indexPath.row])
		cell.favButton.addTarget(self, action: #selector(favAction), for: .touchUpInside)
		cell.favButton.tag = indexPath.row
		
		for yemek in favoriYemekler{
			if (yemek.yemek_adi == yemeklerListesi[indexPath.row].yemek_adi){
				sign = true
			}
		}
		if sign == true{
			cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
		}else{
			cell.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
		}
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		secilenYemek = yemeklerListesi[indexPath.row]
		performSegue(withIdentifier: "toDetails", sender: nil)
	}
}

// MARK: - Appearance
extension AnasayfaVC{
	func appearance(){
		searchBar.delegate = self
		tableView.delegate = self
		tableView.dataSource = self
		
		userImageView.layer.cornerRadius = 25
		userImageView.layer.borderWidth = 1
		userImageView.layer.borderColor = UIColor.black.cgColor
		filterButton.layer.cornerRadius = 20
		searchBar.searchTextField.leftView?.tintColor = UIColor(named: "searchBarPlaceholder")
		searchBar.searchTextField.backgroundColor = UIColor(named: "searchBarBackground")
		if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
			searchTextField.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				searchTextField.heightAnchor.constraint(equalToConstant: 60),
				searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 0),
				searchTextField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 0),
				searchTextField.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor, constant: 0)
			])
			searchTextField.clipsToBounds = true
			searchTextField.layer.cornerRadius = 20.0
		}
		if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
			
			textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "searchBarPlaceholder")!])
		}
	}
}
