import UIKit
import Photos

public class Album {
    
    public let collection: PHAssetCollection
    public var items: [Image] = []
    
    init(collection: PHAssetCollection) {
        self.collection = collection
        reload()
    }
    
    func reload() {
        items = []
        
        let itemsFetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions())
        itemsFetchResult.enumerateObjects({ (asset, count, stop) in
            if asset.mediaType == .image {
                self.items.append(Image(asset: asset))
            }
        })
    }
    
    func fetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        return options
    }
}

public class Image: Equatable {
    
    public let asset: PHAsset
    
    init(asset: PHAsset) {
        self.asset = asset
    }
}

public func == (lhs: Image, rhs: Image) -> Bool {
    return lhs.asset == rhs.asset
}

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
