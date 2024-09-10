//
//  ContentView.swift
//  bookInfoSwiftUI
//
//  Created by Duyen Vu on 2/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bookInfoDictionary: infoDictionary = infoDictionary()

    @State private var title: String
    @State private var author: String
    @State private var genre: String
    @State private var price: String 

    @State private var searchTitle: String
    @State private var searchAuthor: String
    @State private var searchGenre: String
    @State private var searchPrice: String

    @State private var deleteTitle: String

    init() {
        _title = State(initialValue: "")
        _author = State(initialValue: "")
        _genre = State(initialValue: "")
        _price = State(initialValue: "")

        _searchTitle = State(initialValue: "")
        _searchAuthor = State(initialValue: "")
        _searchGenre = State(initialValue: "")
        _searchPrice = State(initialValue: "")

        _deleteTitle = State(initialValue: "")
    }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                NaviView(btitle: $title, bauthor: $author, bgenre: $genre, bprice: $price, bdelete: $deleteTitle, bModel: bookInfoDictionary)

                dataEnterView(dtitle: $title, dauthor: $author, dgenre: $genre, dprice: $price)

                Spacer()

                SearchView(stitle: $searchTitle, sauthor: $searchAuthor, sgenre: $searchGenre, sprice: $searchPrice, bModel: bookInfoDictionary)

                Spacer()

                ToolView(search: "", sTitle: $searchTitle, sAuthor: $searchAuthor, sGenre: $searchGenre, sPrice: $searchPrice, bModel: bookInfoDictionary)
            }

            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Book Info")
        }
    }
}

struct NaviView: View {
    @Binding var btitle: String
    @Binding var bauthor: String
    @Binding var bgenre: String
    @Binding var bprice: String
    @Binding var bdelete: String
    
    @State private var showingDeleteAlert = false
    @State private var showingAddSuccessAlert = false
    @State private var showingInvalidPriceAlert = false
    @ObservedObject var bModel: infoDictionary
    
    var body: some View {
        Text("")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        print(bModel.getCount())
                        
                        if let price = Double(bprice) {
                            bModel.addBook(btitle, bauthor, bgenre, price)
                            
                            showingAddSuccessAlert = true
                            
                            btitle = ""
                            bauthor = ""
                            bgenre = ""
                            bprice = ""
                            
                        } else {
                            showingInvalidPriceAlert = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print(btitle)
                        showingDeleteAlert = true
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }.alert("Delete Record", isPresented: $showingDeleteAlert, actions: {
                TextField("Enter Book Title", text: $bdelete)
                
                Button("Delete", action: {
                    let title = String(bdelete)
                    bModel.deleteBook(title: title)
                    showingDeleteAlert = false
                })
                
                Button("Cancel", role: .cancel, action: {
                    showingDeleteAlert = false
                })
            }, message: {
                Text("Please enter title to Search.")
            })
            .alert("Book Added Successfully", isPresented: $showingAddSuccessAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Invalid Format. Please Re-enter!", isPresented: $showingInvalidPriceAlert) {
                Button("OK", role: .cancel) { }
            }
    }
}

struct ToolView: View {
    @State private var currentIndex: Int = 0
    @State var showingSearchAlert = false
    @State var search: String
    @State var showingReachLeftAlert = false
    @State var showingReachRightAlert = false
    
    @Binding var sTitle: String
    @Binding var sAuthor: String
    @Binding var sGenre: String
    @Binding var sPrice: String
    
    @ObservedObject var bModel: infoDictionary
    
