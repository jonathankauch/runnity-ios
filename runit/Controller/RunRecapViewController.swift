//
//  RunRecapViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 07/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class RunRecapViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    var run: Run!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("run vaut: ", run);
        configureView()
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
    
    private func configureView() {
        let distance = Measurement(value: Double(run.total_distance), unit: UnitLength.kilometers)
        let seconds = Int(run.total_time)
        let formattedDistance = FormatDisplay.distance(distance)

        let formattedDate = run.started_at
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.kilometersPerHour)
        
        distanceLabel.text = "Distance :  \(distance)"
        dateLabel.text = formattedDate
        timeLabel.text = "Temps :  \(formattedTime)"
        paceLabel.text = "Vitesse :  \(formattedPace)"
        loadMap()
    }
    
    private func loadMap() {
        guard
            let locations = run.coordinates as? [Coordinate],
            locations.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Erreur",
                                              message: "Cette course n'a pas de géolocalisation enregistrée",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlays(polyLine())
    }
    
    // Display region for the map
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = run.coordinates as? [Coordinate],
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Coordinate
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Coordinate
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }

    private func polyLine() -> [MulticolorPolyline] {
        
        //
        let locations =  run.coordinates as [Coordinate]
        var coordinates: [(CLLocation, CLLocation)] = []
        var speeds: [Double] = []
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0
        
        //
        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            coordinates.append((start, end))
            
            //
            let distance = end.distance(from: start)
            let time = Date(milliseconds: second.timestamp).timeIntervalSince(Date(milliseconds: first.timestamp) as Date)
            let speed = time > 0 ? distance / time : 0
            speeds.append(speed)
            minSpeed = min(minSpeed, speed)
            maxSpeed = max(maxSpeed, speed)
        }
        
        //
        let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
        
        //
        var segments: [MulticolorPolyline] = []
        for ((start, end), speed) in zip(coordinates, speeds) {
            let coords = [start.coordinate, end.coordinate]
            let segment = MulticolorPolyline(coordinates: coords, count: 2)
            segment.color = segmentColor(speed: speed,
                                         midSpeed: midSpeed,
                                         slowestSpeed: minSpeed,
                                         fastestSpeed: maxSpeed)
            segments.append(segment)
        }
        return segments
    }
    
    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
        enum BaseColors {
            static let r_red: CGFloat = 1
            static let r_green: CGFloat = 20 / 255
            static let r_blue: CGFloat = 44 / 255
            
            static let y_red: CGFloat = 1
            static let y_green: CGFloat = 215 / 255
            static let y_blue: CGFloat = 0
            
            static let g_red: CGFloat = 0
            static let g_green: CGFloat = 146 / 255
            static let g_blue: CGFloat = 78 / 255
        }
        
        let red, green, blue: CGFloat
        
        if speed < midSpeed {
            let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
            red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
            green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
            blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
        } else {
            let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
            red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
            green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
            blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        // Creating and showing loading alert
        let alert = UIAlertController(title: nil, message: "Veuillez patienter..", preferredStyle: .alert)
        
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
        
        debugPrint("value id: ", UserSession.sharedInstance.share_run_id)
        let url = "http://www.runit.fr/api/v1/runs/" + String(UserSession.sharedInstance.share_run_id) + "/define_as_a_spot"
        
        // Share the run
        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                    }
                    debugPrint("Work ! ", response.result.value, statusCode)
                    self.dissmissOnResponse(alert: alert, statusCode: statusCode)
                case .failure(let error):
                    self.dissmissOnResponse(alert: alert, statusCode: 500)
                }
        }
    }
    
    private func dissmissOnResponse(alert: UIAlertController, statusCode: Int) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
                let checkEmail = UIAlertController(title: "Course partagée", message: "La course a bien été partagée", preferredStyle: UIAlertControllerStyle.alert)
                checkEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(checkEmail, animated: true, completion: nil)
            } else {
                // Bad password or email alert
                let wrongCredidential = UIAlertController(title: "Un problème est survenu", message: "Erreur de connection", preferredStyle: UIAlertControllerStyle.alert)
                wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(wrongCredidential, animated: true, completion: nil)
            }
        })
    }
}

extension RunRecapViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MulticolorPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        return renderer
    }
}
