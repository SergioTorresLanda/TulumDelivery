//
//  LocationManager.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 12/06/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    // Propiedades publicadas para que la vista pueda reaccionar a los cambios
    @Published var location: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus

    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    /// Pide permiso de ubicación "Cuando se use la app".
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    // Este método se llama cada vez que el estado de autorización cambia.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        
        // Si el usuario da permiso, asegúrate de que las actualizaciones de ubicación comiencen.
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    // Este método se llama cuando se reciben nuevas actualizaciones de ubicación.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Obtenemos la última ubicación y la publicamos.
        // Detenemos las actualizaciones para ahorrar batería una vez que tenemos una ubicación precisa.
        guard let latestLocation = locations.first else { return }
        DispatchQueue.main.async {
            self.location = latestLocation
        }
        manager.stopUpdatingLocation() // Opcional: para si solo necesitas la ubicación inicial
    }
    
    // Manejo de errores.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
}
