//
//  ViewController.swift
//  Vimly
//
//  Created by Apple on 2/24/17.
//  Copyright © 2017 Chisel Cut Solutions. All rights reserved.
//

import UIKit
import Alamofire

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
            videosTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
            videosArray.removeAll()
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

        return UITableViewCell.init()
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

