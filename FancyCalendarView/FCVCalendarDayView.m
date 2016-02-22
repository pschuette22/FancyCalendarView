//
//  FCVCalendarDayView.h
//  Fancy Calendar View
//
//  Created by Peter Schuette on 2/11/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "FCVCalendarDayView.h"

@implementation FCVCalendarDayView {
    FCVDayModel* _dayModel;
//    UILabel* _lbl_date;
//    UIView* _view_eventsIndicator;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (id) initWithFrame:(CGRect)frame withModel:(FCVDayModel *)model {
//    if(self=[super initWithFrame:frame]) {
//        // Draw the divider view
//        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
//        divider.backgroundColor = [UIColor lightTextColor];
//        [self addSubview:divider];
//        // Draw the label
//        _lbl_date = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width/2)-13, 8, 26, 26)];
//        _lbl_date.text = [NSString stringWithFormat:@"%ldt",model.getDayOfMonth];
//        [self addSubview:_lbl_date];
//        
//        // Draw the event indicator
//        _view_eventsIndicator = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width/2)-8, 8, 16, 16) ];
//        _view_eventsIndicator.backgroundColor = [UIColor cyanColor];
//        _view_eventsIndicator.alpha = 0;
//        [self addSubview:_view_eventsIndicator];
//        
//    }
//    
//    return self;
//}

- (void) setDayModel:(FCVDayModel *)dayModel {
    _dayModel = dayModel;
    _isSelected = NO;
    _lbl_date.text = [NSString stringWithFormat:@"%tu",dayModel.getDayOfMonth];
    
    // Load the events from the model
    [dayModel loadEvents:^(NSError *error, BOOL accessGranted, NSArray<EKEvent *> *events) {
        if(error){
            // Indicate there was an error
        } else if (!accessGranted) {
            // Indicate access is not granted
        }
        
        [self setEventsIndicator];
    }];
    // Just to make sure
    [self setEventsIndicator];
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
    isSelected = _isSelected;
    if(isSelected){
        _lbl_date.backgroundColor = [UIColor cyanColor];
    } else {
        _lbl_date.backgroundColor = [UIColor lightGrayColor];
    }
}

// Set the events indicator
- (void) setEventsIndicator {
    if(_dayModel.events && _dayModel.events.count>0){
        _view_eventsIndicator.alpha=1;
    } else {
        _view_eventsIndicator.alpha=0;
    }
}

-(BOOL) clipsToBounds {
    return YES;
}


@end
