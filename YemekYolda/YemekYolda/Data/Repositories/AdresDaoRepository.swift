//
//  AdresDaoRepository.swift
//  YemekYolda
//
//  Created by Yakup on 21.10.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AdresDaoRepository{
	func adresEkle(adresBasligi: String, adresTarifi: String, binaNo: String, daireNo: String, kat: String, mahalle: String){
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
							"adresBasligi": adresBasligi,
							"adresTarifi": adresTarifi,
							"binaNo": binaNo,
							"daireNo": daireNo,
							"kat": kat,
							"mahalle": mahalle
						] as [String : Any]
						
						documentRef.updateData(["adresler": FieldValue.arrayUnion([newAdres])]) { error in
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
	func adresSil(adresID: String){
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
						
						var adresler = document.data()["adresler"] as? [[String: Any]] ?? []
						
						if let index = adresler.firstIndex(where: { $0["id"] as? String == adresID }) {
							adresler.remove(at: index)
							
							documentRef.updateData(["adresler": adresler]) { error in
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
	func adresGuncelle(gelenAdres: Adres, adresBasligi: String, adresTarifi: String, binaNo: String, daireNo: String, kat: String, mahalle: String){
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
						   
						   let adresID = gelenAdres.id
						   
						   let newAdres = [
							   "adresBasligi": adresBasligi,
							   "adresTarifi": adresTarifi,
							   "binaNo": binaNo,
							   "daireNo": daireNo,
							   "kat": kat,
							   "mahalle": mahalle,
							   "id": adresID!
						   ] as [String : Any]
						   
						   var adresler = document.data()["adresler"] as? [[String: Any]] ?? []
						   
						   if let index = adresler.firstIndex(where: { $0["id"] as? String == adresID }) {
							   adresler[index] = newAdres
						   } else {
							   adresler.append(newAdres)
						   }
						   
						   documentRef.updateData(["adresler": adresler]) { error in
							   if let error = error {
								   print("Hata: \(error.localizedDescription)")
							   } else {
								   print("Veri güncelleme başarılı!")
							   }
						   }
					   }
				   }
			   }
	   }
}
