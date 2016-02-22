//
//  FCVCalendarDayView.h
//  Fancy Calendar View
//
//  Created by Peter Schuette on 2/12/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FCVCalendarDayView.h"
#import "FCVMonthModel.h"


@interface FCVCalendarMonthView : UIView


- (id) initWithFrame:(CGRect)frame withMonth:(FCVMonthModel *) monthModel;
- (BOOL) isDateInMonth: (NSDate*) date;
- (FCVCalendarDayView *) setSelectedDate: (NSDate *) date;
- (CGSize) getContentSize;
- (NSDate*) getFirstDateOfMonth;
- (void) eventsDidUpdate:(FCVDayModel*)dayModel;

@end
