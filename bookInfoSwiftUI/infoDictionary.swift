//
//  infoDictionary.swift
//  personInfoSwiftUI
//
//  Created by Duyen Vu on 2/13/24.
//

import Foundation
class infoDictionary: ObservableObject
{
    // dictionary that stores book records
    @Published var infoRepository : [String:bookRecord] = [String:bookRecord] ()
    init() { }
  
    func addBook(_ bookTitle:String, _ bookAuthor:String, _ bookGenre:String, _ bookPrice:Double)
    {
        let bRecord =  bookRecord(title: bookTitle, author: bookAuthor, genre: bookGenre, price: bookPrice)
        infoRepository[bRecord.bookTitle!] = bRecord
        
    }
    
    func getCount() -> Int {
        return infoRepository.count
    }
    
    func add(b:bookRecord) {
        print("adding" + b.bookAuthor!)
        infoRepository[b.bookTitle!] = b
    }
    
    func deleteBook(title:String) {
        infoRepository[title] = nil
    }
    
    func searchBook(title:String) -> bookRecord? {
        var found = false
        
        for (bookTitle, _) in infoRepository {
            if bookTitle == title {
                found = true
                break
            }
        }
        
        if found {
           return infoRepository[title]
        } else {
            return nil
        }
    }
    
    func editBook(title: String, newBook: bookRecord) {
        if let existingBook = infoRepository[title] {
            existingBook.bookAuthor = newBook.bookAuthor
            existingBook.bookGenre = newBook.bookGenre
            existingBook.bookPrice = newBook.bookPrice
        }
    }
    
    func getNextBook(currentIndex: Int) -> bookRecord? {
        let allBooks = Array(infoRepository.values)
        guard currentIndex < allBooks.count - 1 else {
            return nil // Reached the end
        }
        return allBooks[currentIndex + 1]
    }

    func getPreviousBook(currentIndex: Int) -> bookRecord? {
        let allBooks = Array(infoRepository.values)
        guard currentIndex > 0 else {
            return nil // Reached the beginning
        }
        return allBooks[currentIndex - 1]
    }
}
