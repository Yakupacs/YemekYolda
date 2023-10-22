//
//  SiparisViewModel.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation

class SiparisViewModel{
	var siparisDaoRepository = SiparisDaoRepository()
	
	func siparisKaydet(siparis: Siparis){
		siparisDaoRepository.siparisKaydet(siparis: siparis)
	}
}
