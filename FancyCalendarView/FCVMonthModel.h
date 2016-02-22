//
//  FCVMonthModel.h
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/14/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FCVMonthModel : NSObject

@property (getter=getDays) NSMutableArray* days;
@property (getter=getFirstDay) NSDate *firstDay;

-(id) initWithDate: (NSDate*) date;


@end
