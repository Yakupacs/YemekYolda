import UIKit
import FirebaseAuth
import FirebaseFirestore

class SiparislerimVC: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var tumSiparisler = [Siparis]()
	let imageView = UIImageView(image: UIImage(named: "sepet2"))
	let label = UILabel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		imageView.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 300, width: 150, height: 150)
		imageView.contentMode = .scaleAspectFit
		label.frame = CGRect(x: view.frame.size.width / 2 - 125, y: 425, width: 250, height: 150)
		label.text = "Kayıtlı hiçbir sipariş bilginiz bulunmamaktadır."
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .black
		label.isHidden = true
		label.font = UIFont(name: "Arial", size: 18)
		imageView.isHidden = true
		view.addSubview(imageView)
		view.addSubview(label)
		
		siparisVerileri()
    }
	
	func siparisVerileri(){
		let firestore = Firestore.firestore()
		firestore.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).addSnapshotListener { querySnapshot, error in
			if let error = error{
				print("Error: \(error.localizedDescription)")
			}else{
				self.tumSiparisler = []
				for document in querySnapshot!.documents{
					if let adresler = document.get("siparisler") as? [[String: Any]]{
						for adres in adresler{
							let element = Siparis()
							for val in adres{
								if val.key == "id"{
									element.id = val.value as? String
								}else if val.key == "tarih"{
									element.tarih = val.value as? String
								}else if val.key == "teslimEdildi"{
									element.teslimEdildi = val.value as! Bool
								}else if val.key == "tutar"{
									element.tutar = val.value as? Int
								}else if val.key == "yemekler"{
									element.yemekler = val.value as? [[String: Int]]
								}
							}
							self.tumSiparisler.append(element)
						}
					}
					
				}
				self.siparisYoksaKontrol()
				self.tableView.reloadData()
			}
		}
	}
	func siparisYoksaKontrol(){
		if tumSiparisler.isEmpty == true{
			label.isHidden = false
			imageView.isHidden = false
		}else{
			label.isHidden = true
			imageView.isHidden = true
		}
	}

	@IBAction func closeAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
}

extension SiparislerimVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tumSiparisler.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SiparislerCell
		cell.setup(indexPath: indexPath, siparisler: tumSiparisler)
		return cell
	}
}
