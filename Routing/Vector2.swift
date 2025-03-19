import UIKit
import CoreLocation

protocol Vector2 {
    associatedtype Component: Numeric
    var x: Component { get }
    var y: Component { get }
    init(x: Component, y: Component)
}

extension Vector2 {
    func dot(_ other: Self) -> Component {
        return (x * other.x) + (y * other.y)
    }

    static func -(l: Self, r: Self) -> Self {
        return Self(x: l.x-r.x, y: l.y-r.y)
    }

    static func +(l: Self, r: Self) -> Self {
        return Self(x: l.x+r.x, y: l.y+r.y)
    }

    static func *(l: Component, r: Self) -> Self {
        return Self(x: l*r.x, y: l*r.y)
    }
}

extension Vector2 where Component: FloatingPoint {
    func closestPoint(on line: (Self, Self)) -> Self {
        let s1 = line.0
        let s2 = line.1 - s1
        let p = self - s1
        let lambda = s2.dot(p) / s2.dot(s2)
        return s1 + lambda * s2
    }
}

extension CGPoint: Vector2 {}

extension CLLocationCoordinate2D: Vector2 {
    var x: Double { return longitude }
    var y: Double { return latitude }

    typealias Component = Double

    init(x: Component, y: Component) {
        self.init(latitude: x, longitude: y)
    }
}
