//
//  Localizacao.swift
//  Alura Ponto
//
//  Created by Fernanda Abreu on 13/11/22.
//

import Foundation
import CoreLocation

protocol LocalizacaoDelegate: AnyObject {
    func atualizaLocalizacaoDoUsuario(latitude: Double?, longitude: Double?)
}

class Localizacao: NSObject {
    
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    weak var delegate: LocalizacaoDelegate?
    func permissao(_ gerenciadorDeLocalizacao: CLLocationManager){
        gerenciadorDeLocalizacao.delegate = self
        
        
    }
}
extension Localizacao: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .denied:
            // mostrar alerta
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let localizacao = locations.first {
            latitude = localizacao.coordinate.latitude
            longitude = localizacao.coordinate.longitude
        }
        delegate?.atualizaLocalizacaoDoUsuario(latitude: latitude, longitude: longitude)
    }
}
