import UIKit
import Photos

public class Album {
    
    public let collection: PHAssetCollection
    public var fetchResult: PHFetchResult<PHAsset>?
    public var items: [Image] = []
    
    public init(collection: PHAssetCollection) {
        self.collection = collection
        reload()
    }
    
    public func reload() {
        items = []
        
        fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions())
        fetchResult?.enumerateObjects({ (asset, count, stop) in
            if asset.mediaType == .image {
                self.items.append(Image(asset: asset))
            }
        })
    }
    
    public func fetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        return options
    }
    
    public func remove(_ image: Image) {
        guard let index = items.firstIndex(of: image) else { return }
        items.remove(at: index)
    }
}
