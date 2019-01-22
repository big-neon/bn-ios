
import Foundation
import UIKit
import pop

/* Set the property that you want to animate, like...
 kPOPLayerBackgroundColor;
 kPOPLayerBounds;
 kPOPLayerPosition;
 kPOPLayerPositionX;
 kPOPLayerPositionY;
 kPOPLayerOpacity;
 kPOPLayerScaleX;
 kPOPLayerScaleY;
 kPOPLayerScaleXY;
 kPOPLayerTranslationX;
 kPOPLayerTranslationY;
 kPOPLayerTranslationZ;
 kPOPLayerTranslationXY;
 kPOPLayerSubscaleXY;
 kPOPLayerSubtranslationX;
 kPOPLayerSubtranslationY;
 kPOPLayerSubtranslationZ;
 kPOPLayerSubtranslationXY;
 kPOPLayerZPosition;
 kPOPLayerSize;
 kPOPLayerRotation;
 kPOPLayerRotationY;
 kPOPLayerRotationX;
 
 kPOPViewAlpha;
 kPOPViewBackgroundColor;
 kPOPViewBounds;
 kPOPViewCenter;
 kPOPViewFrame;
 kPOPViewScaleX;
 kPOPViewScaleXY;
 kPOPViewScaleY;
 kPOPViewSize; */

//View Frame Changes = Changing a frame to another shape with an animation
public func buttonTranslationAnimation(buttonPressed: UIButton, bounceVelocity: CGFloat, springBouncinessEffect: CGFloat) {
    let popOutAnimation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
    popOutAnimation?.toValue = NSValue(cgRect: CGRect(x: 245, y: 70, width: 323, height: 10)) //Value to change to
    //Properties of the Animation
    popOutAnimation?.velocity = NSValue(cgRect: CGRect(x:0, y: 0, width: bounceVelocity, height: 0)) //X and Y control the moment of the button in the x and y direction
    popOutAnimation?.springBounciness = springBouncinessEffect
    popOutAnimation?.springSpeed = 15.0
    popOutAnimation?.dynamicsTension = 15.0
    popOutAnimation?.dynamicsFriction = 2.0
    popOutAnimation?.dynamicsMass = 0.2
    buttonPressed.pop_add(popOutAnimation, forKey: "slideOut")
}

public func buttonBounceAnimation(buttonPressed: UIButton) {
    let buttonPressAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    buttonPressAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
    buttonPressAnimation?.velocity = NSValue(cgPoint: CGPoint(x: 7.0, y: 7.0))
    buttonPressAnimation?.springBounciness = 12.5
    buttonPressed.pop_add(buttonPressAnimation, forKey: "buttonScale")
}

public func imageShakeAnimation(imageToAnimate: UIImageView, bounceVelocity: CGFloat, springBouncinessEffect: CGFloat) {
    let imageAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    imageAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
    imageAnimation?.velocity = NSValue(cgPoint: CGPoint(x: bounceVelocity, y:
        bounceVelocity))
    imageAnimation?.springBounciness = springBouncinessEffect
    imageToAnimate.pop_add(imageAnimation, forKey: "imageScale")
}

public func labelShake(labelToAnimate: UILabel, bounceVelocity: CGFloat, springBouncinessEffect: CGFloat) {
    let labelAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    labelAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y:1.0))
    labelAnimation?.velocity = NSValue(cgPoint: CGPoint(x: bounceVelocity, y: bounceVelocity))
    labelAnimation?.springBounciness = springBouncinessEffect
    labelToAnimate.pop_add(labelAnimation, forKey: "labelScale")
}

public func textFieldShake(textFieldToBounce: UITextField, bounceVelocity: CGFloat, springBouncinessEffect: CGFloat) {
    let labelAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    labelAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
    labelAnimation?.velocity = NSValue(cgPoint: CGPoint(x: bounceVelocity, y: bounceVelocity))
    labelAnimation?.springBounciness = springBouncinessEffect
    textFieldToBounce.pop_add(labelAnimation, forKey: "textFieldScale")
}

public func textViewShake(textViewToBounce: UITextView, bounceVelocity: CGFloat, springBouncinessEffect: CGFloat) {
    let labelAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    labelAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
    labelAnimation?.velocity = NSValue(cgPoint: CGPoint(x: bounceVelocity, y: bounceVelocity))
    labelAnimation?.springBounciness = springBouncinessEffect
    textViewToBounce.pop_add(labelAnimation, forKey: "textViewScale")
}

public func viewAnimationBounce(viewSelected: UIView, bounceVelocity: CGFloat, springBouncinessEffect: CGFloat) {
    let viewAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    viewAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
    viewAnimation?.velocity = NSValue(cgPoint: CGPoint(x: bounceVelocity, y: bounceVelocity))
    viewAnimation?.springBounciness = springBouncinessEffect
    viewSelected.pop_add(viewAnimation, forKey: "viewScale")
}
