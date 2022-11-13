//
//  MapaViewController.swift
//  Alura Ponto
//
//  Created by Fernanda Abreu on 13/11/22.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {

    //MARK: IBOUTLET
    
    @IBOutlet weak var mapa: MKMapView!
    
    //MARK: Atributos
    private var recibo: Recibo?
    
    //MARK: Instancia
    class func instanciar(_ recibo: Recibo?) -> MapaViewController {
        let controller = MapaViewController(nibName: "MapaViewController", bundle: nil)
        return controller
    }
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setRegiao()
        setPino()
    }
    
    //MARK: Metodos
    func setRegiao(){
        guard let latitude = recibo?.latitude, let longitude = recibo?.longitude else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let regiao = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        mapa.setRegion(regiao, animated: true)
    }
    
    func setPino(){
        let annotation = MKPointAnnotation()
        annotation.title = "Registro de ponto"
        
        annotation.coordinate.latitude = recibo?.latitude ?? 0.0
        annotation.coordinate.longitude = recibo?.longitude ?? 0.0
        mapa.addAnnotation(annotation)
        
    }

}
