//
//  HomeViewController.swift
//  Alura Ponto
//
//  Created by Ândriu Felipe Coelho on 22/09/21.
//

import UIKit
import CoreData
import CoreLocation
class HomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var horarioView: UIView!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var registrarButton: UIButton!

    // MARK: - Attributes
    private lazy var camera = Camera()
    private lazy var controladorDeImagem = UIImagePickerController()
    private var timer: Timer?
    var contexto: NSManagedObjectContext = {
        let contexto = UIApplication.shared.delegate as! AppDelegate
        return contexto.persistentContainer.viewContext
    }()
    lazy var gerenciadorDeLocalizacao = CLLocationManager()
     var latitude: CLLocationDegrees?
     var longitude: CLLocationDegrees?
    private lazy var localizacao = Localizacao()
    private lazy var reciboService = ReciboService()
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraView()
        atualizaHorario()
        requisicaoDaLocalizacaoDoUsuario()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configuraTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // MARK: - Class methods
    
    func configuraView() {
        configuraBotaoRegistrar()
        configuraHorarioView()
    }
    
    func configuraBotaoRegistrar() {
        registrarButton.layer.cornerRadius = 5
    }
    
    func configuraHorarioView() {
        horarioView.backgroundColor = .white
        horarioView.layer.borderWidth = 3
        horarioView.layer.borderColor = UIColor.systemGray.cgColor
        horarioView.layer.cornerRadius = horarioView.layer.frame.height/2
    }
    
    func configuraTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(atualizaHorario), userInfo: nil, repeats: true)
    }
    
    @objc func atualizaHorario() {
        let horarioAtual = FormatadorDeData().getHorario(Date())
        horarioLabel.text = horarioAtual
    }
    
    func tentaAbrirCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            camera.abrirCamera(self, controladorDeImagem)
        }
    }
    
    func requisicaoDaLocalizacaoDoUsuario(){
        localizacao.delegate = self
        localizacao.permissao(gerenciadorDeLocalizacao)
    }
    
    // MARK: - IBActions
    
    @IBAction func registrarButton(_ sender: UIButton) {
        tentaAbrirCamera()
    }
}

extension HomeViewController: CameraDelegate{
    func didFinishFoto(_ image: UIImage) {
        let recibo = Recibo(status: false, data: Date(), foto: image, latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        recibo.save(contexto)
       
        reciboService.post(recibo) { [weak self] salvo in
            if !salvo {
                guard let contexto = self?.contexto else { return }
                recibo.save(contexto)
            }
        }
    }
    
    
}
extension HomeViewController: LocalizacaoDelegate {
    func atualizaLocalizacaoDoUsuario(latitude: Double?, longitude: Double?) {
        self.latitude = latitude ?? 0.0
        self.longitude = longitude ?? 0.0
    }
}
