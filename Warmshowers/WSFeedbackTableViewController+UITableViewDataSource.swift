//
//  WSFeedbackTableViewController+UITableViewCellDataSource.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 16/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import UIKit

extension WSFeedbackTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return feedback != nil ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedback?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackCellID, for: indexPath) as! FeedbackTableViewCell
        guard let feedback = feedback , (indexPath as NSIndexPath).row < feedback.count else { return cell }
        
        let recommendation = feedback[(indexPath as NSIndexPath).row]
        
        cell.authorImage.image = recommendation.authorImage ?? placeholderImage
        cell.authorNameLabel.text = recommendation.author?.fullname
        cell.dateLabel.text = textForRecommendationDate(recommendation.date)
        cell.ratingLabel.text = recommendation.rating.rawValue
        cell.ratingLabel.textColor = textColorForRecommedationRating(recommendation.rating)
        cell.forLabel.text = textForRecommendationType(recommendation.type)
        cell.bodyLabel.text = recommendation.body
    
        return cell
    }
    
}
