//Andrew Abate
//attempt to Lerp Color
//linear interpolation between 2 colors

import Foundation
import UIKit

extension UIColor {
    //creating an extension of the UI Color
    
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
        //creating a function to interpolate RGBColor FROM/TO
        let f = min(max(0, fraction), 1)
        
        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }
        
        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class lerpColor {
    func applyLerp() {
        var heartbeat = 225 //pull heartbeat from HealthStore
        var age = 35 //pull age from HealthStore
        var max = 220 - age //formula for maximum heartrate performance
        var ratio: Float = Float(heartbeat) / Float(max)

        //color code tests
        //  let color1 = UIColor(red: 0.035, green: 0.216, blue: 0.933, alpha: 1.00)
        //  let color2 = UIColor(red: 0.933, green: 0.794, blue: 0.000, alpha: 1.00)
        //  let color3 = UIColor(red:1.00, green: 0.00, blue: 0.00, alpha: 1.000)
        //  let color4 = UIColor(red:0.00, green: 1.00, blue: 0.00, alpha: 1.000)
        //
        //  for i in stride(from:0.01, to:1.00, by:0.1) {
        //      color1.interpolateRGBColorTo(color2, fraction:CGFloat(i))
        //  }

        //min and max heart Colors
        var heartColorMax = UIColor(red: 0.502, green: 0, blue: 0, alpha: 1.000);
        var heartColorMin = UIColor(red: 0.20, green: 0.40, blue: 0.89, alpha: 1.000)
        var currentHeartColor = UIColor(red:1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //heartrate interpolation
        if (heartbeat <= max) {
            currentHeartColor = heartColorMin.interpolateRGBColorTo(heartColorMax, fraction:CGFloat(ratio))!
            print("HEART RATE IN ZONE")
        }
        else {
            currentHeartColor = UIColor(red:1.000, green: 0.000, blue:0.000, alpha: 1.000)
            print ("HEART RATE OVER MAX!!!")
        }
    }
}
