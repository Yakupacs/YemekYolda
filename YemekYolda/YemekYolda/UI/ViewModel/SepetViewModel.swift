import Foundation
import RxSwift

class SepetViewModel{
	static var shared = SepetViewModel()
	var sepetYemekler = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
	var yemekRepo = YemeklerDaoRepository()
	
	init(){
		sepetYemekler = yemekRepo.sepetYemekler
	}
	func sepettekiYemekleriYukle(kullaniciAdi: String){
		yemekRepo.sepettekiYemekleriYukle(kullaniciAdi: kullaniciAdi)
	}
	func sepeteYemekEkle(yemekAdi: String, yemekResimAdi: String, yemekFiyat: String, yemekSiparisAdet: Int, kullaniciAdi: String){
		yemekRepo.sepeteYemekEkle(yemekAdi: yemekAdi, yemekResimAdi: yemekResimAdi, yemekFiyat: yemekFiyat, yemekSiparisAdet: yemekSiparisAdet, kullaniciAdi: kullaniciAdi)
	}
	func sepetteYemekSilme(sepet_yemek_id: String,_ sign: Int, kullaniciAdi: String){
		yemekRepo.sepetteYemekSilme(sepet_yemek_id: sepet_yemek_id, kullaniciAdi: kullaniciAdi)
		if (sign == 1){
			yemekRepo.sepetYemekler.onNext([])
		}else{
			sepettekiYemekleriYukle(kullaniciAdi: kullaniciAdi)
		}
	}
	func sepetiTemizle(kullaniciAdi: String){
		yemekRepo.sepetiTemizle(kullaniciAdi: kullaniciAdi)
		yemekRepo.sepetYemekler.onNext([])
	}
}
