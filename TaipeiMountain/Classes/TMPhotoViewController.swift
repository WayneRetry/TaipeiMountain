import UIKit
import Photos

public class TMPhotoViewController: UIViewController {
    
    
    var albums = [Album]()
    var currentAlbum: Album?
    var payloadData = PayloadData()
    weak var delegate: TMPhotoPickerDelegate?
    let defaultStyleConfig: TMConfig
    private lazy var collectionView: UICollectionView = createCollectionView()
    private lazy var tableView: UITableView = createTableView()
    private lazy var statusView: StatusView = createStatusView()
    private lazy var titleView: NavTitleView = createNavTitleView()
    private let cellSize = (UIScreen.main.bounds.width - (3 - 1) * 2) / 3
    private let dataManager = TMImageDataManager()
    private var imageManager: PHCachingImageManager?
    private var expandedTopConstraint: NSLayoutConstraint?
    private var collapsedTopConstraint: NSLayoutConstraint?
    private var albumListExpanding: Bool = false
    private var animating: Bool = false
    private var previousPreheatRect = CGRect.zero
    
    public init(delegate: TMPhotoPickerDelegate, config: TMConfig) {
        self.defaultStyleConfig = config
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationitem()
        setLayout()
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: String(describing: ImageCell.self))
        tableView.register(AlbumCell.self, forCellReuseIdentifier: String(describing: AlbumCell.self))
        loadAlbum()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    public func preSelectImage(assets: [PHAsset]) {
        for asset in assets {
            let image = Image(asset: asset)
            payloadData.add(image)
        }
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(statusView)
        
        if #available(iOS 11.0, *) {
            expandedTopConstraint = view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0)
        } else {
            expandedTopConstraint = view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0)
            edgesForExtendedLayout = []
        }
        expandedTopConstraint?.isActive = false
        
        collapsedTopConstraint = view.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0)
        collapsedTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
            view.centerYAnchor.constraint(equalTo: statusView.centerYAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 0),
        ])
    }
    
    private func setNavigationitem() {
        let cameraItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraPress))
        cameraItem.tintColor = defaultStyleConfig.getNavigationBarItemColor()
        navigationItem.rightBarButtonItem = cameraItem
        
        let closeItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closePress))
        closeItem.tintColor = defaultStyleConfig.getNavigationBarItemColor()
        navigationItem.leftBarButtonItem = closeItem
        titleView.delegate = self
        navigationItem.titleView = titleView
        navigationController?.navigationBar.barStyle = defaultStyleConfig.darkMode ? .blackTranslucent : .default
        navigationController?.navigationBar.barTintColor = defaultStyleConfig.getNavigationBarTintColor()
    }
    
    private func changeRightItem(isDone: Bool) {
        if isDone {
            let doneItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(donePress))
            doneItem.tintColor = defaultStyleConfig.getNavigationBarItemColor()
            navigationItem.rightBarButtonItem = doneItem
        } else {
            let cameraItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraPress))
            cameraItem.tintColor = defaultStyleConfig.getNavigationBarItemColor()
            navigationItem.rightBarButtonItem = cameraItem
        }
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = defaultStyleConfig.getBackgroundColor()
        view.delaysContentTouches = false
        view.delegate = self
        view.dataSource = self
        return view
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = defaultStyleConfig.getBackgroundColor()
        tableView.separatorStyle = .none
        return tableView
    }
    
    private func createStatusView() -> StatusView {
        let statusView = StatusView(config: defaultStyleConfig)
        statusView.actionButton.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
        statusView.isHidden = true
        return statusView
    }
    
    private func createNavTitleView() -> NavTitleView {
        let titleView = NavTitleView(config: defaultStyleConfig)
        return titleView
    }
    
    private func loadAlbum() {
        TMCameraHelper.checkPhotoAuth { [weak self] (authorize) in
            if authorize {
                self?.imageManager = PHCachingImageManager()
                self?.albums = [Album]()
                self?.dataManager.fetch({ [weak self] (album) in
                    self?.albums.append(album)
                    if self?.albums.isEmpty == false && album.collection.assetCollectionSubtype == .smartAlbumUserLibrary && self?.currentAlbum == nil {
                        DispatchQueue.main.async { [weak self] in
                            self?.currentAlbum = album
                            self?.titleView.setTitle(self?.currentAlbum?.collection.localizedTitle ?? "")
                            self?.collectionView.reloadData()
                        }
                    }
                }) { [weak self] (changeInstance) in
                    if let albums = self?.albums {
                        for album in albums {
                            if let fetchResult = album.fetchResult, let changeDetail = changeInstance.changeDetails(for: fetchResult) {
                                if changeDetail.insertedIndexes != nil {
                                    for insertObject in changeDetail.insertedObjects {
                                        album.items.insert(Image(asset: insertObject), at: 0)
                                    }
                                }
                                
                                if changeDetail.removedIndexes != nil {
                                    for removeObject in changeDetail.removedObjects {
                                        let image = Image(asset: removeObject)
                                        album.remove(image)
                                        self?.payloadData.remove(image)
                                    }
                                }
                                
                                album.fetchResult = changeDetail.fetchResultAfterChanges
                                
                                if let currnetAlubm = self?.currentAlbum, currnetAlubm.collection.localIdentifier == album.collection.localIdentifier {
                                    DispatchQueue.main.async {
                                        self?.collectionView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.statusView.isHidden = false
                }
            }
        }
    }
    
    private func setCurrentAlbum(_ album: Album) {
        DispatchQueue.main.async { [weak self] in
            self?.currentAlbum = album
            self?.titleView.setTitle(self?.currentAlbum?.collection.localizedTitle ?? "")
            self?.collectionView.reloadData()
            self?.toggleAlbumList()
        }
    }
    
    @objc private func openSetting() {
        let alertView = UIAlertController(title: "此功能需要相片存取權", message: "在設定中允許取用照片", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "開啟設定", style: .default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }))
        alertView.addAction(UIAlertAction(title: "稍後再說", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    @objc private func cameraPress() {
        presentCameraCapture(delegate: self)
    }
    
    @objc private func donePress() {
        
        let imageManager = PHImageManager()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true
        options.progressHandler = { [weak self] (progress, error, stop, info) in
            self?.delegate?.photoDownloadProgress(picker: self, progress: progress, error: error)
        }
        var tempData: [(image: UIImage, asset: PHAsset, index: Int)] = []
        var imagesCount = payloadData.images.count
        for (index, origenalImage) in payloadData.images.enumerated()  {
            imageManager.requestImageData(for: origenalImage.asset, options: options, resultHandler: { [weak self] (data, _, _, _) in
                
                if let data = data, let image = UIImage(data: data) {
                    tempData.append((image: image, asset: origenalImage.asset, index: index))
                }
                imagesCount -= 1
                if imagesCount <= 0 {
                    tempData.sort(by: {$0.index < $1.index})
                    let images = tempData.compactMap{ return (image: $0.image, asset: $0.asset) }
                    self?.delegate?.photoPickerViewController(picker: self, images: images)
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    
    @objc private func closePress() {
        if albumListExpanding {
            toggleAlbumList()
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func toggleAlbumList() {
        guard !animating else { return }
        animating = true
        albumListExpanding = !albumListExpanding
        if albumListExpanding {
            collapsedTopConstraint?.isActive = false
            expandedTopConstraint?.isActive = true
        } else {
            expandedTopConstraint?.isActive = false
            collapsedTopConstraint?.isActive = true
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] (_) in
                self?.animating = false
        })
    }
    
    private func reloadSelectCell() {
        for case let cell as ImageCell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell) {
                reloadSelectCell(cell, indexPath: indexPath)
            }
        }
    }
    
    private func reloadSelectCell(_ cell: ImageCell, indexPath: IndexPath) {
        if let item = currentAlbum?.items[indexPath.item], let index = payloadData.images.firstIndex(of: item) {
            cell.selectedView.setSelect(index)
        } else {
            cell.selectedView.resetSelect()
        }
    }
}

extension TMPhotoViewController: TMPhotoPickerDelegate {
    
    public func didReceiveAccessDenied() {
        delegate?.didReceiveAccessDenied()
    }
    
    public func photoPickerViewController(picker: TMPhotoViewController?, images: [(image: UIImage, asset: PHAsset)]) {
        delegate?.photoPickerViewController(picker: picker, images: images)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        delegate?.dismiss(animated: true, completion: nil)
        delegate?.imagePickerController?(picker, didFinishPickingMediaWithInfo: info)
    }
    
    public func photoDownloadProgress(picker: TMPhotoViewController?, progress: Double, error: Error?) {
        delegate?.photoDownloadProgress(picker: picker, progress: progress, error: error)
    }
}

extension TMPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAlbum?.items.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell
        cell.config = defaultStyleConfig
        let size = CGSize(width: cellSize * UIScreen.main.scale, height: cellSize * UIScreen.main.scale)
        if let item = currentAlbum?.items[indexPath.item] {
            cell.representedAssetIdentifier = item.asset.localIdentifier
            imageManager?.requestImage(for: item.asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, _) in
                if cell.representedAssetIdentifier == item.asset.localIdentifier {
                    cell.imageView.image = image
                }
            }
        }
        reloadSelectCell(cell, indexPath: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = currentAlbum?.items[indexPath.item] {
            if payloadData.images.contains(item) {
                payloadData.remove(item)
            } else {
                if defaultStyleConfig.selectImageLimit > 0 && defaultStyleConfig.selectImageLimit > payloadData.images.count {
                    payloadData.add(item)
                }
            }
        }
        reloadSelectCell()
        changeRightItem(isDone: payloadData.images.isEmpty == false)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .compactMap { indexPath in currentAlbum?.items[indexPath.item].asset }
        let removedAssets = removedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .compactMap { indexPath in currentAlbum?.items[indexPath.item].asset }
        
        // Update the assets the PHCachingImageManager is caching.
        let thumbnailSize = CGSize(width: cellSize * UIScreen.main.scale, height: cellSize * UIScreen.main.scale)
        TMCameraHelper.checkPhotoAuth { [weak self] (authorize) in
            if authorize {
                self?.imageManager?.startCachingImages(for: addedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
                self?.imageManager?.stopCachingImages(for: removedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
            }
        }
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}

extension TMPhotoViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlbumCell.self), for: indexPath) as! AlbumCell
        cell.config = defaultStyleConfig
        let album = albums[indexPath.row]
        if let item = album.items.first {
            cell.albumImageView.tm_loadImage(item.asset)
        }
        cell.albumNameLabel.text = album.collection.localizedTitle
        cell.photosCountLabel.text = String(album.items.count)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
        setCurrentAlbum(album)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension TMPhotoViewController: NavTitleViewDelegate {
    func navigationTitlePress() {
        tableView.reloadData()
        toggleAlbumList()
    }
}

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}
