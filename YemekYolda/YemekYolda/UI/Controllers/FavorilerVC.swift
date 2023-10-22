import UIKit
import FirebaseFirestore
import FirebaseAuth

class FavorilerVC: UIViewController {

	@IBOutlet weak var favorilerLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	var selectedYemek = Yemek()
	var tumFavoriler = [Yemek]()
	
	let imageView = UIImageView(image: UIImage(named: "burger"))
	let label = UILabel()
	
	let favoriViewModel = FavoriViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		imageView.frame = CGRect(x: view.frame.size.width / 2 - 75, y: 300, width: 150, height: 150)
		imageView.contentMode = .scaleAspectFit
		label.frame = CGRect(x: view.frame.size.width / 2 - 125, y: 425, width: 250, height: 150)
		label.text = "Henüz hiçbir favori yemeğiniz bulunmamaktadır."
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .black
		label.isHidden = true
		label.font = UIFont(name: "Arial", size: 18)
		imageView.isHidden = true
		view.addSubview(imageView)
		view.addSubview(label)
		
		firebaseSnapshot()
    }
	override func viewWillAppear(_ animated: Bool) {
		favoriYoksaKontrol()
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toDetail"{
			let destVC = segue.destination as! YemekDetayVC
			destVC.secilenYemek = selectedYemek
		}
	}
	@objc func removeLike(_ sender: UIButton){
		favoriViewModel.favoriSil(yemek: tumFavoriler[sender.tag])
		tumFavoriler.remove(at: sender.tag)
		tableView.reloadData()
	}
	func favoriYoksaKontrol(){
		if tumFavoriler.isEmpty == true{
			label.isHidden = false
			imageView.isHidden = false
		}else{
			label.isHidden = true
			imageView.isHidden = true
		}
	}
	func firebaseSnapshot(){
		let firestore = Firestore.firestore()
		firestore.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).addSnapshotListener { querySnapshot, error in
			if let error = error{
				print("Error: \(error.localizedDescription)")
			}else{
				self.tumFavoriler = []
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
							self.tumFavoriler.append(element)
						}
					}
					
				}
				self.favoriYoksaKontrol()
				self.tableView.reloadData()
			}
		}
	}
}

extension FavorilerVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tumFavoriler.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavorilerCell
		cell.setup(indexPath: indexPath, yemek: tumFavoriler[indexPath.row])
		cell.likeButton.addTarget(self, action: #selector(removeLike), for: .touchUpInside)
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedYemek = tumFavoriler[indexPath.row]
		performSegue(withIdentifier: "toDetail", sender: nil)
	}
}
