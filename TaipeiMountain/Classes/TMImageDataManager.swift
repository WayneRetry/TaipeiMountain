import Photos
public class TMImageDataManager: NSObject, PHPhotoLibraryChangeObserver {
    
    var changeInstance: ((PHChange) -> Void)?
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    public func fetch(_ complete: @escaping (Album) -> Void, changeInstance: @escaping (PHChange) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let `self` = self else { return }
            let subtypes: [PHAssetCollectionSubtype] = [.smartAlbumUserLibrary, .smartAlbumFavorites, .albumRegular]
            for type in subtypes {
                let albumsFetchResults = PHAssetCollection.fetchAssetCollections(with: self.collectionSubtype(subtype: type), subtype: type, options: nil)
                albumsFetchResults.enumerateObjects { (collection, _, _) in
                    let album = Album(collection: collection)
                    if album.items.isEmpty == false {
                        complete(album)
                    }
                }
            }
        }
        PHPhotoLibrary.shared().register(self)
        self.changeInstance = changeInstance
    }
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.changeInstance?(changeInstance)
    }
    
    private func collectionSubtype(subtype: PHAssetCollectionSubtype) -> PHAssetCollectionType {
        return subtype.rawValue < PHAssetCollectionSubtype.smartAlbumGeneric.rawValue ? .album : .smartAlbum
    }
    
}
