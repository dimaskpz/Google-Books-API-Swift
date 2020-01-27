//
//  BookViewController.swift
//  List Book Apps 2
//
//  Created by dimas pratama on 22/01/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var bookManager = BookManager()
    var bookModel:[BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchTextField.text = "harry%20potter"
        bookManager.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let book = searchTextField.text {
            bookManager.fetchBook(bookName: book)
        }
        searchTextField.text = ""
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(false)
        searchTextField.endEditing(true)
    }
}

extension BookViewController: BookManagerDelegate{
    func didUpdateBook(_ bookManager: BookManager, book: [BookModel]) {
        DispatchQueue.main.async {
            self.bookModel = []
            self.bookModel = book
            self.tableView.reloadData()
            print("proses async reload data")
            let indexPath = NSIndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension BookViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(bookModel.count)
        return bookModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! BookCell
        cell.label.text = bookModel[indexPath.row].title
        
        let totalAuthor = bookModel[indexPath.row].authors.count
        var allAuthors:String = ""
        for index in 0...totalAuthor - 1 {
            if index == 0 {
                allAuthors = bookModel[indexPath.row].authors[0]
            } else {
                allAuthors = allAuthors + ", \(bookModel[indexPath.row].authors[index])"
            }            
        }
        cell.authorsLabel.text = allAuthors
        
        if bookModel[indexPath.row].thumbnail != "" {
            let urlImage = URL(string: bookModel[indexPath.row].thumbnail)
            cell.bookImageView.sd_setImage(with: urlImage , completed: {
                (image, error, cacheType, url) in
                // your code
            })
        } else {
            cell.bookImageView.image = #imageLiteral(resourceName: "NoImage")
        }
        
        
        
        cell.cosmosView.rating = bookModel[indexPath.row].averageRating
        
        print(indexPath)
        return cell
    }
}

extension UIImageView{
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image  = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
