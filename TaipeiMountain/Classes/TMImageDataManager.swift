//
//  TMImageDataManager.swift
//  Pods-TaipeiMountain_Example
//
//  Created by Wayne Lin on 2019/11/28.
//

import Photos
public class TMImageDataManager: NSObject, PHPhotoLibraryChangeObserver {
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    public func fetch(_ complete: @escaping (Album) -> Void) {
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
    }
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
    
    private func collectionSubtype(subtype: PHAssetCollectionSubtype) -> PHAssetCollectionType {
        return subtype.rawValue < PHAssetCollectionSubtype.smartAlbumGeneric.rawValue ? .album : .smartAlbum
    }
    
}
