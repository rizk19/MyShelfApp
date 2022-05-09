//
//  DetailController.swift
//  MyShelfApp
//
//  Created by Rizki Faris on 29/04/22.
//

import UIKit

class DetailController: UIViewController {
    
    var booksSentenceList: [String]?
    var selectedBook : CurrentReadClass?
    var readNow: (() -> Void)?

    @IBOutlet weak var BookTitleDetail: UITextView!
    @IBOutlet weak var SpentTimeDetail: UILabel!
    @IBOutlet weak var LastVisitDetail: UILabel!
    @IBOutlet weak var LastPageDetail: UILabel!
    @IBOutlet weak var LastPlaceDetail: UITextView!
    @IBOutlet weak var CategoryDetail: UIButton!
    @IBOutlet weak var TopicsDetail: UIButton!
    @IBOutlet weak var TableSentenceDetail: UITableView!
    @IBOutlet weak var BtnStartReadDetail: UIButton!
    @IBAction func StartReadHandle(_ sender: UIButton) {
        print("inthe select", selectedBook)
        _ = navigationController?.popViewController(animated: true)
        if let encodedData = try? JSONEncoder().encode(selectedBook) {
            UserDefaults.standard.set(encodedData, forKey: "defaultCurrent")
            if let nowRead = readNow {
                nowRead()
            }
        }
    }
    @IBAction func isDoneHandle(_ sender: UIButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BookTitleDetail.text = selectedBook?.title
        let bookColorCover = selectedBook?.coverColor.replacingOccurrences(of: "#", with: "0x")
        
        let intBookColorCover:Int? = Int(Double(bookColorCover ?? "0xFF453A")!)
        BookTitleDetail.textColor = UIColor.init(rgb: intBookColorCover ?? 0xFF453A)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let spentInterval = selectedBook?.spentTime.timeIntervalSinceNow
        
        let spentWeeks = Int(abs (spentInterval!).asWeeks())
        let spentDays = Int(abs (spentInterval!).asDays())
        let spentHours = Int(abs (spentInterval!).asHours())
        
        let spentString = spentWeeks > 0 ? "\(spentWeeks) weeks ago" : spentDays > 0 ? "\(spentDays) days ago" : "\(spentHours) hour ago"
        SpentTimeDetail.text = spentString
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let lastDateString = df.string(from: selectedBook?.lastVisitDate ?? Date())
        
        LastVisitDetail.text = lastDateString
        
        LastPageDetail.text = "\(selectedBook?.lastPage ?? 1)"
        
        LastPlaceDetail.text = selectedBook?.lastPlace
        
        CategoryDetail.setTitle(selectedBook?.category, for: .normal)
        
        TopicsDetail.setTitle(selectedBook?.topics[0], for: .normal)
        
        booksSentenceList = selectedBook?.highlightedSentence
        
        TableSentenceDetail.reloadData()
    }
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
        super.viewDidLoad()
        TableSentenceDetail.delegate = self
        TableSentenceDetail.dataSource = self
        TableSentenceDetail.separatorColor = .black
        // Do any additional setup after loading the view.
    }
    
}

extension TimeInterval {
    func asMinutes() -> Double { return self / (60.0) }
    func asHours()   -> Double { return self / (60.0 * 60.0) }
    func asDays()    -> Double { return self / (60.0 * 60.0 * 24.0) }
    func asWeeks()   -> Double { return self / (60.0 * 60.0 * 24.0 * 7.0) }
    func asMonths()  -> Double { return self / (60.0 * 60.0 * 24.0 * 30.4369) }
    func asYears()   -> Double { return self / (60.0 * 60.0 * 24.0 * 365.2422) }
}

extension DetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sentenceCell = tableView.dequeueReusableCell(withIdentifier: "detailSentenceCell", for: indexPath)
        
        let sentenceHere = self.booksSentenceList![indexPath.section]
        print("here", sentenceHere)
        sentenceCell.textLabel?.text = sentenceHere
        
        return sentenceCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.booksSentenceList?.count ?? 0
    }
    
}
