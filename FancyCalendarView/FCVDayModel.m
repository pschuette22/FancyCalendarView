//
//  FCVDayModel.m
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/15/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import "FCVDayModel.h"
#import <EventKit/EventKit.h>

@implementation FCVDayModel

/**
 * Initialize the Day Model to a specific date
 */
-(id) initWithDate:(NSDate*) date {
    
    if(self=[super init]){
        
        self.date = date;
    }
    
    return self;
}

/**
 * Special Getters
 */
-(NSInteger) getDayOfMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitDay) fromDate:self.date];
    return comp.day;
}


-(NSInteger) getDayOfWeek {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitWeekday) fromDate:self.date];
    return comp.weekday;
}

-(NSInteger) getWeekOfMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitWeekOfMonth) fromDate:self.date];
    return comp.weekOfMonth;
}

/*
 * Load the events from the calendar
 */
- (void) loadEvents:(EventLoadCompletionBlock) completionBlock {
    // TODO: implement when UI is working properly
//    EKEventStore *store = [[EKEventStore alloc] init];
//    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//        // handle access here
//        if(!error && granted){
//            
//            NSDateComponents *comp =[[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday | NSCalendarUnitNanosecond) fromDate:self.date];
//            comp.day+=1;
//            comp.nanosecond-=1;
//            
//            NSDate * endOfDay = [[NSCalendar currentCalendar] dateFromComponents:comp];
//            NSPredicate *predicate = [store predicateForCompletedRemindersWithCompletionDateStarting:self.date ending:endOfDay calendars:nil];
//            
//            // Enumerate through the events, initializing
//            self.events = [store eventsMatchingPredicate:predicate];
//            
//        }
//        
//        completionBlock(error,granted,self.events);
//    }];
}


@end
