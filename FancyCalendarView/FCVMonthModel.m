//
//  FCVMonthModel.m
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/14/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import "FCVMonthModel.h"
#import "FCVDayModel.h"

@implementation FCVMonthModel


-(id) initWithDate: (NSDate*) date {
    
    if(self = [super init]) {
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        /**
         * Determine the first day of this month from associated date
         */
        NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond) fromDate: date];
        [comp setDay:1];
        [comp setHour:1];
        [comp setMinute:0];
        [comp setNanosecond:0];
        
        // Set the first day of the month
        self.firstDay = [gregorian dateFromComponents:comp];
        
        // Allocate Day Views
        NSRange days = [gregorian rangeOfUnit:NSCalendarUnitDay
                               inUnit:NSCalendarUnitMonth
                              forDate:self.firstDay];
        
        /*
         * Iterate through month days and increment component days
         */
        self.days = [[NSMutableArray alloc] init];
        for(int i = 0; i< days.length; i++){
            NSDateComponents *comp = [[NSDateComponents alloc] init];
            [comp setDay:i];
            NSDate *date = [gregorian dateByAddingComponents:comp toDate:self.firstDay options:0];
            FCVDayModel *day = [[FCVDayModel alloc] initWithDate:date];
            [self.days addObject:day];
        }
        
    }
    
    return self;
}



@end
