//
//  NewRunViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 07/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
import Alamofire

class NewRunViewController: UIViewController, UITextFieldDelegate{

    // @IBOutlet
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var maxPaceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var mapContainerView: UIView!

    // Run properties
    private let locationManager = LocationManager.shared // Use to start and stop LocationManager
    private var seconds = 0 // Track duration of the run in seconds
    private var timer: Timer? // update the UI each second
    private var maxPace = 0.0
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var startDate = ""
    
    private var run: Run?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let formattedDate = FormatDisplay.date(Date())
        dateLabel.text = formattedDate
        mapView.removeOverlays(mapView.overlays)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenu()
        customNavBar()
        customView()

    }
    
    func customNavBar() {
        navigationController?.navigationBar.tintColor = RIColors.WHITE
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: RIColors.WHITE]
        navigationController?.navigationBar.barTintColor = RIColors.CYAN
    }
    
    func sideMenu() {
        if revealViewController != nil {
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = .done
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Ensures that location updates and the timer stops when the user navigates away from the view.
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        let newPace:Double = distance.value / Double(seconds)
        debugPrint("newPace: ", newPace);
        maxPace = newPace > maxPace ? newPace : maxPace
        
        debugPrint("maxPace: ", maxPace)
        distanceLabel.text = "Distance :  \(formattedDistance)"
        timeLabel.text = "Temps :  \(formattedTime)"
        paceLabel.text = "Vitesse :  \(formattedPace)"
        //maxPaceLabel.text = "Vitesse max: \(formattedMaxPace)"
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        //Intelligently save power throughout the user’s run, read
        locationManager.activityType = .fitness
        // 10 is a good ratio og zigzag (accurate line)
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }

    private func saveRun() {
        // Creating and showing loading alert
        let alert = UIAlertController(title: nil, message: "Veuillez patienter...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        // Save the location properties in savedLocation object
        var savedLocations = [Coordinate]()
        for location in locationList {
            let savedLocation = Coordinate(
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude,
                timestamp:  Int((location.timestamp).timeIntervalSince1970))
            savedLocations.append(savedLocation)
        }

        var savedRun = Run(
            id: -1,
            started_at: startDate,
            user_token: UserSession.sharedInstance.token,
            user_email: UserSession.sharedInstance.email,
            max_speed: maxPace,
            is_spot: false,
            total_distance: Int(distance.converted(to: .meters).value),
            total_time: seconds,
            coordinates: savedLocations
        )

        // Convert Array<Coordinate> to JSON data structure
        let dicSavedLocations: JSON = JSON(savedLocations.map { $0.dict })
        let jsonSavedLocations = dicSavedLocations.rawString([.castNilToNSNull: true])
        run = savedRun

        let parameters : [String: Any] = [
            "started_at": savedRun.started_at,
            "user_token": UserSession.sharedInstance.token,
            "user_email": UserSession.sharedInstance.email,
            "max_speed": savedRun.max_speed,
            "is_spot": savedRun.is_spot,
            "total_distance": savedRun.total_distance,
            "total_time": savedRun.total_time,
            "coordinates": jsonSavedLocations
        ]
        
        let url = "http://www.runit.fr/api/v1/runs/"
        
        // POST request for adding a new event
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                        UserSession.sharedInstance.share_run_id = json["id"].intValue
                        debugPrint("Ce fut un succes ", UserSession.sharedInstance.share_run_id)
                        self.dissmissOnResponse(alert: alert, statusCode: statusCode, response: json)
                    }
                    
                case .failure(let error):
                    self.dissmissOnResponse(alert: alert, statusCode: 500, response: error)
                }
        }
//
//        let req = RunRequestFactory.create(parameters: parameters as [String : Any])
//        debugPrint("Going to perform save run...");
//        debugPrint("Parameters: ", parameters);
//        req.perform(withSuccess: { (res) in
//            debugPrint("res ", res);
//            self.dismiss(animated: false) {
//                debugPrint("Success  in saving run!")
//            }
//        }) { (err) in
//            debugPrint("Erroooor somewhere")
//            debugPrint(err)
//            let code = err.response?.statusCode
//            guard let err = err.errorModel else { return }
//
//            let wrongCredidential = UIAlertController(title: "Error", message: "Error when recording the run", preferredStyle: UIAlertControllerStyle.alert)
//            wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.dismiss(animated: false) {
//                self.present(wrongCredidential, animated: true, completion: nil)
//            }
//        }
    }
    
    private func dissmissOnResponse(alert: UIAlertController, statusCode: Int, response: Any) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
                let alert = UIAlertController(title: "Course enregistrée", message: "La course a été enregistrée avec succès !", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            } else if (statusCode == 422) {
                var error = ""
                for (key, subJson) in response as! JSON {
                    error += "- " + key + ": "
                    for (key, elem) in subJson as! JSON {
                        error += elem.stringValue
                        error += " "
                    }
                    error += "\n"
                }
                print("Error: \(error)")
                let alert = UIAlertController(title: "Impossible d'enregistrer la course", message: "Veuillez compléter tous les champs", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                // Bad password or email alert
                let wrongCredidential = UIAlertController(title: "Un problème est survenu", message: "Erreur de connection", preferredStyle: UIAlertControllerStyle.alert)
                wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(wrongCredidential, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func startTapped(_ sender: Any) {
        startRun()
    }

    @IBAction func stopTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Arrêter la course ?",
                                                message: "Voulez-vous vraiment arrêter ?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Sauvegarder", style: .default) { _ in
            self.stopRun()
            self.saveRun()
            self.performSegue(withIdentifier: "RunRecapViewController", sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Revenir au menu de course", style: .destructive) { _ in
            self.stopRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    private func startRun() {
        startButton.isHidden = true
        stopButton.isHidden = false
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        startDate = dateFormatter.string(from: Date())
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        startButton.isHidden = false
        stopButton.isHidden = true
        
        locationManager.stopUpdatingLocation()
    }
}


extension NewRunViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "RunRecapViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! RunRecapViewController
            destination.run = run
        }
    }
}

extension NewRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}


extension NewRunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
