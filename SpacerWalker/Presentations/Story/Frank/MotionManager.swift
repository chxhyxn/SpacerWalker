//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import CoreGraphics
import CoreMotion
import Foundation

final class MotionManager {
    let shakeDegreesStream: AsyncStream<Int>
    let tiltUnitStream: AsyncStream<CGVector>

    private var shakeDegreesContinuation: AsyncStream<Int>.Continuation?
    private var tiltUnitContinuation: AsyncStream<CGVector>.Continuation?

    private let updateInterval: TimeInterval
    private var shakeCooldown: TimeInterval
    private var _lastShakeAt: Date // .now()랑 coolDown만큼 차이나는지 비교되는지 변수

    private let startThreshold: Double
    private let referenceFrame: CMAttitudeReferenceFrame

    private let motionManager = CMMotionManager()

    init(
        updateInterval: TimeInterval = 1.0 / 60.0,
        shakeCooldown: TimeInterval = 0.01,
        startThreshold: Double = 0.4,
        referenceFrame: CMAttitudeReferenceFrame = .xArbitraryZVertical
    ) {
        var cont: AsyncStream<Int>.Continuation!
        self.shakeDegreesStream = AsyncStream<Int>(
            bufferingPolicy: .bufferingNewest(1)
        ) { c in
            cont = c
        }
        self.shakeDegreesContinuation = cont

        var contTilt: AsyncStream<CGVector>.Continuation!
        self.tiltUnitStream = AsyncStream<CGVector>(
            bufferingPolicy: .bufferingNewest(1)
        ) { c in
            contTilt = c
        }
        self.tiltUnitContinuation = contTilt

        self.updateInterval = updateInterval
        self.shakeCooldown = shakeCooldown
        self._lastShakeAt = .distantPast
        self.startThreshold = startThreshold
        self.referenceFrame = referenceFrame
    }

    func start(
        shakeCooldown: TimeInterval = 0.01
    ) {
        self.shakeCooldown = shakeCooldown

        stopAll()

        motionManager.deviceMotionUpdateInterval = updateInterval

        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.startDeviceMotionUpdates(using: referenceFrame, to: .main) { [weak self] data, _ in
            if let data {
                self?.handleShakeDetection(from: data.userAcceleration)
                self?.handleTilt(gravity: data.gravity)
            }
        }
    }

    func stopAll() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
    }

    private func handleShakeDetection(
        from accel: CMAcceleration
    ) {
        let now = Date()

        let ax = accel.x
        let ay = accel.y
        let magnitude = sqrt(ax * ax + ay * ay)

        if magnitude >= startThreshold,
           now.timeIntervalSince(_lastShakeAt) >= shakeCooldown
        {
            let degrees =
                (Int((atan2(ay, ax) * -180.0 / .pi).rounded()) + 270) % 360

            shakeDegreesContinuation?.yield(degrees)
            _lastShakeAt = now
            return
        }
    }

    private func handleTilt(gravity g: CMAcceleration) {
        let ux = max(-1.0, min(1.0, g.x))
        let uy = max(-1.0, min(1.0, -g.y))
        tiltUnitContinuation?.yield(CGVector(dx: ux, dy: uy))
    }

    deinit {
        shakeDegreesContinuation?.finish()
        tiltUnitContinuation?.finish()
        stopAll()
    }
}
