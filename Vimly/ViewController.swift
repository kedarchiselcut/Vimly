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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getVideos(pageNumber: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getVideos(pageNumber: Int) {
        let parameters = [pageKey: pageNumber]
        let urlString = String(format: baseUrl + methodName, currentAlbumId)
        
        Alamofire.request(urlString, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                self.videosArray = response.result.value as! Array<Any>
                print(self.videosArray)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: Action methods
    
    @IBAction func nextButtonTapped() {
        videosArray.removeAll()
        currentAlbumId += 1
    }
    
    @IBAction func previousButtonTapped() {
        videosArray.removeAll()
        if currentAlbumId > 1 {
            currentAlbumId -= 1
        }
    }
    
}