    var body: some View {
        Text("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingSearchAlert = true
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                    })
                    .padding()
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        if let nextBook = bModel.getNextBook(currentIndex: currentIndex) {
                            currentIndex += 1
                            sTitle = nextBook.bookTitle ?? "No Title"
                            sAuthor = nextBook.bookAuthor ?? "No Author"
                            sGenre = nextBook.bookGenre ?? "No Genre"
                            sPrice = String(nextBook.bookPrice ?? 0)
                            showingReachLeftAlert = false
                        } else {
                            showingReachLeftAlert = true
                        }
                    }, label: {
                        Image(systemName: "arrow.left.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                            .foregroundColor(.blue)
                            .padding(.bottom)
                    })
                    .padding()
                    
                    Button(action: {
                        if let previousBook = bModel.getPreviousBook(currentIndex: currentIndex) {
                            currentIndex -= 1
                            sTitle = previousBook.bookTitle ?? "No Title"
                            sAuthor = previousBook.bookAuthor ?? "No Author"
                            sGenre = previousBook.bookGenre ?? "No Genre"
                            sPrice = String(previousBook.bookPrice ?? 0)
                            showingReachRightAlert = false
                        } else {
                            showingReachRightAlert = true
                        }
                    }, label: {
                        Image(systemName: "arrow.right.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                            .foregroundColor(.blue)
                            .padding(.bottom)
                    })
                    .padding()
                }
            }
            .alert("Reached the beginning of the collection", isPresented: $showingReachLeftAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Reached the end of the collection", isPresented: $showingReachRightAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Search Record", isPresented: $showingSearchAlert, actions: {
                VStack {
                    TextField("Enter Title", text: $search)
                    
                    HStack {
                        Spacer()
                        Button("Search", action: {
                            let found = String(search)
                            let book =  bModel.searchBook(title: found)
                            if let x = book {
                                sTitle = x.bookTitle!
                                sAuthor = String(x.bookAuthor!)
                                sGenre = String(x.bookGenre!)
                                sPrice = String(x.bookPrice!)
                            } else {
                                sTitle = "No Record"
                                sAuthor = "No Record"
                                sGenre = "No Record"
                                sPrice = " No Record"
                                print("No Record")
                            }
                            showingSearchAlert = false
                        })
                        .padding()
                        
                        Button("Cancel", role: .cancel, action: {
                            showingSearchAlert = false
                        })
                        .padding()
                    }
                    Spacer()
                }
            }, message: {
                Text("Enter Book Title to Search")
            })
    }
}

struct dataEnterView: View
{
    @Binding var dtitle: String
    @Binding var dauthor: String
    @Binding var dgenre: String
    @Binding var dprice: String

    var body: some View {
        VStack {
            HStack {
                Text("Enter Book Information:")
                    .bold()
                    Spacer()
            }
            .padding(.bottom, 30)
            
            HStack {
                Text("Title:     ")
                TextField("Enter here", text: $dtitle)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("Author: ")
                TextField("Enter here", text: $dauthor)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("Genre:  ")
                TextField("Enter here", text: $dgenre)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("Price:    ")
                TextField("Enter here", text: $dprice)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

struct SearchView: View {
    @Binding var stitle: String
    @Binding var sauthor: String
    @Binding var sgenre: String
    @Binding var sprice: String
    
    @ObservedObject var bModel: infoDictionary
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            Text("Search Result")
                .bold()
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Title:    ")
                    TextField("", text: $stitle)
                        .textFieldStyle(.plain)
                        .disabled(!isEditing)
                        .disabled(isEditing)
                }
                
                HStack {
                    Text("Author:")
                    TextField("", text: $sauthor)
                        .textFieldStyle(.plain)
                        .disabled(!isEditing)
                }
                
                HStack {
                    Text("Genre: ")
                    TextField("", text: $sgenre)
                        .textFieldStyle(.plain)
                        .disabled(!isEditing)
                }
                
                HStack {
                    Text("Price:  ")
                    TextField("", text: $sprice)
                        .textFieldStyle(.plain)
                        .disabled(!isEditing)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                        if !isEditing {
                            let editedBook = bookRecord(title: stitle, author: sauthor, genre: sgenre, price: Double(sprice) ?? 0)
                            bModel.editBook(title: stitle, newBook: editedBook)
                        }
                    }, label: {
                        Text(isEditing ? "Save" : "Edit")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                    .padding(.bottom, 10)
                    Spacer()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
