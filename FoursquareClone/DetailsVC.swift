//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Atil Samancioglu on 9.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromParse()
        detailsMapView.delegate = self
    }
    
    func getDataFromParse() { // parse tan verileri çekiyoruz
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId) // objectid si chosenPlaceId e eşit olanları getir
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                
            } else {
                if objects != nil {
                    if objects!.count > 0 { // objectsi çağıracağımızdan emin olmak için yapıyoruz
                        let chosenPlaceObject = objects![0]
                        
                        // OBJECTS
                        // label ların değerlerini alıp atamak istiyoruz
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                            self.detailsNameLabel.text = placeName
                        }
                        
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            self.detailsTypeLabel.text = placeType
                        }
                        
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.detailsAtmosphereLabel.text = placeAtmosphere
                        }
                        
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { (data, error) in // PFFileObject i aldıktan sonra getDataInBackground ı kullanarak veriyi çekmek gerekiyor
                                if error == nil {
                                    if data != nil {
                                    self.detailsImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        // MAPS
                        // objenin mapse aktarıldığı kısım
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.detailsMapView.setRegion(region, animated: true) // seçilen lokasyonu details ı açınca haritada göstericek
                        
                        let annotation = MKPointAnnotation() // seçilen konuma pin koycak
                        annotation.coordinate = location
                        annotation.title = self.detailsNameLabel.text!
                        annotation.subtitle = self.detailsTypeLabel.text!
                        self.detailsMapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { // buton oluşturuyoruz
        
        if annotation is MKUserLocation { // kullanıcıyla ilgili bi annotation varsa öyle bi şey yapmak istemiyoruz
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true // sağda tıklandığında buton ya da görsel koyacağımız bi yer çıkarmak istiyoruz
            let button = UIButton(type: .detailDisclosure) // i işareti çıkar
            pinView?.rightCalloutAccessoryView = button // sağdaki aksesuar bu buton olsun
        } else {
            pinView?.annotation = annotation // nil değilse şuanda içerisinde hangi annotation varsa pinView?.annotation ı annotation a eşitle
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { // haritalar kısmında var. yukarıda oluşturduğumuz butona tıklanınca ne olucağı. bizi alıp naviasyona götürücek ve güncel yeri neresiyse ordan pinle işaretlenmiş yere arabayla nasıl gidilir göstericek. bunun için MKMapItem a ihtiyaç var. onun için de placemark oluşturulmasını istiyor. placemark ı da reverseGeocodeLocation ile oluşturuyoruz. reverseGeocodeLocation ı da CLLocation dan oluşturuyoruz
        
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 { // 0 dan büyükse bize bi yer verilmiş demektir
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}
