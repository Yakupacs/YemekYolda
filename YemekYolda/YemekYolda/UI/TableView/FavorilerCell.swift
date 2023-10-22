import UIKit

class FavorilerCell: UITableViewCell {
	
	@IBOutlet weak var yemekImageView: UIImageView!
	@IBOutlet weak var yemekAdiLabel: UILabel!
	@IBOutlet weak var yemekFiyatiLabel: UILabel!
	@IBOutlet weak var likeButton: UIButton!
		
	func setup(indexPath: IndexPath, yemek: Yemek){
		if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
			DispatchQueue.main.async {
				self.yemekImageView.kf.setImage(with: url)
			}
		}
		yemekAdiLabel.text = yemek.yemek_adi!
		yemekFiyatiLabel.text = yemek.yemek_fiyat! + "₺"
		
		likeButton.tag = indexPath.row
		likeButton.tintColor = .red
	}
}
