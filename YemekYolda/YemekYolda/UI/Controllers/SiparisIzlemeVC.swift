import UIKit
import CoreLocation
import MapKit

class SiparisIzlemeVC: UIViewController {
	
	@IBOutlet weak var siparisMapView: MKMapView!
	@IBOutlet weak var kuryeImageView: UIImageView!
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var tutarLabel: UILabel!
	
	var locationManager = CLLocationManager()
	var gelenSiparis: Siparis?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appearance()
		locationSetup()
	}
}

// MARK: - CLLocationManager
extension SiparisIzlemeVC: CLLocationManagerDelegate, MKMapViewDelegate{
	func locationSetup(){
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		locationManager.delegate = self
		
		let location = CLLocationCoordinate2D(latitude: 41.0349999, longitude: 28.964421)
		let zoom = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
		let region = MKCoordinateRegion(center: location, span: zoom)
		siparisMapView.setRegion(region, animated: true)
		
		let pin = MKPointAnnotation()
		pin.coordinate = location
		pin.title = "Kurye"
		siparisMapView.addAnnotation(pin)
	}
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let lastLocation = locations[locations.count - 1]
		
		let latitude = lastLocation.coordinate.latitude
		let longitude = lastLocation.coordinate.longitude
		
		let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		let zoom = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
		let region = MKCoordinateRegion(center: location, span: zoom)
		siparisMapView.setRegion(region, animated: true)

		siparisMapView.showsUserLocation = true
	}
}

// MARK: - APPEARANCE
extension SiparisIzlemeVC{
	func appearance(){
		tutarLabel.text = "\(gelenSiparis!.tutar!)₺"
		backgroundView.layer.cornerRadius = 15
		kuryeImageView.layer.cornerRadius = 40
		kuryeImageView.layer.borderWidth = 1
		kuryeImageView.layer.borderColor = UIColor.black.cgColor
	}
}
