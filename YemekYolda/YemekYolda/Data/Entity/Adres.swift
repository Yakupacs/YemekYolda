import Foundation

class Adres{
	var id: String?
	var adresBasligi: String?
	var adresTarifi: String?
	var binaNo: String?
	var daireNo: String?
	var kat: String?
	var mahalle: String?
	
	init(){ }
	
	init(adresBasligi: String, adresTarifi: String, binaNo: String, daireNo: String, kat: String, mahalle: String) {
		self.adresBasligi = adresBasligi
		self.adresTarifi = adresTarifi
		self.binaNo = binaNo
		self.daireNo = daireNo
		self.kat = kat
		self.mahalle = mahalle
	}
}
