import Foundation
import RxSwift

class AnasayfaViewModel{
	static let shared = AnasayfaViewModel()
	var yemekler = BehaviorSubject<[Yemek]>(value: [Yemek]())
	var yemekRepo = YemeklerDaoRepository()
	
	init(){
		yemekler = yemekRepo.yemekler
	}
	func yemekleriYukle(){
		yemekRepo.yemekleriYukle()
	}
	func yemekAra(searchText: String){
		yemekRepo.yemekAra(title: searchText)
	}
	func filter(filter: FilterType){
		yemekRepo.filter(filter: filter)
		yemekRepo.filterType = filter
	}
}
