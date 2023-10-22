//
//  FavoriViewModel.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation

class FavoriViewModel {
	static let shared = FavoriViewModel()
	let favoriDaoRepository = FavoriDaoRepository()
	
	func favoriEkle(yemek: Yemek){
		favoriDaoRepository.favoriyeEkle(yemek: yemek)
	}
	func favoriSil(yemek: Yemek){
		favoriDaoRepository.favoriSil(yemek: yemek)
	}
}
