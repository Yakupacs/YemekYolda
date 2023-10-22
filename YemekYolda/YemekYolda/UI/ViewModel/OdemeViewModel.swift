//
//  OdemeViewModel.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation

class OdemeViewModel{
	var odemeDao = OdemeDaoRepository()
	
	func odemeEkle(kartCVV: String, kartNumarasi: String, kartAdi: String){
		odemeDao.odemeEkle(kartCVV: kartCVV, kartNumarasi: kartNumarasi, kartAdi: kartAdi)
	}
	func odemeSil(odemeID: String){
		odemeDao.odemeSil(odemeID: odemeID)
	}
}
