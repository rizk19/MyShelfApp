//
//  ModalController.swift
//  MyShelfApp
//
//  Created by Rizki Faris on 28/04/22.
//

import UIKit

class ModalController: UIViewController, UINavigationControllerDelegate {

    let userDefaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var bookWishList: [Books]?
    
    var accept: (() -> Void)?
    
    var readNow: (() -> Void)?
    
    func fetchWishlist() {
        
        // Fetch the data from Core Data to display in the tableView
        do {
            self.bookWishList = try context.fetch(Books.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    @IBAction func closeModal(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var colorIndicator: UIButton!
    
    @IBOutlet weak var TitleField: UITextField!
    @IBAction func BookTitleField(_ sender: UITextField) {
    }
    @IBAction func grayColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor.init(rgb: 0x8E8E93)
    }
    @IBAction func darkGrayColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor.systemGray4
    }
    @IBAction func blueColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0x0A84FF)
    }
    @IBAction func redColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0xFF453A)
    }
    @IBAction func cyanColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0x64D2FF)
    }
    @IBAction func yellowColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0xFFD60A)
    }
    @IBAction func greenColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0x30D158)
    }
    @IBAction func mintColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0x63E6E2)
    }
    @IBAction func purpleColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0xBF5AF2)
    }
    @IBAction func orangeColorBtn(_ sender: Any) {
        colorIndicator.tintColor = UIColor(rgb: 0xFF9F0A)
    }
    
    @IBOutlet weak var CategoryField: UITextField!
    
    @IBAction func NovelCatBtn(_ sender: UIButton) {
        CategoryField.text = "Novel"
    }
    @IBAction func BioCatBtn(_ sender: UIButton) {
        CategoryField.text = "Biography"
    }
    @IBAction func ComicCatBtn(_ sender: UIButton) {
        CategoryField.text = "Comic"
    }
    @IBAction func FictionCatBtn(_ sender: UIButton) {
        CategoryField.text = "Fiction"
    }
    @IBAction func MysteryCatBtn(_ sender: UIButton) {
        CategoryField.text = "Mystery"
    }
    @IBAction func ArtCatBtn(_ sender: UIButton) {
        CategoryField.text = "Art/architecture"
    }
    @IBAction func HistCatBtn(_ sender: UIButton) {
        CategoryField.text = "History"
    }
    @IBAction func ScCatBtn(_ sender: UIButton) {
        CategoryField.text = "Science"
    }
    @IBAction func JouCatBtn(_ sender: UIButton) {
        CategoryField.text = "Journal"
    }
    @IBAction func TravCatBtn(_ sender: UIButton) {
        CategoryField.text = "Travel"
    }
    @IBAction func BussCatBtn(_ sender: UIButton) {
        CategoryField.text = "Business"
    }
    
    @IBOutlet weak var TopicsField: UITextField!
    @IBAction func TheoryTopBtn(_ sender: UIButton) {
        TopicsField.text = "Theory"
    }
    @IBAction func AdvTopBtn(_ sender: UIButton) {
        TopicsField.text = "Adventure"
    }
    
    @IBAction func MedTopBtn(_ sender: UIButton) {
        TopicsField.text = "Medical"
    }
    @IBAction func ActTopBtn(_ sender: UIButton) {
        TopicsField.text = "Action"
    }
    @IBAction func MagicTopBtn(_ sender: UIButton) {
        TopicsField.text = "Magic"
    }
    @IBAction func HauntTopBtn(_ sender: UIButton) {
        TopicsField.text = "Haunt"
    }
    @IBAction func PlotTopBtn(_ sender: UIButton) {
        TopicsField.text = "Plottwist"
    }
    
    @IBOutlet weak var PlaceField: UITextField!
    
    @IBAction func ShelfPlaceBtn(_ sender: UIButton) {
        PlaceField.text = "Shelf"
    }
    
    @IBAction func ndfloordesk(_ sender: UIButton) {
        PlaceField.text = "2nd floor desk"
    }
    
    @IBAction func DrawerPlaceBtn(_ sender: UIButton) {
        PlaceField.text = "Drawer"
    }
    
    @IBAction func BookcasePlaceBtn(_ sender: UIButton) {
        PlaceField.text = "Bookcase"
    }
    
    @IBOutlet weak var SentenceTable: UITableView!
    
    @IBOutlet weak var HighlightField: UITextField!
    
    var sentenceList: [String] = []
    @IBOutlet weak var PageReadField: UITextField!
    
    @IBAction func PlaceFieldHandle(_ sender: UITextField) {
        if (sender.text != nil) {
            print("senderr 2", sender.text!)
            sentenceList.append(sender.text!)
            sender.text = ""
        }
        SentenceTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        
        SentenceTable.delegate = self
        SentenceTable.dataSource = self
        fetchWishlist()
        
        PlaceField.autocorrectionType = .no
        TitleField.autocorrectionType = .no
        CategoryField.autocorrectionType = .no
        TopicsField.autocorrectionType = .no
        HighlightField.autocorrectionType = .no
        // Do any additional setup after loading the view.
    }
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
     }
    
    func createBook(isRead: Bool) {
        let title = TitleField.text ?? nil
        let category = CategoryField.text ?? nil
        let topics = TopicsField.text ?? nil
        let place = PlaceField.text ?? nil
        let selectedColor = hexStringFromColor(color: colorIndicator.tintColor)
        let lastpage = Int(PageReadField.text ?? "") ?? 0
        
        if title == nil {
            return
        } else if category == nil {
            return
        } else if topics == nil {
            return
        } else if place == nil {
            return
        }
        
        let newBook = Books(context: self.context)
        newBook.title = title
        newBook.lastPage = Int32(lastpage)
        newBook.status = ""
        newBook.category = category
        newBook.topics = [topics] as? NSObject
        newBook.coverColor = selectedColor
        newBook.createdAt = Date()
        newBook.highlightedSentence = sentenceList as NSObject
        newBook.isReadNow = false
        newBook.lastPlace = place
        newBook.lastVisitDate = Date()
        newBook.spentTime = Date()
        newBook.updateAt = Date()
        
        do {
            try self.context.save()
            dismiss(animated: true, completion: nil)
        } catch {
            print(error)
        }
        
        if isRead == true {
            if let nowRead = readNow {
                nowRead()
            }
        }
        if let accepted = accept {
            accepted()
        }
        
    }
    @IBAction func addBook(_ sender: UIButton) {
        createBook(isRead : false)
    }
    @IBAction func readAddBook(_ sender: UIButton) {
        let title = TitleField.text ?? ""
        let category = CategoryField.text ?? ""
        let topics = TopicsField.text ?? ""
        let place = PlaceField.text ?? ""
        let lastpage = Int(PageReadField.text ?? "") ?? 0
        let selectedColor = hexStringFromColor(color: colorIndicator.tintColor)
        let sentences =  sentenceList.count != 0 ? sentenceList : [HighlightField.text ?? ""]
        let newCurrent = CurrentReadClass(id: UUID(), title: title, category: category, spentTime: Date(), coverColor: selectedColor, highlightedSentence: sentences, lastPlace: place, status: "", isReadNow: true, createdAt: Date(), lastPage: lastpage, lastVisitDate: Date(), topics: [topics], updateAt: Date())
        if let encodedData = try? JSONEncoder().encode(newCurrent) {
            userDefaults.set(encodedData, forKey: "defaultCurrent")
        }
        createBook(isRead : true)
    }
    
}

extension ModalController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sentenceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let highSenCell = tableView.dequeueReusableCell(withIdentifier: "sentenceCell", for: indexPath)
        
        let sentence = self.sentenceList[indexPath.row]
        
        highSenCell.textLabel?.text = sentence
        
        return highSenCell
    }
}

extension ModalController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        if self.view.viewWithTag(1) is UITextField && textField.text != "" {
        PlaceField.resignFirstResponder()
//        }
        
        return true
    }
}
