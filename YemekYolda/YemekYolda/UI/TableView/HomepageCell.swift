import UIKit
import Kingfisher

class HomepageCell: UITableViewCell {
	
	@IBOutlet weak var yemekImageView: UIImageView!
	@IBOutlet weak var yemekAdiLabel: UILabel!
	@IBOutlet weak var yemekAciklamasiLabel: UILabel!
	@IBOutlet weak var puanSureLabel: UILabel!
	@IBOutlet weak var favButton: UIButton!
	@IBOutlet weak var myView: UIView!
	@IBOutlet weak var fiyatLabel: UILabel!
	
	var liked = false
	
	func setup(indexPath: IndexPath, yemek: Yemek){
		if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
			DispatchQueue.main.async {
				self.yemekImageView.kf.setImage(with: url)
			}
		}

		yemekImageView.layer.shadowColor = UIColor.gray.cgColor
		yemekImageView.layer.shadowOpacity = 0.7
		yemekImageView.layer.shadowRadius = 10
		
		yemekAdiLabel.text = yemek.yemek_adi
		fiyatLabel.text = yemek.yemek_fiyat! + "₺"
		yemekAciklamasiLabel.text = "100₺ ve üzeri alışverişe kargo ücretsiz."
		puanSureLabel.text = "⭐ 4.5   🕛 20 dakika"
		
		favButton.tag = indexPath.row
		favButton.tintColor = .red
		
		myView.layer.cornerRadius = 40
		myView.backgroundColor = UIColor(named: "searchBarBackground")
		let maskPath = UIBezierPath(roundedRect: fiyatLabel.bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: 40, height: 40))
		
		let maskLayer = CAShapeLayer()
		maskLayer.path = maskPath.cgPath
		fiyatLabel.layer.mask = maskLayer
	}
}
