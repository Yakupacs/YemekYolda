import Foundation
import RxSwift
import Alamofire
import FirebaseAuth
import FirebaseFirestore

class YemeklerDaoRepository {
	let userDefaults = UserDefaults.standard
	
	var yemekler = BehaviorSubject<[Yemek]>(value: [Yemek]())
	var yemeklerNormal = [Yemek]()
	
	var sepetYemekler = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
	var sepetYemeklerNormal = [SepetYemekler]()
	
	var favoriYemekler = BehaviorSubject<[Yemek]>(value: [Yemek]())
	var favoriYemeklerNormal = [Yemek]()
	
	var filterType = FilterType.VARSAYILAN
	
	var kullanici = BehaviorSubject<Kullanici>(value: Kullanici())
	var kullaniciNormal = Kullanici()
	
	// MARK: - Sepete Yemek Ekle
	func sepeteYemekEkle(yemekAdi: String, yemekResimAdi: String, yemekFiyat: String, yemekSiparisAdet: Int, kullaniciAdi: String) {
		let params: Parameters = ["yemek_adi": yemekAdi, "yemek_resim_adi": yemekResimAdi, "yemek_fiyat": yemekFiyat, "yemek_siparis_adet": yemekSiparisAdet, "kullanici_adi": kullaniciAdi]
		
		AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response { response in
			if let data = response.data{
				do {
					let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
					print("Sepete Yemek Ekleme: ", cevap.success!, cevap.message!)
					print("\(yemekAdi), \(yemekSiparisAdet) adet eklendi.")
				} catch{
					print(error.localizedDescription)
				}
			}
		}
	}
	// MARK: - Sepetten Yemek Silme
	func sepetteYemekSilme(sepet_yemek_id: String, kullaniciAdi: String) {
		let params: Parameters = ["sepet_yemek_id": sepet_yemek_id, "kullanici_adi": kullaniciAdi]
		
		AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response { response in
			if let data = response.data{
				do {
					let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
					print("Sepetten Yemek Silme: ", cevap.success!, cevap.message!)
					print("Silinen Yemek ID: \(sepet_yemek_id)")
				} catch{
					print(error.localizedDescription)
				}
			}
		}
	}
	// MARK: - Sepetteki Yemekleri Yükle
	func sepettekiYemekleriYukle(kullaniciAdi: String) {
		let params: Parameters = ["kullanici_adi": kullaniciAdi]
		AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
			if let data = response.data {
				do {
					let cevap = try JSONDecoder().decode(SepetYemekCevap.self, from: data)
					if let liste = cevap.sepet_yemekler{
						if (liste.count != 0){
							self.sepetYemekler.onNext(liste)
						}else{
							self.sepetYemekler.onNext([])
						}
						self.sepetYemeklerNormal = liste
					}
				} catch{
					print(error.localizedDescription)
				}
			}
		}
	}
	// MARK: - Sepeti Temizle
	func sepetiTemizle(kullaniciAdi: String){
		for yemekler in sepetYemeklerNormal{
			print("sepetiTemizle: \(yemekler.sepet_yemek_id!)")
			self.sepetteYemekSilme(sepet_yemek_id: yemekler.sepet_yemek_id!, kullaniciAdi: kullaniciAdi)
		}
	}
	// MARK: - Tüm Yemekleri Yükle
	func yemekleriYukle() {
		AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
			if let data = response.data {
				do {
					let cevap = try JSONDecoder().decode(YemekCevap.self, from: data)
					if let liste = cevap.yemekler {
						self.yemeklerNormal = liste
						self.yemekler.onNext(liste)
					}
				} catch{
					print(error.localizedDescription)
				}
			}
		}
	}
	// MARK: - Yemek Ara
	func yemekAra(title: String) {
		AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
			if let data = response.data {
				do {
					let cevap = try JSONDecoder().decode(YemekCevap.self, from: data)
					if let liste = cevap.yemekler {
						self.arananYemekKontrol(yemekler: liste, title: title)
					}
				} catch{
					print(error.localizedDescription)
				}
			}
		}
	}
	func arananYemekKontrol(yemekler: [Yemek], title: String){
		if (title != ""){
			var bulunanYemekler = [Yemek]()
			for yemek in yemekler{
				if (yemek.yemek_adi!.uppercased().contains(title.uppercased())){
					bulunanYemekler.append(yemek)
				}
			}
			self.yemekler.onNext(bulunanYemekler)
		}else{
			switch filterType {
			case .VARSAYILAN:
				yemekleriYukle()
			case .ADANZYE:
				aDanZYeSiralama()
			case .ZDENAYA:
				zDenAYaSiralama()
			case .ARTANFIYAT:
				artanSiralama()
			case .AZALANFIYAT:
				azalanSiralama()
			}
		}
	}
