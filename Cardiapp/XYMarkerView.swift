//
//  XYMarkerView.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        //let string = "x: "
        
        //source:https://stackoverflow.com/questions/40648284/converting-a-unix-timestamp-into-date-as-string-swift
        let date = Date(timeIntervalSince1970: entry.x)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.timeZone = Calendar.current.timeZone
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let t = dateFormatter.string(from: date)
        print(t)
        
        var tag = ""
        //        if tags[t] != nil{
        //            tag = tags[t]! //gets the tag based on the position in the dictionary that corresponds to the time\
        //        }
        //        else{
        //            tag = ""
        //        }
        
        print(tag)
        
        //tag may be nil and I don't want it to say "tag:  " with a blank space
        var label = ""
        if tag != "" {
            label = "tag: \(tag)\n"
        } else{
            label = ""
        }
        
        let string = ""
            + xAxisValueFormatter.stringForValue(entry.x, axis: XAxis())
            //+ ", y: "
            + "\n"
            + yFormatter.string(from: NSNumber(floatLiteral: entry.y))!
            + " bpm\n\(label)"
        
        // + "tag: \(tag as! String)\n"
        
        setLabel(string)
    }
    
}
