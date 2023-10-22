import Foundation

class Siparis{
	var id: String?
	var tutar: Int?
	var teslimEdildi: Bool = false
	var yemekler: [[String: Int]]?
	var tarih: String?
	
	init() { }
	
	init(id: String, tutar: Int, teslimEdildi: Bool, yemekler: [[String : Int]], tarih: String) {
		self.id = id
		self.tutar = tutar
		self.teslimEdildi = teslimEdildi
		self.yemekler = yemekler
		self.tarih = tarih
	}
}
