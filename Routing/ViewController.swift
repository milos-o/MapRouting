import UIKit
import MapKit

final class ViewController: UIViewController {
    private let mapView = MKMapView()
    private var presenter = Presenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.addSubview(mapView, constraints: [
            equal(\.leadingAnchor), equal(\.trailingAnchor),
            equal(\.topAnchor), equal(\.bottomAnchor)
        ])
        DispatchQueue.global(qos: .userInitiated).async {
            let tracks = Track.load()
            DispatchQueue.main.async {
                self.updateMapView(tracks)
            }
        }
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
}

extension ViewController {
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        let tapLoc = recognizer.location(in: mapView)
        let tapCoord = mapView.convert(tapLoc, toCoordinateFrom: mapView)
        let (track, closestPoint) = presenter.closest(to: tapCoord)!
        let closestInMapView = mapView.convert(closestPoint, toPointTo: mapView)
        if closestInMapView.distance(to: tapLoc) < 44/2 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = closestPoint
            annotation.title = track.name
            mapView.addAnnotation(annotation)
        }
    }

    func updateMapView(_ newTracks: [Track]) {
        for t in newTracks {
            let polygon = presenter.add(t)
            mapView.addOverlay(polygon)
        }
        let boundingRect = presenter.boundingRect
        mapView.setVisibleMapRect(boundingRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let p = overlay as? MKPolygon else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let track = presenter.track(for: p)!
        let r = MKPolygonRenderer(polygon: p)
        r.lineWidth = 1
        r.strokeColor = track.color.uiColor
        r.fillColor = track.color.uiColor.withAlphaComponent(0.2)
        return r
    }
}
