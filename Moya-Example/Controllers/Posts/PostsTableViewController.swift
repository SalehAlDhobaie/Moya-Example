//
//  PostsTableViewController.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 3/12/17.
//  Copyright © 2017 Saleh AlDhobaie. All rights reserved.
//

import UIKit
import RxSwift

class PostsTableViewController: UITableViewController {

    let disposeBag : DisposeBag = DisposeBag()
    private var viewModel : PostViewModel = {
        let repo = PostRepoistoryImp()
        return PostViewModel(postRepo: repo)
    }()
    
    let activity = UIActivityIndicatorView(style: .gray)
    var tableViewData : [Post?] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        title = "Posts"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        referchBarButton()
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        if let item = viewModel.itemAtRow(row: indexPath.row){
            cell.textLabel?.text = item.body
        }
        
        return cell
    }
    func bind() {
        viewModel.isLoading.subscribe(onNext: { [unowned self] isLoading in
            if !isLoading {
                self.activity.stopAnimating()
                self.referchBarButton()
            }else {
                self.loadingUI()
            }
            
        }).disposed(by: disposeBag)
        
        viewModel.posts.subscribe(onNext: { [unowned self] result in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    // MARK: - Network Method
    @objc private func fetchPosts() {
        
        viewModel.fetchPosts(request: "")
        
        /*PostRepoistoryImp().fetchPost(request: "").subscribe(onNext: { [unowned self] result in
            self.activity.stopAnimating()
            self.referchBarButton()
            self.tableViewData = result
            self.tableView.reloadData()
        }, onError: { error in
            print(error.localizedDescription)
            self.activity.stopAnimating()
            self.referchBarButton()
            // this means there was a network failure - either the request
            // wasn't sent (connectivity), or no response was received (server
            // timed out).  If the server responds with a 4xx or 5xx error, that
            // will be sent as a ".success"-ful response.
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)*/
    }
    
    func referchBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchPosts))
    }
    func loadingUI() {
        activity.hidesWhenStopped = true
        activity.startAnimating()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activity)
    }
}
