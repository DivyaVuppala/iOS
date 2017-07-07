//
//  SDayViewCell.m
//  iPitch V2
//
//  Created by Satheeshwaran on 1/25/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "SDayViewCell.h"

@implementation SDayViewCell
@synthesize appointmentIcon,BackGroundViewEvent;
@synthesize AppointmenteventVenue,appointmentTime;
@synthesize appointmentTitle;
@synthesize timeOfDay;
@synthesize linkedinButton;
@synthesize twitterButton;
@synthesize DetailButton;
@synthesize CellDocumentsView;
@synthesize  PastAppointmentsView;
@synthesize lblDetail1;
@synthesize lblDetail2;
@synthesize lblHeaderApp;
@synthesize lblScrollDocuments;
@synthesize addDocumentButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
