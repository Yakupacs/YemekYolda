import Foundation
import RxSwift

class KullaniciViewModel{
	static var shared = KullaniciViewModel()
	var kullanici = BehaviorSubject<Kullanici>(value: Kullanici())
	var yemekRepo = YemeklerDaoRepository()
	
	init(){
		kullanici = yemekRepo.kullanici
	}
	
	func kullaniciDoldur(){
		yemekRepo.kullaniciDoldur()
	}
}
