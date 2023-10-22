import Foundation

class Odeme{
	var id: String?
	var kartAdi: String?
	var kartNumarasi: String?
	var kartCVV: String?
	
	init(){
		
	}
	
	init(id: String,kartAdi: String, kartNumarasi: String, kartCVV: String) {
		self.id = id
		self.kartAdi = kartAdi
		self.kartNumarasi = kartNumarasi
		self.kartCVV = kartCVV
	}
}
