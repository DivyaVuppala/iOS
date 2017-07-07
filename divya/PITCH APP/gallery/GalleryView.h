//
//  GalleryView.h
//  Treatment Plan
//
//  Created by Divya Vuppala on 19/05/15.
//
//

#import <UIKit/UIKit.h>

#import "ALBotoxDrawView.h"


@interface GalleryView : UIView <ALBotoxDrawViewDelegate>
{
    
   
    IBOutlet UIImageView *mainImageView;
    
    IBOutlet UIImageView *optionalImageViewOne;
    
    IBOutlet UIImageView *optionalImageViewTwo;
    
    IBOutlet UIImageView *optionalImageViewThree;
    
    
}


@end
