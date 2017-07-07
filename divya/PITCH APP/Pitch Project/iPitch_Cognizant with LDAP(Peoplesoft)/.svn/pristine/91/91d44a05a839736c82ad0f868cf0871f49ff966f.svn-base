//
//  LabelAnim.h
//  sampleAnim
//
//  Created by Santhosh Kumar on 21/01/13.
//  Copyright (c) 2013 Santhosh Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MetroTileAnimationTypeVertical = 1,
    MetroTileAnimationTypeHorizontal = 2
} MetroTileAnimationType;

@interface MetroTile : UIView{
    UIView *view1;
    NSMutableArray *array1;
    UILabel *lbl1;
    NSTimer *timer1;
    UIButton *btn1;
}

@property(nonatomic, strong) UIView *view1;
@property(nonatomic, strong) NSMutableArray *array1;
@property(nonatomic, strong) UILabel *lbl1;
@property(nonatomic, strong) NSTimer *timer1;
@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, assign) MetroTileAnimationType animationType;

-(void) configureLabel;

@end
