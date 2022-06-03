//
//  ViewController.swift
//  mapsTest
//
//  Created by Wender on 02/06/22.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private lazy var mapView: CustomMapView = {
        let map = CustomMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    @IBOutlet weak var textInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
    }
    
    @IBAction func centerMapButton(_ sender: Any) {
        if let query = textInput.text {
            mapView.showLocation(query: query)
        } else {
            mapView.hideMap()
        }
    }
        

}
