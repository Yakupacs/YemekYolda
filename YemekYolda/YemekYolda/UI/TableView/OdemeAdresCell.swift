import UIKit

class OdemeAdresCell: UICollectionViewCell {
	@IBOutlet weak var adresAdi: UILabel!
	@IBOutlet weak var adresAciklama: UILabel!
	@IBOutlet weak var secButton: UIButton!
	
	func setup(indexPath: IndexPath, gelenAdresler: [Adres]){
		adresAdi.text = gelenAdresler[indexPath.row].adresBasligi
		adresAciklama.text = gelenAdresler[indexPath.row].adresTarifi
		secButton.tag = indexPath.row
		layer.borderColor = UIColor.systemGray4.cgColor
		layer.borderWidth = 1
		layer.cornerRadius = 15
	}
}
