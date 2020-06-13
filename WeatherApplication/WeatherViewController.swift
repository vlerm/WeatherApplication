//
//  ViewController.swift
//  WeatherApplication
//
//  Created by val on 2/15/20.
//  Copyright © 2020 VL. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let networkManager = NetworkManager()
    var weatherModel: WeatherModel?
    
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var conditionWeatherIconImageView: UIImageView!
    @IBOutlet weak var conditionWeatherImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLocationManager()
    }
    
    @IBAction func nextScreenTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCity", sender: self)
    }
    
    func receivedCityName(city: String) {
        networkManager.getWeatherDataByCity(city: city) { (result) in
            switch result {
            case .success(let weatherModel):
                self.weatherModel = weatherModel
                DispatchQueue.main.async {
                    self.updateWeatherInfo(info: weatherModel)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.makeErrorAnimation(view: self.wrongLabel)
                }
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCity" {
            guard let destinationVc = segue.destination as? CityViewController else { return }
            destinationVc.weatherViewController = self
        }
    }
    
    func makeErrorAnimation(view: UILabel) {
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/16, animations: {
                view.layer.opacity = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 7/8, relativeDuration: 1/16, animations: {
                view.layer.opacity = 0
            })
        }, completion: nil)
    }
    
    func setupViews() {
        wrongLabel.layer.opacity = 0
        tempLabel.text = "--℃"
        cityLabel.text = "Select the city"
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateWeatherInfo(info: WeatherModel) {
        tempLabel.text = Int(info.main.temp).description + "℃"
        cityLabel.text = info.name
        descriptionLabel.text = info.weather[0].description.description
        humidityLabel.text = "humidity: " + info.main.humidity.description
        pressureLabel.text = "pressure: " + info.main.pressure.description
        windSpeedLabel.text = "wind speed: " + info.wind.speed.description
        windDegreeLabel.text = "wind degree: " + info.wind.deg.description
        conditionWeatherIconImageView.image = UIImage(named: info.getWeatherIconImage(condition: info.weather[0].id))
        conditionWeatherImageView.image = UIImage(named: info.getConditionWeatherImage(condition: info.weather[0].main))
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let latitude = location.coordinate.latitude.description
            let longitude = location.coordinate.longitude.description
            networkManager.getWeatherData(lat: latitude, lon: longitude) { (result) in
                switch result {
                case .success(let weatherModel):
                    self.weatherModel = weatherModel
                    DispatchQueue.main.async {
                        self.updateWeatherInfo(info: weatherModel)
                    }
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
}

