//
//  FCVCalendarDayView.h
//  Fancy Calendar View
//
//  Created by Peter Schuette on 2/11/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "FCVCalendarDayView.h"
#import "FCVConstants.h"
#import <QuartzCore/QuartzCore.h>


@implementation FCVCalendarDayView {
    FCVDayModel* _dayModel;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) setDayModel:(FCVDayModel *)dayModel {
    _dayModel = dayModel;
    _isSelected = NO;
    _lbl_date.text = [NSString stringWithFormat:@"%tu",dayModel.getDayOfMonth];
    
    
    // Just to make sure
    [self setEventsIndicator];

    // Initialize the tap gesture recognizer with passed selector
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    _view_eventsIndicator.layer.cornerRadius = 5;
    
}

// Method is calls when a tap is detected on this
- (IBAction) tapDetected:(UITapGestureRecognizer*) sender {
    // Tap was detected by the view
    NSLog(@"Tap detected on day" );
    // Post a notification informing the application a date was selected
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Date Selected" object:_dayModel.date];
    
}


// Simple getter
- (FCVDayModel*) getDayModel {
    return _dayModel;
}


// Determine if the Year, Month and Day are the same
- (BOOL) isDate:(NSDate *) date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *comp1 = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_dayModel.date];
    NSDateComponents *comp2 =[gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return (comp1.year==comp2.year && comp1.month == comp2.month && comp1.day == comp2.day);
}


// Tell this date to be selected
- (void) setSelected:(BOOL) isSelected {
    _isSelected = isSelected;
    if(isSelected){
        _lbl_date.backgroundColor = [UIColor cyanColor];
        _lbl_date.layer.cornerRadius = 14;
        _lbl_date.clipsToBounds=true;
        
    } else {
        _lbl_date.backgroundColor = [UIColor whiteColor];
        _lbl_date.layer.borderWidth = 0;
    }
}

// Set the events indicator
- (void) setEventsIndicator {
    if(_dayModel.eventsList && _dayModel.eventsList.count>0){
        _view_eventsIndicator.alpha=1;
    } else {
        _view_eventsIndicator.alpha=0;
    }
}

-(BOOL) clipsToBounds {
    return YES;
}


@end
