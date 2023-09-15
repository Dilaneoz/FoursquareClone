//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Atil Samancioglu on 9.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import Foundation
import UIKit

// singleton
// addplacevc da oluşturduğumuz şeyi singleton kullanarak mapvc a alabiliyoruz
class PlaceModel {
    
    static let sharedInstance = PlaceModel() // bu objemiz
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){} // bu sınıfın içindeki obje hariç başka hiçbir obje oluşturulmasını istemiyorum demek. normalde bi sınıf oluşturduğumuzda içinde birçok obje oluşturabiliriz. bunu yazınca tek bir obje oluşturulabiliyor ve o objeye istediğimiz değişkenleri atayabiliyoruz, istediğimiz değişkenleri atadığımız dünyada da bu objeyi hangi sınıf içinden çağırırsak çağıralım aynı değişkenlere ulaşabiliyoruz. private init deyince başka hiçbi yerden initilazing işleminin yapılamıycağını belirtmiş oluruz
    
}
