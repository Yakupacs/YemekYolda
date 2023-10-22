import UIKit

class AdreslerCell: UITableViewCell {

	@IBOutlet weak var adresBasligiLabel: UILabel!
	@IBOutlet weak var adresAciklamasiLabel: UILabel!
	@IBOutlet weak var copKutusuButton: UIButton!
	
	func setup(indexPath: IndexPath, adresler: [Adres]){
		adresBasligiLabel.text = adresler[indexPath.row].adresBasligi
		adresAciklamasiLabel.text = adresler[indexPath.row].adresTarifi
	}
}
