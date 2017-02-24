//
//  ViewController.swift
//  Vimly
//
//  Created by Apple on 2/24/17.
//  Copyright © 2017 Chisel Cut Solutions. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var videosTableView: UITableView!
    @IBOutlet var albumTitleLabel: UILabel!
    var videosArray: Array<Any>!
    var currentAlbumId: Int = 58
    var currentPageNumber: Int = 1
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupScreen()
        
        let cellNib = UINib(nibName: "VideoTableViewCell", bundle: nil)
        videosTableView.register(cellNib, forCellReuseIdentifier: CellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getVideos() {
        let parameters = [pageKey: currentPageNumber]
        let urlString = String(format: baseUrl + methodName, currentAlbumId)
        
        Alamofire.request(urlString, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                if (self.videosArray != nil) {
                    self.videosArray.append(contentsOf: response.result.value as! Array<Any>)
                } else {
                    self.videosArray = response.result.value as! Array<Any>
                }
                
                if ((response.result.value as! Array<Any>).count > 0) {
                    self.videosTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupScreen() {
        if (videosArray != nil) {
            videosArray.removeAll()
            videosTableView.reloadData()
        }
        currentPageNumber = 1

        albumTitleLabel.text = String(format: "Album %d", currentAlbumId)
        getVideos()
    }
    
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (videosArray != nil) {
            return videosArray.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == videosArray.count - 1 && currentPageNumber < 3 {
            currentPageNumber += 1
            getVideos()
        }

        let videoCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! VideoTableViewCell
        if videosArray != nil {
            let videoObject: Dictionary<String, Any> = videosArray[indexPath.row] as! Dictionary<String, Any>
            
            videoCell.videoTitleTextView.text = videoObject[titleKey] as? String
            videoCell.usernameLabel.text = videoObject[usernameKey] as? String
            videoCell.uploadDateLabel.text = videoObject[uploadDateKey] as? String
            
            let videoUrl = URL(string: videoObject[videoThumbnailKey] as! String)!
            let videoPlaceholderImage = UIImage(named: "placeholder-video.png")!
            let videoFilter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: videoCell.videoThumbnailImage.frame.size,
                radius: 0.0
            )
            videoCell.videoThumbnailImage.af_setImage(
                withURL: videoUrl,
                placeholderImage: videoPlaceholderImage,
                filter: videoFilter,
                imageTransition: .crossDissolve(0.2)
            )
            
            let profileUrl = URL(string: videoObject[userThumbnailKey] as! String)!
            let profilePlaceholderImage = UIImage(named: "placeholder-profile.png")!
            let profileFilter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: videoCell.userThumbnailImage.frame.size,
                radius: 0.0
            )
            videoCell.userThumbnailImage.af_setImage(
                withURL: profileUrl,
                placeholderImage: profilePlaceholderImage,
                filter: profileFilter,
                imageTransition: .crossDissolve(0.2)
            )

        }
        
        return videoCell
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: Action methods
    
    @IBAction func nextButtonTapped() {
        currentAlbumId += 1
        setupScreen()
    }
    
    @IBAction func previousButtonTapped() {
        if currentAlbumId > 1 {
            currentAlbumId -= 1
        }
        setupScreen()
    }
    
}

