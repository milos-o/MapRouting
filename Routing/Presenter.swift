import MapKit

struct Presenter {
    private var tracks: [Track:MKPolygon] = [:]

    var boundingRect: MKMapRect {
        let boundingRects = tracks.values.map { $0.boundingMapRect }
        return boundingRects.reduce(MKMapRect.null) { $0.union($1) }
    }

    mutating func add(_ track: Track) -> MKPolygon {
        let coords = track.clCoordinates
        let polygon = MKPolygon(coordinates: coords, count: coords.count)
        tracks[track] = polygon
        return polygon
    }

    func track(for polygon: MKPolygon) -> Track? {
        return tracks.first(where: { (track, poly) in poly == polygon })?.key
    }

    func closest(to coord: CLLocationCoordinate2D) -> (Track, CLLocationCoordinate2D)? {
        let closestTrack: [
            (
                track: Track,
                closest: CLLocationCoordinate2D,
                distance: CLLocationDistance
            )
        ] = tracks.keys.map { track in
            let closest = track.clCoordinates
                .map { ($0, distance: $0.distance(to: coord)) }
                .min { c1, c2 in
                    c1.distance < c2.distance
                }!
            return (track, closest.0, closest.distance)
        }
        if let (track, closestPoint, _) = closestTrack.min(by: { tc1, tc2 in
            tc1.distance < tc2.distance
        }) {
            return (track, closestPoint)
        }
        return nil
    }
}
