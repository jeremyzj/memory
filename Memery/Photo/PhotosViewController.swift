//
//  ViewController.swift
//  Memery
//
//  Created by 藏银 on 2017/9/17.
//  Copyright © 2017年 藏银. All rights reserved.
//

import UIKit
import Photos
import EZSwiftExtensions

class PhotosViewController: UITableViewController {
    
    var assetsFetchResults: PHFetchResult<PHAsset>? = nil
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    ///缩略图大小
    var assetGridThumbnailSize:CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "photo"
        
        PHPhotoLibrary.shared().register(self)
        
        resetCachedAssets()
        
        self.requestPhotoAuthorization()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assetGridThumbnailSize = CGSize(width:100, height : 100)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    func requestPhotoAuthorization() {
        
       let photosHelper = PhotosHelper()
        photosHelper.requestAuthorization(viewController: self) {
            [weak self] in
            self?.requestAsserts()
        }
        
    }
    
    func requestAsserts() {
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.includeAssetSourceTypes = .typeUserLibrary
        
        assetsFetchResults = PHAsset.fetchAssets(with: options)
        
        DispatchQueue.main.sync {
            updateCachedAssets()
            self.tableView.reloadData()
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
//        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
//        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
//
//        // Update only if the visible area is significantly different from the last preheated area.
//        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
//        guard delta > view.bounds.height / 3 else { return }
//
//        // Compute the assets to start caching and to stop caching.
//        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
//        let addedAssets = addedRects
//            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
//            .map { indexPath in assetsFetchResults?.object(at: indexPath.item) }
//        let removedAssets = removedRects
//            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
//            .map { indexPath in assetsFetchResults?.object(at: indexPath.item) }
//
//        // Update the assets the PHCachingImageManager is caching.
//        imageManager.startCachingImages(for: addedAssets as! [PHAsset],
//                                        targetSize: assetGridThumbnailSize, contentMode: .aspectFill, options: nil)
//        imageManager.stopCachingImages(for: removedAssets as! [PHAsset],
//                                       targetSize: assetGridThumbnailSize, contentMode: .aspectFill, options: nil)
//
        // Store the preheat rect to compare against in the future.
//        previousPreheatRect = preheatRect
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PhotosTimeLineCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTimeLineCell") as! PhotosTimeLineCell
        if let asset = self.assetsFetchResults?[indexPath.row] {
            
            let date = asset.creationDate?.toString(format: "yyyy-MM-dd")
            //获取缩略图
            self.imageManager.requestImage(for: asset,
                                           targetSize: assetGridThumbnailSize,
                                           contentMode: PHImageContentMode.aspectFill,
                                           options: nil) {
                                            (image, info) in
                                            cell.loadData(title: date!,
                                                          image: image!,
                                                          isTop: indexPath.row == 0,
                                                          isBottom: indexPath.row + 1 == self.assetsFetchResults?.count )
            }
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124.0
    }

    
}


// MARK: PHPhotoLibraryChangeObserver
extension PhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: assetsFetchResults!)
            else { return }
        
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            assetsFetchResults = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                // If we have incremental diffs, animate them in the collection view.
//                guard let collectionView = self.collectionView else { fatalError() }
//                collectionView.performBatchUpdates({
//                    // For indexes to make sense, updates must be in this order:
//                    // delete, insert, reload, move
//                    if let removed = changes.removedIndexes, removed.count > 0 {
//                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
//                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    if let changed = changes.changedIndexes, changed.count > 0 {
//                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
//                    }
//                    changes.enumerateMoves { fromIndex, toIndex in
//                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                to: IndexPath(item: toIndex, section: 0))
//                    }
//                })
            } else {
                // Reload the collection view if incremental diffs are not available.
//                collectionView!.reloadData()
            }
            resetCachedAssets()
        }
    }
}

