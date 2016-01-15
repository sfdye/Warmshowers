//
//  LazyImageTableViewController.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 15/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

class WSLazyImageTableViewController: UITableViewController {
    
    var lazyImageObjects = [AnyObject]()
    var imageDownloadsInProgress = [NSIndexPath: WSImageDownloader]()
    var placeHolderImageName: String?
    var placeHolderImage: UIImage? {
        guard let placeHolderImageName = placeHolderImageName else {
            return nil
        }
        return UIImage(named: placeHolderImageName)
    }
    
    
    // View life cycle
    
    deinit {
        terminateAllDownloads()
    }

    // MARK: Utiliies
    
    func getLazyImageDataSourceForIndexPath(indexPath: NSIndexPath) -> WSLazyImage? {
        
        guard lazyImageObjects.count > indexPath.row else {
            return nil
        }
        
        return lazyImageObjects[indexPath.row] as? WSLazyImage
    }
    
    // Sets the images for a table view cell at a given index path as either the image provided by the LazyImage data source or a placeholder
    //
    func setLazyImageForCell(cell: AnyObject, atIndexPath indexPath: NSIndexPath) {
        
        guard let object = getLazyImageDataSourceForIndexPath(indexPath), var cell = cell as? WSLazyImageTableViewCell else {
                return
        }
        
        // Show the image or a placholder
        if let image = object.lazyImage {
            cell.lazyImage = image
        } else {
            // Defer downloading images until scrolling ends
            if tableView.dragging == false && tableView.decelerating == false {
                startImageDownload(object, indexPath: indexPath)
            }
            cell.lazyImage = placeHolderImage
        }
    }
    
    // Downloads a objects image size profile image and updates the table view data source
    //
    func startImageDownload(object: WSLazyImage, indexPath: NSIndexPath) {
        
        if imageDownloadsInProgress[indexPath] == nil {
            
            // Create and start a imageDownloader object
            let imageDownloader = WSImageDownloader()
            imageDownloader.object = object
            imageDownloader.placeHolderImage = placeHolderImage
            imageDownloader.completionHandler = {
                
                // Update the cell with the objects profile image
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Sometimes this cast failes for the first screen of the tableview, but i don't know why.
                    if var cell = self.tableView.cellForRowAtIndexPath(indexPath) as? WSLazyImageTableViewCell {
                        cell.lazyImage = object.lazyImage
                    }
                })
                
                // Remove the downloader object from the downloads
                self.imageDownloadsInProgress.removeValueForKey(indexPath)
            }
            imageDownloadsInProgress[indexPath] = imageDownloader
            imageDownloader.startDownload()
        }
    }
    
    // Tries to download all the profile images for the objects on the screen
    //
    func loadImagesForObjectsOnScreen() {
        
        guard let visiblePaths = tableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visiblePaths {
            if let object = lazyImageObjects[indexPath.row] as? WSLazyImage {
                if object.lazyImage == nil {
                    startImageDownload(object, indexPath: indexPath)
                }
            }
        }
    }
    
    // Terminates all image downloads
    func terminateAllDownloads() {
        for (_, download) in imageDownloadsInProgress {
            download.cancelDownload()
        }
        imageDownloadsInProgress.removeAll()
    }
    
}
