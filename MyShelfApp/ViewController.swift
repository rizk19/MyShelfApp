//
//  ViewController.swift
//  MyShelfApp
//
//  Created by Rizki Faris on 27/04/22.
//


import UIKit

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var CurrentTitle: UITextView!
    @IBOutlet weak var CurrentPlace: UILabel!
    @IBOutlet weak var CurrentSpent: UILabel!
    @IBOutlet weak var CurrentCategory: UIButton!
    @IBOutlet weak var CurrentTopics: UIButton!
    @IBOutlet weak var CurrentSentence: UILabel!
    
    var CurrentReadState = CurrentReadClass(id: UUID(), title: "You haven't read anybook yet", category: "", spentTime: Date(), coverColor: "#FFFFFF", highlightedSentence: ["Fav Sentence"], lastPlace: "", status: "DONE", isReadNow: false, createdAt: Date(), lastPage: 0, lastVisitDate: Date(), topics: [""], updateAt: Date())
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var personItems: [Person]?
    var bookWishList: [Books]?
    
    func inTheCurrent() {
        var indicatorDefault = false
        if (userDefaults.value(forKey: "defaultCurrent") != nil) {
            indicatorDefault = true
        } else {
            if let encodedData = try? JSONEncoder().encode(CurrentReadState) {
                userDefaults.set(encodedData, forKey: "defaultCurrent")
            }
            indicatorDefault = false
        }
        
        if indicatorDefault == true {
//
            if let data = userDefaults.data(forKey: "defaultCurrent") {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    
                    // Decode Note
                    let decodedCurrent = try decoder.decode(CurrentReadClass.self, from: data)
                    
                    if decodedCurrent.highlightedSentence.count != 0 {
                        CurrentSentence.text = decodedCurrent.highlightedSentence[0]
                    } else {
                        CurrentSentence.text = ""
                    }

                    CurrentTitle.text = decodedCurrent.title
                    CurrentPlace.text = decodedCurrent.lastPlace
                    CurrentTopics.setTitle(decodedCurrent.topics[0], for: .normal)
                    CurrentCategory.setTitle(decodedCurrent.category, for: .normal)
                    CurrentSpent.isHidden = true
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        } else {
            CurrentTitle.text = CurrentReadState.title
            CurrentPlace.text = CurrentReadState.lastPlace
            CurrentTopics.setTitle(CurrentReadState.topics[0], for: .normal)
            CurrentCategory.setTitle(CurrentReadState.category, for: .normal)
            CurrentSentence.text = CurrentReadState.highlightedSentence[0]
            CurrentSpent.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inTheCurrent()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        
        // Get items from Core Data
//        fetchPeople()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
        fetchWishlist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWishlist()
        inTheCurrent()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func fetchWishlist() {
        
        // Fetch the data from Core Data to display in the tableView
        do {
            self.bookWishList = try context.fetch(Books.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    @IBAction func addBook(_ sender: UIButton) {
        // Create alert
        let alert = UIAlertController(title: "Add Book", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        // Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Get the textField for the alert
            let textField = alert.textFields![0]
            
            // Create a person object
            let newBook = Books(context: self.context)
            newBook.title = textField.text
            newBook.lastPage = 20
            newBook.status = "Page 20"
            newBook.category = "Novel"
            newBook.topics = ["Adventure"] as NSObject
            newBook.coverColor = "#8E8E93"
            newBook.createdAt = Date()
            newBook.highlightedSentence = ["High"] as NSObject
            newBook.isReadNow = false
            newBook.lastPlace = "Shelf"
            newBook.lastVisitDate = Date()
            newBook.spentTime = Date()
            newBook.updateAt = Date()
            
            // Save the data
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            
            // Re-fetch the data
            self.fetchWishlist()
        }
        
        // Add button
        alert.addAction(submitButton)
        
        // Show alert
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let checkVCModal = segue.destination as? ModalController {
            checkVCModal.readNow = {
                self.inTheCurrent()
            }
            checkVCModal.accept = {
                self.fetchWishlist()
            }
        }
        if let checkVCDetail = segue.destination as? DetailController {
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let selectedBook = self.bookWishList![indexPath[0]]

            let selectedBookTopics = self.bookWishList![indexPath[0]].topics as? [String] ?? []
            let selectedBookSentence = self.bookWishList![indexPath[0]].highlightedSentence as? [String] ?? []
            let detailVC = CurrentReadClass(id: UUID(), title: selectedBook.title ?? "Title", category: selectedBook.category ?? "Category", spentTime: selectedBook.spentTime ?? Date(), coverColor: selectedBook.coverColor ?? "#FFFFFF", highlightedSentence: selectedBookSentence, lastPlace: selectedBook.lastPlace ?? "Lemari", status: selectedBook.status ?? "ONGOING", isReadNow: selectedBook.isReadNow , createdAt: selectedBook.createdAt ?? Date(), lastPage: Int(selectedBook.lastPage ), lastVisitDate: selectedBook.lastVisitDate ?? Date(), topics: selectedBookTopics, updateAt: selectedBook.updateAt ?? Date())
            print("inthe detail", detailVC)
            checkVCDetail.selectedBook = detailVC
            checkVCDetail.readNow = {
                self.inTheCurrent()
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.bookWishList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of people
//        return
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let booksCell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath) as! WishreadTableCell
        
        // Get person from array and set the label
        let book = self.bookWishList![indexPath.section]
        
        booksCell.BookTitle.text = book.title
        //change text color
        let bookColorCover = book.coverColor!.replacingOccurrences(of: "#", with: "0x")
        
        let intBookColorCover:Int? = Int(Double(bookColorCover)!)
        booksCell.BookTitle.textColor = UIColor(rgb: intBookColorCover ?? 0xFF453A)
        booksCell.BookTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        booksCell.BookCategory.text = book.category
        
        // icon with string
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)
        let imageAttachment = NSTextAttachment()
        let theImage = UIImage(systemName: "mappin.and.ellipse", withConfiguration: smallConfiguration)?.withTintColor(.white)
        imageAttachment.image = theImage
        let stringPlaceWithIcon = NSMutableAttributedString(string: " ")
        stringPlaceWithIcon.append(NSAttributedString(attachment: imageAttachment))
        stringPlaceWithIcon.append(NSAttributedString(string: " "))
        stringPlaceWithIcon.append(NSAttributedString(string: book.lastPlace ?? "Lemari"))
        booksCell.BookPlace.attributedText = stringPlaceWithIcon
        
        //timeago
        let getLastVisit = book.lastVisitDate?.timeAgo()
        booksCell.BookLastVisit.text = (getLastVisit != nil) ? (getLastVisit ?? "0 minutes") + " ago" : ""
        
        return booksCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = CGFloat()
        cellHeight = 80
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected Person
//        let selectedBook = self.bookWishList![indexPath.section]
//
//        let selectedBookTopics = self.bookWishList![indexPath.section].topics as? [String] ?? []
//        let selectedBookSentence = self.bookWishList![indexPath.section].highlightedSentence as? [String] ?? []
//
//        CurrentTitle.text = selectedBook.title
//        CurrentPlace.text = selectedBook.lastPlace
//        CurrentTopics.setTitle(selectedBookTopics[0], for: .normal)
//        CurrentCategory.setTitle(selectedBook.category, for: .normal)
//        CurrentSentence.text = selectedBookSentence[0]
        
        
        self.performSegue(withIdentifier: "detailBook", sender: self)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let actionRemove = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            
            // Which person to remove
            let bookToRemove = self.bookWishList![indexPath.section]
            
            // Remove the person
            self.context.delete(bookToRemove)
            // Save the data
            do {
                try self.context.save()
            } catch {
                print("error save context")
            }
            
            // Re-fetch the data
//            self.fetchPeople()
            self.fetchWishlist()
        }
        actionRemove.image = UIImage(systemName: "trash.fill")
        
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [actionRemove])
    }
}

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

