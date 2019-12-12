import Foundation
import Photos

public class Image: Equatable {
    
    public let asset: PHAsset
    
    public init(asset: PHAsset) {
        self.asset = asset
    }
}

public func == (lhs: Image, rhs: Image) -> Bool {
    return lhs.asset == rhs.asset
}
