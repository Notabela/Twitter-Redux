//
//  helper.swift
//  Twitter
//
//  Created by daniel on 2/7/17.
//  Copyright © 2017 Notabela. All rights reserved.
//

import UIKit

//Minutes ago, years ago extension
extension DateFormatter
{
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
     
     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
     
     - Returns: A string with formatted `date`.
     */
    class func timeSince(from: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now as Date
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 1 {
            result = "\(components.year!)y"
        } else if components.month! >= 1 {
            result = "\(components.month!)m"
        } else if components.weekOfYear! >= 1 {
            result = "\(components.weekOfYear!)w"
        } else if components.day! >= 1 {
            result = "\(components.day!)d"
        } else if components.hour! >= 1 {
            result = "\(components.hour!)h"
        } else if components.minute! >= 1 {
            result = "\(components.minute!)m"
        } else if components.second! >= 1 {
            result = "\(components.second!)s"
        } else {
            result = "Just now"
        }
        
        return result
    }
    
    /*
     * Example Usage
     */
    /*
    var time = "2016-07-17 12:35:22 GMT"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'GMT'"
    let date = dateFormatter.date(from: time)!
    var timeStamp: String = dateFormatter.timeSince(from: date, numericDates: true)
    */
 }

extension Int64
{
    
    //usage
    //let me = 50000.abbreviated
    
    var abbreviated: String
    {
        let abbrev = "KMBTPE"
        return abbrev.characters.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}

func downloadImageWith(url: URL, success: @escaping (UIImage?) -> (), dataError: @escaping (Error?) -> ())
{
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request, completionHandler:
        {
            (data, response, error) -> Void in
            
            OperationQueue.main.addOperation({
                if error == nil && data != nil
                {
                    let image = UIImage(data: data!)
                    success(image)
                }
                else
                {
                    dataError(error)
                }
            })
    })
    
    task.resume()
}
