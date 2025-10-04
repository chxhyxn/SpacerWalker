//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import AVFoundation
internal import Combine
import SwiftUI

@MainActor
class VideoFramePlayerViewModel: ObservableObject {
    @Published var currentImage: CGImage?

    private let asset: AVAsset
    private let imageGenerator: AVAssetImageGenerator

    private var currentTask: Task<Void, Never>?

    // 캐싱
    private var frameCache: [Int: URL] = [:]
    private let cacheFolder: URL = {
        let folder = FileManager.default.temporaryDirectory
            .appendingPathComponent("VideoFrames")
        try? FileManager.default.createDirectory(
            at: folder,
            withIntermediateDirectories: true
        )
        return folder
    }()

    init(path: String) {
        let url = Bundle.main.url(forResource: path, withExtension: "mp4")!
        self.asset = AVAsset(url: url)
        self.imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
    }

    private func cachePath(forFrame frame: Int) -> URL {
        return cacheFolder.appendingPathComponent("frame_\(frame).png")
    }

    private func saveImageToCache(_ image: CGImage, frame: Int) throws -> URL {
        let url = cachePath(forFrame: frame)
        let uiImage = UIImage(cgImage: image)
        if let data = uiImage.pngData() {
            try data.write(to: url)
        }
        frameCache[frame] = url
        return url
    }

    private func loadCachedImage(frame: Int) -> CGImage? {
        if let url = frameCache[frame], let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data)
        {
            return uiImage.cgImage
        } else {
            // 디스크에 존재하는지 확인
            let url = cachePath(forFrame: frame)
            if let data = try? Data(contentsOf: url),
               let uiImage = UIImage(data: data)
            {
                frameCache[frame] = url
                return uiImage.cgImage
            }
        }
        return nil
    }

    func updateFrame(progress: Double) {
        currentTask?.cancel()
        currentTask = Task {
            let duration = asset.duration.seconds
            guard duration.isFinite && duration > 0 else { return }

            let clampedProgress = max(0, min(1, progress))
            let seconds = clampedProgress * duration
            let frameIndex = Int(seconds * 24)

            if let cached = loadCachedImage(frame: frameIndex) {
                self.currentImage = cached
                return
            }

            let time = CMTime(seconds: seconds, preferredTimescale: 600)
            do {
                let cgImage = try await imageGenerator.cgImage(at: time)
                self.currentImage = cgImage
                try saveImageToCache(cgImage, frame: frameIndex)
            } catch {
                print("Failed to generate frame: \(error)")
            }
        }
    }
}

struct VideoFramePlayer: View {
    @Binding var progress: Double
    @StateObject private var viewModel: VideoFramePlayerViewModel

    init(path: String, progress: Binding<Double> = .constant(0.0)) {
        self._progress = progress
        _viewModel = StateObject(
            wrappedValue: VideoFramePlayerViewModel(path: path)
        )
    }

    var body: some View {
        GeometryReader { geo in
            if let img = viewModel.currentImage {
                Image(decorative: img, scale: 1.0, orientation: .up)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
        }
        .onAppear {
            viewModel.updateFrame(progress: progress)
        }
        .onChange(of: progress) { newProgress in
            viewModel.updateFrame(progress: newProgress)
        }
    }
}

extension AVAssetImageGenerator {
    func cgImage(at time: CMTime) async throws -> CGImage {
        try await withCheckedThrowingContinuation { continuation in
            self.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let image = image, result == .succeeded {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "AVAssetImageGeneratorError",
                            code: -1,
                            userInfo: nil
                        )
                    )
                }
            }
        }
    }
}
