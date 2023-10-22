import UIKit
import FirebaseFirestore
import FirebaseAuth

class AdreslerVC: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var tumAdresler = [Adres]()
	var secilenAdres = Adres()
	let imageView = UIImageView(image: UIImage(named: "adresYok"))
	let label = UILabel()
	var adresViewControl = AdresViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		imageView.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 300, width: 150, height: 150)
		imageView.contentMode = .scaleAspectFit
		label.frame = CGRect(x: view.frame.size.width / 2 - 125, y: 425, width: 250, height: 150)
		label.text = "Kayıtlı hiçbir adres bilginiz bulunmamaktadır."
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .black
		label.isHidden = true
		label.font = UIFont(name: "Arial", size: 18)
		imageView.isHidden = true
		view.addSubview(imageView)
		view.addSubview(label)
		
		adresSnapshot()
	}
	func adresSnapshot(){
		let firestore = Firestore.firestore()
		firestore.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).addSnapshotListener { querySnapshot, error in
			if let error = error{
				print("Error: \(error.localizedDescription)")
			}else{
				self.tumAdresler = []
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
							self.tumAdresler.append(element)
						}
					}
					
				}
				self.adresYoksaKontrol()
				self.tableView.reloadData()
			}
		}
	}
	func adresYoksaKontrol(){
		if tumAdresler.isEmpty == true{
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
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toUpdate"{
			let destVC = segue.destination as! AdresGuncelleVC
			destVC.gelenAdres = secilenAdres
		}
	}
	@objc func deleteAction(_ sender: UIButton){
		if let adresID = self.tumAdresler[sender.tag].id {
			adresViewControl.adresSil(adresID: adresID)
		}
	}
}

extension AdreslerVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tumAdresler.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdreslerCell
		cell.setup(indexPath: indexPath, adresler: tumAdresler)
		cell.copKutusuButton.tag = indexPath.row
		cell.copKutusuButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		secilenAdres = tumAdresler[indexPath.row]
		performSegue(withIdentifier: "toUpdate", sender: nil)
	}
}
