//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Atil Samancioglu on 9.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
    
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView) // tıklanan yerleri koordinatlara çeviriyoruz
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    @objc func saveButtonClicked() {
        //PARSE
        // bu kısımda parse a veri kaydediyoruz. daha sonra verileri çekme işlemlerini yapıcaz
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places") // parse ta sınıflar oluşturabiliyoruz. Places diye bir sınıf oluşturduk
        object["name"] = placeModel.placeName // object in adı placeModel.placeName bu olsun. burada object i bir sözlük gibi ele alıyoruz ve object e name değerini verdiğimizde bize placeModel.placeName değerini getiricek. firebase de bunları collection olarak yapıyoduk
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        // oluşturma tarih parse ta otomatik oluşturuluyo o yüzden eklemeye gerek yok
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) { // görseli kaydetmek için önce dataya çevirmek gerek
            object["image"] = PFFileObject(name: "image.jpg", data: imageData) // object["image"] bu string double vs ye değil PFFileObject olucak
        }
        
        object.saveInBackground { (success, error) in // yukarıdaki verileri database imize kaydediyoruz. saveInBackground : kullanıcı bir şeyi upload etmek istiyorsa database e edilip edilmediğini kontrol eder ve kullanıcının bağlantısı yoksa vs hata verir
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    @objc func backButtonClicked() {
        //navigationController?.popViewController(animated: true) -> bunu yazarsak bi önceki controller a gider ama bunu kullanamayız çünkü bi önceki controller navigation controller
        self.dismiss(animated: true, completion: nil) // bunu yazarak navigasyonu görmez önceki controller a gider
    }
}
