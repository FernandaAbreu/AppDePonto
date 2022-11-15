//
//  ReciboService.swift
//  Alura Ponto
//
//  Created by Fernanda Abreu on 13/11/22.
//

import Foundation
import Alamofire

class ReciboService {
    
    func delete(id:String ,completion: @escaping() -> Void){
        AF.request("http://localhost:8080/recibos/\(id)",method: .delete, headers: ["Accept":"application/json"]).responseData { _ in
            completion()
        }
    }
    
    func get(completion: @escaping(_ recibos: [Recibo]?,_ error: Error?)-> Void){
        AF.request("http://localhost:8080/recibos",method: .get, headers: ["Accept":"application/json"]).responseJSON { resposta in
            switch resposta.result {
            case .success(let json):
                var recibos: [Recibo] = []
                if let listaDerecibos = json as? [[String: Any]] {
                    for reciboDict in listaDerecibos {
                        if let novoRecibo = Recibo.serializa(reciboDict){
                            recibos.append(novoRecibo)
                        }
                    }
                    completion(recibos,nil)
                }
                break
            case .failure(let error):
                completion(nil,error)
                break
                
            }
        }
        
        
    }
    
    func post(_ recibo: Recibo, completion : @escaping(_ salvo:Bool) -> Void){
        let baseURL = "http://localhost:8080/"
        let path = "recibos"
        
        let parametros: [String: Any] = [
            "data": FormatadorDeData().getData(recibo.data),
            "status": recibo.status,
            "localizacao": [
                "latitude": recibo.latitude,
                "longitude": recibo.longitude
            ]
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: parametros, options: []) else { return }
        
        guard let url = URL(string: baseURL + path) else { return }
        
        var requisicao = URLRequest(url:url)
        requisicao.httpMethod = "POST"
        requisicao.setValue("application/json", forHTTPHeaderField:"Content-Type")
        requisicao.httpBody = body
        URLSession.shared.dataTask(with: requisicao) { data, resposta, error in
            if error == nil {
                completion(true)
                return
            }
            completion(false)
        }.resume()
    }
}
