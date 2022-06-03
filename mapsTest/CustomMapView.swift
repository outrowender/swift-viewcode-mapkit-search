//
//  CustomMapView.swift
//  mapsTest
//
//  Created by Wender on 02/06/22.
//

import UIKit
import MapKit

public class CustomMapView: UIView {
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private lazy var defaultView: UIImageView = {
        let view = UIImageView(frame: .zero)
        let img = UIImage(named: "Map Background")
        view.image = img
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public init(frame: CGRect, address: String? = nil) {
        super.init(frame: frame)
        
        addSubview(mapView)
        addSubview(defaultView)
        
        setupContraints()
        
        if let q = address {
            showLocation(query: q)
        } else {
            hideMap()
        }
    }
    
    private func setupContraints(){
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            defaultView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            defaultView.topAnchor.constraint(equalTo: mapView.topAnchor),
            defaultView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            defaultView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
        ])
    }
    
    public func showLocation(query: String){
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                self.hideMap()
                return
            }
            
            guard let item = response.mapItems.first else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                self.hideMap()
                return
            }
            
            if let loc = item.placemark.location {
                self.showMap()
                
                let annotation = MKPointAnnotation()
                annotation.title = query
                annotation.coordinate = loc.coordinate
                
                self.mapView.addAnnotation(annotation)
                
                self.mapView.centerToLocation(loc)
            } else {
                self.hideMap()
            }
        }
    }
    
    public func hideMap(){
        self.defaultView.isHidden = false
    }
    
    public func showMap(){
        self.defaultView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomMapView: MKMapViewDelegate {}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 500
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
