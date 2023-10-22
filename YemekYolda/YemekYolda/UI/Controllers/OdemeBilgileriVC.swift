import UIKit
import FirebaseFirestore
import FirebaseAuth

class OdemeBilgileriVC: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var tumOdemeler = [Odeme]()
	let imageView = UIImageView(image: UIImage(named: "cards"))
	let label = UILabel()
	var odemeViewModel = OdemeViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		imageView.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 300, width: 150, height: 150)
		imageView.contentMode = .scaleAspectFit
		label.frame = CGRect(x: view.frame.size.width / 2 - 125, y: 425, width: 250, height: 150)
		label.text = "Kayıtlı hiçbir ödeme bilginiz bulunmamaktadır."
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .black
		label.isHidden = true
		label.font = UIFont(name: "Arial", size: 18)
		imageView.isHidden = true
		view.addSubview(imageView)
		view.addSubview(label)
		
		getData()
    }
	@IBAction func closeAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	func getData(){
		let firestore = Firestore.firestore()
		firestore.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).addSnapshotListener { querySnapshot, error in
			if let error = error{
				print("Error: \(error.localizedDescription)")
			}else{
				self.tumOdemeler = []
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
							self.tumOdemeler.append(element)
						}
					}
					
				}
				self.odemeYoksaKontrol()
				self.tableView.reloadData()
			}
		}
	}
	func odemeYoksaKontrol(){
		if tumOdemeler.isEmpty == true{
			label.isHidden = false
			imageView.isHidden = false
		}else{
			label.isHidden = true
			imageView.isHidden = true
		}
	}
	func delete(indexPath: IndexPath){
		if let odemeID = self.tumOdemeler[indexPath.row].id {
			odemeViewModel.odemeSil(odemeID: odemeID)
		}
	}
}

extension OdemeBilgileriVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tumOdemeler.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OdemeCell
		cell.setup(indexPath: indexPath, odemeler: tumOdemeler)
		return cell
	}
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let content = UIContextualAction(style: .destructive, title: "Sil") { context, view, bool in
			self.delete(indexPath: indexPath)
		}
		let swipe = UISwipeActionsConfiguration(actions: [content])
		return swipe
	}
}
