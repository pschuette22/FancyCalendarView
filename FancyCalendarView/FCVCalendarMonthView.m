//
//  FCVCalendarDayView.h
//  Fancy Calendar View
//
//  Created by Peter Schuette on 2/12/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "FCVCalendarMonthView.h"
#import "FCVCalendarDayView.h"
#import "FCVMonthModel.h"
#import "FCVDayModel.h"

#define DAY_VIEW_HEIGHT 50

@implementation FCVCalendarMonthView {
    NSDate *_firstDayOfMonth;
    NSMutableArray* _dayViews;
    CGSize _contentSize;
}
/*
 * Initialize the view with a given frame
 */
-(id) initWithFrame:(CGRect)frame withMonth: (FCVMonthModel*) model {
    
    if(self=[super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
         // Allocate objects
        _contentSize = frame.size;
        _dayViews = [[NSMutableArray alloc] init];
        _firstDayOfMonth = model.getFirstDay;
        
        // Draw individual days in the month
        CGFloat dayWidth = frame.size.width/7;

        NSMutableArray *days = model.getDays;
        
        for(int i = 0; i < days.count; i++){
            FCVDayModel *dayModel = [days objectAtIndex:i];
            CGRect frame = CGRectMake(([dayModel getDayOfWeek]-1)*dayWidth, ([dayModel getWeekOfMonth]-1)*DAY_VIEW_HEIGHT, dayWidth, DAY_VIEW_HEIGHT);
            
            FCVCalendarDayView *dayView = [[[NSBundle mainBundle] loadNibNamed:@"Calendar_Day_View"
                                                                         owner:self
                                                                       options:nil]
                                           objectAtIndex:0];
            dayView.frame = frame;
            [self addSubview:dayView];
            [dayView setDayModel:dayModel];
            dayView.backgroundColor = [UIColor whiteColor];
            [_dayViews addObject:dayView];
        }
        
        // Update the content size to account for the number of rows
        _contentSize.height = DAY_VIEW_HEIGHT * [[_dayViews lastObject] frame].size.height;
     
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
        self.layer.borderWidth = 1;
    }
    
    return self;
}

/*
 * Determine if a given day is shown in this month view
 */
- (BOOL) isDateInMonth:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if(_firstDayOfMonth) {
        NSDateComponents *currentComp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:_firstDayOfMonth];
        NSDateComponents *dateComp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
        // return true if the month and year are the same
        return (currentComp.month == dateComp.month && currentComp.year == dateComp.year);
    }
    
    return NO;
}

// Set the currently selected date
- (FCVCalendarDayView *) setSelectedDate: (NSDate *) date {
    if(date){
    for(int i = 0; i < _dayViews.count; i++){
        FCVCalendarDayView *dayView = [_dayViews objectAtIndex:i];
        if([dayView isDate:date]){
            [dayView setSelected:YES];
            return dayView;
        }
    }
    } else {
        NSLog(@"Selected date is null");
    }
    return nil;
}

// Simple getter to get the first day of the month
- (NSDate*) getFirstDateOfMonth {
    return  _firstDayOfMonth;
}

// Get the size of the content
- (CGSize) getContentSize {
    return _contentSize;
}

@end
