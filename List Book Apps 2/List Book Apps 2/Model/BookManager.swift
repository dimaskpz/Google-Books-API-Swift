//
//  BookManager.swift
//  List Book Apps 2
//
//  Created by dimas pratama on 22/01/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//

import Foundation

protocol BookManagerDelegate{
    func didUpdateBook(_ bookManager: BookManager, book: [BookModel])
    func didFailWithError(error: Error)
}

struct BookManager {
    let bookURL = "https://www.googleapis.com/books/v1/volumes?"
    
    var delegate:BookManagerDelegate?
    
    func fetchBook(bookName:String) {
        
        let searchBook = bookName.replacingOccurrences(of: " ", with: "%20")
        
        let url = "\(bookURL)q=\(searchBook)"
        print(url)
        performRequest(with: url)
    }
    
    func performRequest(with urlString:String) {
        print("perform")
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let book = self.parseJSON(bookData: safeData) {
                        self.delegate?.didUpdateBook(self, book: book)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(bookData:Data) -> [BookModel]? {
        print("masuk parsejson")
        let decoder = JSONDecoder()
        
        do {
            print("do")
            let decodedData = try decoder.decode(BookData.self, from: bookData)
            let totalData = decodedData.items.count
            
            print(totalData)
            var book = [BookModel]()
            
            for index in 0...totalData - 1 {
                let title = decodedData.items[index].volumeInfo.title
                
                var authors:[String]! = decodedData.items[index].volumeInfo.authors
                if authors == nil {
                    authors = [""]
                }
                                
                var year = decodedData.items[index].volumeInfo.publishedDate
                if year == nil {
                    year = ""
                }
                
                var thumbnail = decodedData.items[index].volumeInfo.imageLinks?.thumbnail
                if thumbnail == nil {
                    thumbnail = ""
                }
                
                var rating = decodedData.items[index].volumeInfo.averageRating
                if rating == nil {
                    rating = 0
                }
                
                let row = BookModel(title: title, authors: authors, year:year!, thumbnail: thumbnail!, averageRating: rating!)
                book.append(row)
            }
        
            return book
            
        } catch {
            print(error)
            return nil
        }
        
    }
        
}
