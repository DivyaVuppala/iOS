//
//  LabelAnim.m
//  sampleAnim
//
//  Created by Santhosh Kumar on 21/01/13.
//  Copyright (c) 2013 Santhosh Kumar. All rights reserved.
//

#import "MetroTile.h"
#import "iPitchConstants.h"
@implementation MetroTile

@synthesize view1, array1, lbl1, timer1, btn1, animationType;
int i = 0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) configureLabel{
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [btn1 addTarget:self action:@selector(labelClick) forControlEvents: UIControlEventTouchUpInside];
    [btn1 setTitleColor: [UIColor clearColor] forState: UIControlStateNormal];
    [self addSubview:btn1];
    
 //   array1 = [[NSMutableArray alloc]initWithObjects: @"Urgent Meeting",@"Leave Letter",@"Presentations", @"Cricket Matches", nil];
    
 
    
    lbl1 = [[UILabel new] initWithFrame:CGRectMake(0, (self.frame.size.height - 50)/2, self.frame.size.width, 50)];
    if (array1.count>1) {
        lbl1.text =  [array1 objectAtIndex:i];

    }
    i++;
    lbl1.textAlignment = UITextAlignmentCenter;
    lbl1.backgroundColor = [UIColor clearColor];
    lbl1.textColor = [UIColor whiteColor];
    lbl1.font=[UIFont fontWithName:FONT_REGULAR size:14.0];
    lbl1.numberOfLines=0;
    //Add label to view
    [self addSubview:lbl1];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
}


-(void) labelClick{
    NSLog(@"Label is : %@", lbl1.text);
}

-(void) animate{
    if (i < array1.count)
    {
       
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionTransitionCurlUp
                         animations:^{
                             
                             lbl1.alpha=0.01f;
                          
                             if(animationType == MetroTileAnimationTypeVertical)
                             lbl1.frame=CGRectMake(0, -20, self.frame.size.width, 100);
                             else
                             lbl1.frame=CGRectMake(0, 50, self.frame.size.width, 100);
                         }
                                     completion:nil];
             if (array1.count>1)
             lbl1.text = [array1 objectAtIndex:i++];
             
             [UIView animateWithDuration:0.25f
                                   delay:0.00f
                                 options:UIViewAnimationOptionTransitionCurlUp
                              animations:^{
                                  [lbl1 removeFromSuperview];
                                  lbl1.alpha=0.0f;
                                  lbl1.frame=CGRectMake(0, 200, self.frame.size.width, 100);
                                  
                              }
                              completion:nil];
             
             [UIView animateWithDuration:0.25f
                                   delay:0.0f
                                 options:UIViewAnimationOptionTransitionCurlUp
                              animations:^{
                                  lbl1.alpha=1.0f;
                                  
                                  lbl1.frame=CGRectMake(0, 50, self.frame.size.width, 100);
                                  
                                  [self addSubview:lbl1];
                              }
                              completion:nil];
                     
        
    }
    else
        i = 0;
    
}


@end
