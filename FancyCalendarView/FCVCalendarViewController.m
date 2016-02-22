//
//  FCVCalendarViewController.m
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/12/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "FCVCalendarViewController.h"

@interface FCVCalendarViewController ()

@end

@implementation FCVCalendarViewController {
    NSMutableArray* _events;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.calendarView setDelegate:self];
    self.calendarView.frame = CGRectMake(self.calendarView.frame.origin.x, self.calendarView.frame.origin.y, self.view.frame.size.width, 250);
    [self.calendarView setSelectedDate:[NSDate date]];
    [self.calendarView initGestures];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


# pragma mark - CalendarViewDelegate
- (void) frameDidChange:(CGRect) frame {
    NSLog(@"frame changed");
    self.lcst_calendarHeight.constant = frame.size.height;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void) selectedDateDayChange: (NSDate *)day {
    NSLog(@"Date was selected");
}



@end
