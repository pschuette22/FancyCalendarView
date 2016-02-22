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
@property (getter=getEvents) NSArray<EKEvent *> *events;

typedef void (^EventLoadCompletionBlock) (NSError * error, BOOL accessGranted, NSArray<EKEvent *> *events);

-(id) initWithDate:(NSDate*) date;

-(NSInteger) getDayOfMonth;
-(NSInteger) getDayOfWeek;
-(NSInteger) getWeekOfMonth;

- (void) loadEvents:(EventLoadCompletionBlock) completionBlock;

@end
