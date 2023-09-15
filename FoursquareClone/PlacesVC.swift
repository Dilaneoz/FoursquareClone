//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Atil Samancioglu on 9.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked)) // sağ üste artı butonu koyuyoruz
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked)) // sola logout butonu ekliyoruz
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
    }
    
    // parse tan verileri bu kısımda çekiyoruz
    func getDataFromParse() {
    // query.whereKey("latitude", greaterThan: 2) örneğin bu şekilde yazılarak Places class ı içindeki latitude objesinde 2 den büyük olanları getir gibi detaylı isteklerde de bulunabiliriz. farklı fonksiyonlar da mevcut
        let query = PFQuery(className: "Places") // çekmek istediğimiz sınıfı yazıyoruz
        query.findObjectsInBackground { (objects, error) in // classtaki bütün verileri çekiceğimiz için findObjectsInBackground kullanıyoruz
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                if objects != nil {
                    
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String { // object(forKey: dediğimizde parse taki hangi veriyi yazarsak onun karşılığını bize getirir
                            if let placeId = object.objectId { // bunun için forkey e gerek yok çünkü objectid parse ta tanımlı bir veri
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addButtonClicked() {
        //Segue
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    @objc func logoutButtonClicked() {
        
        PFUser.logOutInBackground { (error) in // logout a tıklandığında kullanıcıyı logout et yoksa hata ver
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue olmadan önce ne yapacağımızı bu fonksiyona yazarız
        if segue.identifier == "toDetailsVC" { // detailsvc a gidilecekse
            let destinationVC = segue.destination as! DetailsVC // detailvc ı kaydediyoruz
            destinationVC.chosenPlaceId = selectedPlaceId // destailVC ın içinde oluşturduğumuz değişkenlere ulaşabilcez
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
