//
//  FCVDayModel.h
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/15/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface FCVDayModel : NSObject

@property (getter=getDate) NSDate* date;
@property (getter=didLoadEvents) BOOL isLoadingEvents;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) EKCalendar *defaultCalendar;
@property (nonatomic, strong) NSMutableArray *eventsList;

typedef void (^EventLoadCompletionBlock) (NSError * error, BOOL accessGranted, NSMutableArray *events);

-(id) initWithDate:(NSDate*) date;

-(NSInteger) getDayOfMonth;
-(NSInteger) getDayOfWeek;
-(NSInteger) getWeekOfMonth;
-(NSMutableArray *) getEvents;


- (void) loadEvents:(EventLoadCompletionBlock) completionBlock;

@end
