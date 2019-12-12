import Foundation

public class PayloadData {
    public var images: [Image] = []
    
    public func add(_ image: Image, newlyTaken: Bool = false) {
      guard !images.contains(image) else { return }
      images.append(image)
    }
    
    public func remove(_ image: Image) {
        guard let index = images.firstIndex(of: image) else { return }
        images.remove(at: index)
    }
}
