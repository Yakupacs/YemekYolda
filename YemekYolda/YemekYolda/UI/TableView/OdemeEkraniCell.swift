import UIKit

class OdemeEkraniCell: UICollectionViewCell {
    
	@IBOutlet weak var kartAdiLabel: UILabel!
	@IBOutlet weak var kartNumarasiLabel: UILabel!
	@IBOutlet weak var secButton: UIButton!
	
	func setup(indexPath: IndexPath, gelenOdemeler: [Odeme]){
		kartAdiLabel.text = gelenOdemeler[indexPath.row].kartAdi
		kartNumarasiLabel.text = gelenOdemeler[indexPath.row].kartNumarasi
		secButton.tag = indexPath.row
		layer.borderColor = UIColor.systemGray4.cgColor
		layer.borderWidth = 1
		layer.cornerRadius = 15
	}
}
