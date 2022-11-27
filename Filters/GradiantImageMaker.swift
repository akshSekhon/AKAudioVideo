
import UIKit

private let ChannelDivider: CGFloat = 255

public class RGBA: NSObject {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(intRed: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.red = CGFloat(intRed)/ChannelDivider
        self.green = CGFloat(green)/ChannelDivider
        self.blue = CGFloat(blue)/ChannelDivider
        self.alpha = CGFloat(alpha)/ChannelDivider
    }
}

public class Grayscale: NSObject {
    var white: CGFloat
    var alpha: CGFloat
    
    init(white: CGFloat, alpha: CGFloat) {
        self.white = white
        self.alpha = alpha
    }
}

public class GradientPoint<C>: NSObject {
    var location: CGFloat
    var color: C
    
    init(location: CGFloat, color: C) {
        self.location = location
        self.color = color
    }
}

extension UIImage {
    
    public class func image(withGradientPoints gradientPoints: [GradientPoint<[CGFloat]>], colorSpace: CGColorSpace, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        guard
            let context = UIGraphicsGetCurrentContext(),
            let gradient = CGGradient(colorSpace: colorSpace,
                                      colorComponents: gradientPoints.flatMap { $0.color },
                                      locations: gradientPoints.map { $0.location }, count: gradientPoints.count) else {
            return nil
        }
        context.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public class func image(withRGBAGradientPoints gradientPoints: [GradientPoint<RGBA>], size: CGSize) -> UIImage? {
        return image(withGradientPoints: gradientPoints.map {
            GradientPoint(location: $0.location, color: [$0.color.red, $0.color.green, $0.color.blue, $0.color.alpha])
        }, colorSpace: CGColorSpaceCreateDeviceRGB(), size: size)
    }
    
    public class func image(withRGBAGradientColors gradientColors: [CGFloat: RGBA], size: CGSize) -> UIImage? {
        return image(withRGBAGradientPoints: gradientColors.map {  GradientPoint(location: $0, color: $1)}, size: size)
    }
    
    public class func image(withGrayscaleGradientPoints gradientPoints: [GradientPoint<Grayscale>], size: CGSize) -> UIImage? {
        return image(withGradientPoints: gradientPoints.map {
            GradientPoint(location: $0.location, color: [$0.color.white, $0.color.alpha]) },
                     colorSpace: CGColorSpaceCreateDeviceGray(), size: size)
    }
    
    public class func image(withGrayscaleGradientColors gradientColors: [CGFloat: Grayscale], size: CGSize) -> UIImage? {
        return image(withGrayscaleGradientPoints: gradientColors.map { GradientPoint(location: $0, color: $1) }, size: size)
    }
    
    
    
}
