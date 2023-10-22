import UIKit

class SepetCell: UITableViewCell {
	
	@IBOutlet weak var yemekImageView: UIImageView!
	@IBOutlet weak var yemekAdiLabel: UILabel!
	@IBOutlet weak var sepetMiktariLabel: UILabel!
	@IBOutlet weak var yemekFiyatiLabel: UILabel!
	@IBOutlet weak var artirButton: UIButton!
	@IBOutlet weak var azaltButton: UIButton!
	@IBOutlet weak var myView: UIView!
	@IBOutlet weak var silButton: UIButton!
	
	func setup(indexPath: IndexPath, yemek: SepetYemekler){
		if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
			DispatchQueue.main.async {
				self.yemekImageView.kf.setImage(with: url)
			}
		}
		yemekAdiLabel.text = yemek.yemek_adi
		yemekFiyatiLabel.text = yemek.yemek_fiyat! + "₺"
		
		myView.layer.cornerRadius = 40
		myView.backgroundColor = UIColor(named: "searchBarBackground")
		
		sepetMiktariLabel.text = "\(yemek.yemek_siparis_adet!) adet"
	}
}
