//
//  AdresViewModel.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation

class AdresViewModel {
	var adresDao = AdresDaoRepository()
	
	func adresEkle(adresBasligi: String, adresTarifi: String, binaNo: String, daireNo: String, kat: String, mahalle: String){
		adresDao.adresEkle(adresBasligi: adresBasligi, adresTarifi: adresTarifi, binaNo: binaNo, daireNo: daireNo, kat: kat, mahalle: mahalle)
	}
	func adresSil(adresID: String){
		adresDao.adresSil(adresID: adresID)
	}
	func adresGuncelle(gelenAdres: Adres, adresBasligi: String, adresTarifi: String, binaNo: String, daireNo: String, kat: String, mahalle: String){
		adresDao.adresGuncelle(gelenAdres: gelenAdres, adresBasligi: adresBasligi, adresTarifi: adresTarifi, binaNo: binaNo, daireNo: daireNo, kat: kat, mahalle: mahalle)
	}
}
