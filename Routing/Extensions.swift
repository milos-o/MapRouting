import MapKit

extension Track {
    var clCoordinates: [CLLocationCoordinate2D] {
        coordinates.map { CLLocationCoordinate2D($0.coordinate) }
    }
}

extension CLLocationCoordinate2D {
    init(_ coord: Coordinate) {
        self.init(latitude: coord.latitude, longitude: coord.longitude)
    }

    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        return MKMapPoint(self).distance(to: MKMapPoint(other))
    }
}

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        return (pow(other.x-x, 2) + pow(other.y-y, 2)).squareRoot()
    }
}
