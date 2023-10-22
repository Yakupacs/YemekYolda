import UIKit

class TabBarControllerYemek: UITabBarController, UITabBarControllerDelegate {
	
	var heightTabbar : CGFloat = 100
//	static var sepetViewModel = SepetViewModel()
//	static var anasayfaViewModel = AnasayfaViewModel()
//	static var kullaniciViewModel = KullaniciViewModel()
//	static var dao = YemeklerDaoRepository()
	static var notificationAccess = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let bottomLine = UIView()
		bottomLine.backgroundColor = UIColor.lightGray
		bottomLine.frame = CGRect(x: 0, y: tabBar.frame.size.height - 50, width: tabBar.frame.width, height: 1)
		tabBar.addSubview(bottomLine)
	}
	override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		tabBar.frame.size.height = heightTabbar
		tabBar.frame.origin.y = view.frame.height - heightTabbar
	}
}