// MARK: - Filter
	func filter(filter: FilterType){
		switch filter {
		case .VARSAYILAN:
			varsayilan()
		case .ADANZYE:
			aDanZYeSiralama()
		case .ARTANFIYAT:
			artanSiralama()
		case .AZALANFIYAT:
			azalanSiralama()
		case .ZDENAYA:
			zDenAYaSiralama()
		}
	}
	// MARK: - Sıralama
	func artanSiralama() {
		yemeklerNormal.sort(by: { Int($0.yemek_fiyat!)! < Int($1.yemek_fiyat!)! })
		self.yemekler.onNext(yemeklerNormal)
	}
	func azalanSiralama() {
		yemeklerNormal.sort(by: { Int($0.yemek_fiyat!)! > Int($1.yemek_fiyat!)! })
		self.yemekler.onNext(yemeklerNormal)
	}
	func aDanZYeSiralama() {
		yemeklerNormal.sort(by: { $0.yemek_adi! < $1.yemek_adi! })
		self.yemekler.onNext(yemeklerNormal)
	}
	func zDenAYaSiralama() {
		yemeklerNormal.sort(by: { $0.yemek_adi! > $1.yemek_adi! })
		self.yemekler.onNext(yemeklerNormal)
	}
	func varsayilan() {
		yemeklerNormal.sort(by: { $0.yemek_adi! < $1.yemek_adi! })
		self.yemekler.onNext(yemeklerNormal)
	}
	
	// MARK: - Kullanıcı
	func kullaniciDoldur(){
		let fireStoreDatabase = Firestore.firestore()
		
		fireStoreDatabase.collection("Kullanici").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { querySnapshot, error in
			if let error = error {
				print("Veri alınamadı. \(error.localizedDescription)")
			}
			else{
				guard let querySnapshot = querySnapshot else{
					print("Veri alınamadı: Snapshot yok")
					return
				}
				
				var user = Kullanici()
				var tumAdresler = [Adres]()
				
				for document in querySnapshot.documents{
					if let kullaniciAdi = document.get("kullaniciAdi") as? String{
						user.kullaniciAdi = kullaniciAdi
					}
					if let mail = document.get("mail") as? String{
						user.mail = mail
					}
					if let ad = document.get("ad") as? String{
						user.ad = ad
					}
					if let kayitTarihi = document.get("kayitTarihi") as? Date{
						user.kayitTarihi = kayitTarihi
					}
					if let foto = document.get("fotograf") as? String{
						user.image = foto
					}
					if let adresler = document.get("adresler") as? [[String: Any]]{
						for adres in adresler{
							let element = Adres()
							for val in adres{
								if val.key == "adresBasligi"{
									element.adresTarifi = val.value as? String
								}else if val.key == "adresTarifi"{
									element.adresTarifi = val.value as? String
								}else if val.key == "binaNo"{
									element.binaNo = val.value as? String
								}else if val.key == "daireNo"{
									element.daireNo = val.value as? String
								}else if val.key == "kat"{
									element.kat = val.value as? String
								}else if val.key == "mahalle"{
									element.mahalle = val.value as? String
								}else if val.key == "id"{
									element.id = val.value as? String
								}
							}
							tumAdresler.append(element)
						}
					}
					if let siparisler = document.get("siparisler") as? [[String: Any]]{
						for siparis in siparisler{
							let element = Siparis()
							for val in siparis{
								if val.key == "id"{
									element.id = val.value as? String
								}else if val.key == "tarih"{
									element.tarih = val.value as? String
								}else if val.key == "teslimEdildi"{
									element.teslimEdildi = val.value as! Bool
								}else if val.key == "tutar"{
									element.tutar = val.value as? Int
								}else if val.key == "yemekler"{
									element.yemekler = val.value as? [[String: Int]]
								}
							}
						}
					}
				}
				user.adresler = tumAdresler
				self.kullanici.onNext(user)
				self.kullaniciNormal = user
			}
		}
		
	}
}
