//
//  bookRecord.swift
//  bookInfoSwiftUI
//
//  Created by Duyen Vu on 2/13/24.
//

import Foundation
class bookRecord
{
    var bookTitle:String? = nil
    var bookAuthor:String? = nil
    var bookGenre:String? = nil
    var bookPrice:Double? = nil
    
    init(title:String, author:String, genre:String, price:Double) {
        self.bookTitle = title
        self.bookAuthor = author
        self.bookGenre = genre
        self.bookPrice = price
    }
    
    func change_bookTitle(newTitle:String)
    {
        self.bookTitle = newTitle;
    }
    
    func change_bookAuthor(newAuthor:String)
    {
        self.bookAuthor = newAuthor;
    }
    
    func change_bookGenre(newGenre:String)
    {
        self.bookGenre = newGenre;
    }
    
    func change_bookPrice(newPrice:Double)
    {
        self.bookPrice = newPrice;
    }
    
}
