//
//  ListingItemTableViewCell.swift
//  freddit
//
//  Created by Francisco Gindre on 12/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import UIKit


protocol ListingItemDelegate: class {
    func dismissed(cell: ListingItemTableViewCell, item: ListingItem)
}

class ListingItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: WebImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var unreadDot: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    
    private var item: ListingItem?
    weak var delegate: ListingItemDelegate?
    
    // MARK: Cell life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadDot.layer.cornerRadius = unreadDot.bounds.width/2
        clearContents()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearContents()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            guard let item = item else { return }
            PersistenceHelper.markAsRead(item: item)
            toggleDot(unread: false, animated: animated)
        }
    }
    
    // MARK: Internal Functions
    func configure(for item: ListingItem, unread: Bool = true, delegate: ListingItemDelegate) {
        self.item = item
        self.delegate = delegate
        toggleDot(unread: unread)
        
        //todo: thumbnail
        
        if let imagePath = item.thumbnail, let imageURL = URL(string: imagePath) {
            self.thumbnail.setImage(from: imageURL)
        }
        
        self.authorLabel.text = item.author ?? "by unknown"
        self.titleLabel.text = item.title ?? "No title"
        
        if let dateInterval = item.created {
             self.dateLabel.text = Date(timeIntervalSince1970: dateInterval).timeAgo(numericDates: true)
        } else {
            self.dateLabel.text = nil
        }
        
        comments(for: item.comments)
    }
    
    
    // MARK: Private functions
    private func comments(for count: Int?) {
        
        // TODO: this could be both localized and pluralized but, there are more important things to focus on now
        
        guard let count = count, count > 0  else {
            self.commentsLabel.text = "no comments yet"
            return
        }
        
        self.commentsLabel.text = "\(count) \(count > 1 ? "comments" : "comment")"
    }
    private func toggleDot(unread: Bool) {
        unreadDot.alpha = unread ? 1.0 : 0.0
    }
    
    private func toggleDot(unread: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: unread ? UIView.AnimationOptions.curveEaseIn : UIView.AnimationOptions.curveEaseIn, animations: {
                self.toggleDot(unread: unread)
            })
        } else {
            toggleDot(unread: unread)
        }
    }
    
    private func clearContents() {
        self.item = nil
        self.dateLabel.text = nil
        self.authorLabel.text = nil
        self.thumbnail.cancelTask()
        self.thumbnail.setPlaceholderImage()
        self.commentsLabel.text = nil
        self.toggleDot(unread: true)
    }
    
    // MARK: Actions
    @IBAction func dismissPressed(_ sender: Any) {
        guard let delegate = self.delegate, let item = self.item else {
            print("WARNING, CELL WITH NO DELEGATE OR MODEL")
            return
        }
        delegate.dismissed(cell: self, item: item)
    }
}


extension UIImageView {
    func setPlaceholderImage() {
        self.image = UIImage(named: "icon-img-placeholder")
    }
}


// FROM: https://gist.github.com/minorbug/468790060810e0d29545
// there are proper utilities to achieve this in a more localized and simple way.
extension Date {
    func timeAgo(numericDates: Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        switch (year, month, weekOfMonth, day, hour, minute, second) {
        case (let year, _, _, _, _, _, _) where year >= 2: return "\(year) years ago"
        case (let year, _, _, _, _, _, _) where year == 1 && numericDates: return "1 year ago"
        case (let year, _, _, _, _, _, _) where year == 1 && !numericDates: return "Last year"
        case (_, let month, _, _, _, _, _) where month >= 2: return "\(month) months ago"
        case (_, let month, _, _, _, _, _) where month == 1 && numericDates: return "1 month ago"
        case (_, let month, _, _, _, _, _) where month == 1 && !numericDates: return "Last month"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2: return "\(weekOfMonth) weeks ago"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && numericDates: return "1 week ago"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && !numericDates: return "Last week"
        case (_, _, _, let day, _, _, _) where day >= 2: return "\(day) days ago"
        case (_, _, _, let day, _, _, _) where day == 1 && numericDates: return "1 day ago"
        case (_, _, _, let day, _, _, _) where day == 1 && !numericDates: return "Yesterday"
        case (_, _, _, _, let hour, _, _) where hour >= 2: return "\(hour) hours ago"
        case (_, _, _, _, let hour, _, _) where hour == 1 && numericDates: return "1 hour ago"
        case (_, _, _, _, let hour, _, _) where hour == 1 && !numericDates: return "An hour ago"
        case (_, _, _, _, _, let minute, _) where minute >= 2: return "\(minute) minutes ago"
        case (_, _, _, _, _, let minute, _) where minute == 1 && numericDates: return "1 minute ago"
        case (_, _, _, _, _, let minute, _) where minute == 1 && !numericDates: return "A minute ago"
        case (_, _, _, _, _, _, let second) where second >= 3: return "\(second) seconds ago"
        default: return "Just now"
        }
    }
}
