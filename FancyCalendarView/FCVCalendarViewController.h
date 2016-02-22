//
//  FCVCalendarViewController.h
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/12/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCVCalendarView.h"
#import "FCVConstants.h"

@interface FCVCalendarViewController : UIViewController <FCVCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_selectedDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcst_calendarHeight;
@property (weak, nonatomic) IBOutlet FCVCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *view_eventTable;


@end
