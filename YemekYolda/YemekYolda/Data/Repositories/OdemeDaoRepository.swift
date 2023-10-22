//
//  OdemeDaoRepository.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class OdemeDaoRepository{
	func odemeEkle(kartCVV: String, kartNumarasi: String, kartAdi: String){
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
						
						let newAdres = [
							"id": UUID().uuidString,
							"kartCVV": kartCVV,
							"kartNumarasi": kartNumarasi,
							"kartAdi": kartAdi,
						] as [String : Any]
						
						documentRef.updateData(["odemeler": FieldValue.arrayUnion([newAdres])]) { error in
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
	func odemeSil(odemeID: String){
		let firestore = Firestore.firestore()
		
		firestore.collection("Kullanici")
			.whereField("mail", isEqualTo: Auth.auth().currentUser!.email!)
			.getDocuments { querySnapshot, error in
				if let error = error {
					print("Hata: \(error.localizedDescription)")
				} else {
					guard let querySnapshot = querySnapshot else { return }
					
					for document in querySnapshot.documents {
						let documentRef = document.reference
						
						var odemeler = document.data()["odemeler"] as? [[String: Any]] ?? []
						
						if let index = odemeler.firstIndex(where: { $0["id"] as? String == odemeID }) {
							odemeler.remove(at: index)
							
							documentRef.updateData(["odemeler": odemeler]) { error in
								if let error = error {
									print("Hata: \(error.localizedDescription)")
								} else {
									print("Ödeme başarıyla silindi!")
								}
							}
						} else {
							print("Belirtilen adres ID'si bulunamadı")
						}
					}
				}
			}
	}
}
