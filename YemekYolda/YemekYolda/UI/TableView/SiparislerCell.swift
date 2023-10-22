import UIKit

class SiparislerCell: UITableViewCell {
	
	@IBOutlet weak var shopImageView: UIImageView!
	@IBOutlet weak var tarihLabel: UILabel!
	@IBOutlet weak var icerikLabel: UILabel!
	@IBOutlet weak var teslimImageView: UIImageView!
	@IBOutlet weak var teslimLabel: UILabel!
	@IBOutlet weak var tutarLabel: UILabel!
	
	func setup(indexPath: IndexPath, siparisler: [Siparis]){
		let siparis = siparisler[indexPath.row]

		tarihLabel.text = siparis.tarih!
		var siparisText = ""
		for siparisYemek in siparis.yemekler!{
			for (key,value) in siparisYemek{
				siparisText.append("\(value) adet \(key) ")
			}
		}
		icerikLabel.text = siparisText
		
		if (siparis.teslimEdildi == true){
			teslimLabel.text = "Teslim Edildi"
			teslimImageView.image = UIImage(systemName: "checkmark")
			teslimImageView.tintColor = UIColor.green
		}else{
			teslimLabel.text = "Hazırlanıyor"
			teslimImageView.image = UIImage(systemName: "xmark")
			teslimImageView.tintColor = UIColor.red
		}
		
		tutarLabel.text = (String(siparis.tutar!)) + "₺"
	}
}
