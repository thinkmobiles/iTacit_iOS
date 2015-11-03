//
//  ImageCacheManager.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ImageCacheManager {

	static let sharedInstance = ImageCacheManager()

	let imageCache = NSCache()

	func imageForURL(imageURL: NSURL, completion: (image: UIImage) -> Void) -> NSURLSessionTask? {
		if let image = imageCache.objectForKey(imageURL) as? UIImage {
			completion(image: image)
			return nil
		} else {
			let request = NSMutableURLRequest(URL: imageURL)
			request.HTTPMethod = URLRequestMethod.GET.rawValue
			let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, _, _) -> Void in
				dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
					if let data = data, image = UIImage(data: data) {
						self?.imageCache.setObject(image, forKey: imageURL)
						completion(image: image)
					}
				}
			})
			task.resume()
			return task
		}
	}

}