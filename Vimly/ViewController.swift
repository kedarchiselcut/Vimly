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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getVideos(albumId: Int, pageNumber: Int) {
        let parameters = ["page": pageNumber]
        let urlString = String(format: "http://vimeo.com/api/v2/album/%d/videos.json?page=%d", albumId, pageNumber)
        
        Alamofire.request(urlString, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                let videosArray: Array<Any> = response.result.value as! Array<Any>
                print(videosArray)
                
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
        
    }
    
    @IBAction func previousButtonTapped() {
        
    }

}

