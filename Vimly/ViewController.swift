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
    var selectedRowIndex: Int = -1
    var selectedRowDescriptionHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupVideosList()
        
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
                print(self.videosArray)
                
                if ((response.result.value as! Array<Any>).count > 0) {
                    self.videosTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupVideosList() {
        if (videosArray != nil) {
            videosArray.removeAll()
            videosTableView.reloadData()
        }
        currentPageNumber = 1
        selectedRowIndex = -1

        albumTitleLabel.text = String(format: "Album %d", currentAlbumId)
        getVideos()
    }
    
    func setupCell(videoCell: VideoTableViewCell, withDataObject videoObject: Dictionary<String, Any>) {
        videoCell.videoTitleTextView.text = videoObject[titleKey] as? String
        videoCell.usernameLabel.text = videoObject[usernameKey] as? String
        videoCell.uploadDateLabel.text = videoObject[uploadDateKey] as? String
        
        setupCellImage(forImageView: videoCell.videoThumbnailImage, withUrl: videoObject[videoThumbnailKey] as! String, andPlaceholder: UIImage(named: "placeholder-video.png")!)
        setupCellImage(forImageView: videoCell.userThumbnailImage, withUrl: videoObject[userThumbnailKey] as! String, andPlaceholder: UIImage(named: "placeholder-profile.png")!)
        
        videoCell.userThumbnailImage.layoutIfNeeded()
        videoCell.userThumbnailImage.layer.cornerRadius = videoCell.userThumbnailImage.frame.size.height/2
        
        videoCell.descriptionLabel.text = videoObject[descriptionKey] as? String
        videoCell.layoutIfNeeded()
        
        videoCell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func setupCellImage(forImageView cellImageView: UIImageView, withUrl imageUrlString: String, andPlaceholder placeholderImage: UIImage) {
        let imageUrl = URL(string: imageUrlString)!
        let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cellImageView.frame.size,
            radius: 0.0
        )
        cellImageView.af_setImage(
            withURL: imageUrl,
            placeholderImage: placeholderImage,
            filter: imageFilter,
            imageTransition: .crossDissolve(0.2)
        )
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
            setupCell(videoCell: videoCell, withDataObject: videoObject)
        }
        
        return videoCell
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let rowHeight: CGFloat = screenSize.width*CGFloat(benchmarkHeight/benchmarkScreenWidth)

        if indexPath.row == selectedRowIndex {
            return rowHeight + selectedRowDescriptionHeight + 2*CGFloat(descriptionLabelMargin)
        }
        return rowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectedRowIndex {
            selectedRowIndex = indexPath.row
        } else {
            selectedRowIndex = -1
        }
        
        //Not the best way to do this?
        let selectedCell: VideoTableViewCell = videosTableView.cellForRow(at: indexPath) as! VideoTableViewCell
        selectedRowDescriptionHeight = selectedCell.descriptionHeight
        
        videosTableView.beginUpdates()
        videosTableView.endUpdates()
    }
    
    //MARK: Action methods
    
    @IBAction func nextButtonTapped() {
        currentAlbumId += 1
        setupVideosList()
    }
    
    @IBAction func previousButtonTapped() {
        if currentAlbumId > 1 {
            currentAlbumId -= 1
        }
        setupVideosList()
    }
    
}

