//
//  FavoriDaoRepository.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FavoriDaoRepository{
	func favoriyeEkle(yemek: Yemek){
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
							"yemek_id": yemek.yemek_id!,
							"yemek_adi": yemek.yemek_adi!,
							"yemek_resim_adi": yemek.yemek_resim_adi!,
							"yemek_fiyat": yemek.yemek_fiyat!
						] as [String : Any]
						
						documentRef.updateData(["favoriler": FieldValue.arrayUnion([newAdres])]) { error in
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
	func favoriSil(yemek: Yemek){
		if let adresID = yemek.yemek_id {
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
							
							var favoriler = document.data()["favoriler"] as? [[String: Any]] ?? []
							
							if let index = favoriler.firstIndex(where: { $0["yemek_id"] as? String == adresID }) {
								favoriler.remove(at: index)
								
								documentRef.updateData(["favoriler": favoriler]) { error in
									if let error = error {
										print("Hata: \(error.localizedDescription)")
									} else {
										print("Adres başarıyla silindi!")
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
}

