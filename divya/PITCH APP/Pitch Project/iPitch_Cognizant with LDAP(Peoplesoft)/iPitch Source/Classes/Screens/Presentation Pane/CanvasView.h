//
//  PresentationPanelViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 06/03/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"


@interface CanvasView : UIView {

}
@property (nonatomic, retain) NSMutableArray *lines;
@property (nonatomic, retain) Line *currentLine;
@property (nonatomic, assign) BOOL laserSelected;

-(void)removeLaserObjects;
-(void)clearScreen;
@end
