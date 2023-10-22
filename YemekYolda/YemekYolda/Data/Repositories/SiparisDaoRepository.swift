//
//  SiparisDaoRepository.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SiparisDaoRepository{
	func siparisKaydet(siparis: Siparis){
		let firestore = Firestore.firestore()
		
		firestore.collection("Kullanici")
			.whereField("mail", isEqualTo: Auth.auth().currentUser!.email!)
			.getDocuments { querySnapshot, error in
				if let error = error{
					print("Hata: \(error.localizedDescription)")
				}
				else{
					guard let querySnapshot = querySnapshot else { return }
					
					for document in querySnapshot.documents{
						let documentRef = document.reference
						
						var siparisYemekleri = [[String: Int]]()
						
						for i in siparis.yemekler!{
							for (key, value) in i{
								print("[\(key):\(value)]")
								siparisYemekleri.append([key: value])
							}
						}
						
						let newSiparis = [
							"id": siparis.id!,
							"teslimEdildi": siparis.teslimEdildi,
							"tutar": siparis.tutar!,
							"yemekler": siparisYemekleri,
							"tarih": siparis.tarih!
						] as [String : Any]
						
						documentRef.updateData(["siparisler": FieldValue.arrayUnion([newSiparis])]) { error in
							if let error = error{
								print("Hata: \(error.localizedDescription)")
							}
							else{
								print("Veri güncelleme başarılı!")
							}
						}
					}
				}
			}
	}
}
