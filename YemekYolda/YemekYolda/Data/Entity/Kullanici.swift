import Foundation
import UIKit

class Kullanici
{
	var ad : String?
	var kullaniciAdi : String?
	var mail : String?
	private var sifre : String?
	var image : String?
	var kayitTarihi : Date?
	var adresler: [Adres]?
	var siparisler: [Siparis]?
	var favoriler: [Yemek]?
	
	init(){
		
	}
	
	init(ad: String, kullaniciAdi: String, mail: String, sifre: String, image: String, kayitTarihi: Date, adresler: [Adres], siparisler: [Siparis], favoriler: [Yemek]) {
		self.ad = ad
		self.kullaniciAdi = kullaniciAdi
		self.mail = mail
		self.sifre = sifre
		self.image = image
		self.kayitTarihi = kayitTarihi
		self.adresler = adresler
		self.siparisler = siparisler
		self.favoriler = favoriler
	}
}
