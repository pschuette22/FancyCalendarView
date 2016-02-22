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
        self.eventStore = [[EKEventStore alloc] init];
        self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadEvents:nil];
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
// Get the list of events currently held by this model
-(NSMutableArray *) getEvents {
    return _eventsList;
}

/*
 * Load the events from the calendar
 */
- (void) loadEvents:(EventLoadCompletionBlock) completionBlock {
    // TODO: implement when UI is working properly
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
        if(granted){
            
            FCVDayModel * __weak weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself readEventsFromCalendar];
            });
            
        }
        
    }];
}

/**
 * Read the events from the user's calendar
 */
- (void) readEventsFromCalendar {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comp =[[NSDateComponents alloc ] init];
    [comp setDay:1];
    
    NSArray * calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    
    NSDate * endOfDay = [gregorian dateByAddingComponents:comp toDate:self.date options:0];
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:self.date endDate:endOfDay calendars:calendars];
    
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    if(events.count == 0 && self.eventsList.count == 0){
        // There were no events loaded or held in the first place
    } else {
        // It might make sense to not be lazy and only notify the phone if there is an update but.... fuck it for now
        self.eventsList = events;
        // Dispatch notification?
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Calendar Events Loaded" object:self];
    }
}


@end
