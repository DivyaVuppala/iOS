//
//  SSimpleCalculator.h
//  iPitch V2
//
//  Created by Satheeshwaran on 2/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSimpleCalculator : UIViewController
{
    //Where all the calculations are shown
    IBOutlet UILabel *mainLabel;
    
    //Stores the last known value before an operand is pressed
    double lastKnownValue;
    
    NSString *operand;
    
    BOOL isMainLabelTextTemporary;
    
}
@property (weak, nonatomic) IBOutlet UIToolbar *calculatorDoneButton;
@property (weak, nonatomic) IBOutlet UIToolbar *calculatorCopyButton;
- (IBAction)clearPressed:(id)sender;
- (IBAction)numberButtonPressed:(id)sender;
- (IBAction)decimalPressed:(id)sender;
- (IBAction)operandPressed:(id)sender;
- (IBAction)equalsPressed:(id)sender;
- (IBAction)calculatorDoneButtonPressed:(id)sender;
- (IBAction)calculatorCopyButton:(id)sender;
@end
