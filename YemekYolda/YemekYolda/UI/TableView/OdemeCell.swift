import UIKit

class OdemeCell: UITableViewCell {

	@IBOutlet weak var kartAdiLabel: UILabel!
	@IBOutlet weak var kartNumarasiLabel: UILabel!
	
	func setup(indexPath: IndexPath, odemeler: [Odeme]){
		kartAdiLabel.text = odemeler[indexPath.row].kartAdi!
		kartNumarasiLabel.text = odemeler[indexPath.row].kartNumarasi!
	}
}
