//
//  FCVCalendarViewController.m
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/12/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "FCVCalendarViewController.h"
#import "FCVDayModel.h"
#import "FCVEventDetailsCell.h"

@interface FCVCalendarViewController ()

@end

@implementation FCVCalendarViewController {
    NSMutableArray* _events;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup the weekday titles dynamically
    float width = self.view.frame.size.width/7;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSArray<NSString*>* weekdays = [df shortWeekdaySymbols];
    for(int i = 0; i < 7; i++){
        NSString * symbol = [weekdays objectAtIndex:i];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(width*i, 0, width, self.view_weekdaysContainer.frame.size.height)];
        [lbl setText:symbol];
        [lbl setNumberOfLines:1];
        [lbl setFont:[UIFont fontWithName:@"System" size:10]];
        [lbl setTextColor:[UIColor lightGrayColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [self.view_weekdaysContainer addSubview:lbl];
    }
    
    
    // Setup the calendar view
    [self.calendarView setDelegate:self];
    self.calendarView.frame = CGRectMake(self.calendarView.frame.origin.x, self.calendarView.frame.origin.y, self.view.frame.size.width, 300);
    [self.calendarView setSelectedDate:[NSDate date] withAnimationDuration:0];
    [self.calendarView initGestures];
    [self.view_eventTable setDelegate:self];
    [self.view_eventTable setDataSource:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:@"Calendar Events Loaded" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma UITableView

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(_events){
        return _events.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    FCVEventDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailsCell"];
    if(cell == nil){
        cell = [[FCVEventDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventDetailsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    EKEvent *event = (EKEvent*) [_events objectAtIndex:indexPath.row];
    
    UIColor *color = [UIColor colorWithCGColor:event.calendar.CGColor];
    cell.view_base.backgroundColor = color;
    
    // If the background isn't light (dark), set the cell label colors to white
    if(![self isLightColor:color]){
        cell.lbl_eventTitle.textColor = [UIColor whiteColor];
        cell.lbl_eventInfo.textColor = [UIColor whiteColor];
    }
    
    
    cell.lbl_eventTitle.text = event.title;
    
    if(event.isAllDay){
        cell.lbl_eventInfo.text = [NSString stringWithFormat:@"%@",event.calendar.title];
    } else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.timeStyle = NSDateFormatterMediumStyle;
        df.dateStyle = NSDateFormatterNoStyle;
        
        NSString *start = [df stringFromDate:event.startDate];
        NSString *end = [df stringFromDate:event.endDate];
        NSString *location = event.location;
        
        cell.lbl_eventInfo.text = [NSString stringWithFormat:@"%@ - %@ at %@",start,end,location];
    }
    
    
    return cell;
}

// http://stackoverflow.com/questions/13726935/determine-if-color-is-light-or-dark
-(BOOL) isLightColor:(UIColor*)clr {
    CGFloat white = 0;
    [clr getWhite:&white alpha:nil];
    return (white >= 0.5);
}




// When the user presses the date or month
-(IBAction)didPressSelectedDate:(id)sender {
    if(self.lcst_calendarHeight.constant==0){
        // If the calendar is hidden, display it
        [self showMonthView];
    } else {
        // If calendar is showing, hide it
        [self hideMonthView];
    }
    
    // Update the label
    [self setCalendarLabelForDate:[_calendarView getSelectedDate]];
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


// The day which was selected has changed
- (void) selectedDateDayChange: (NSDate *)date {
    NSLog(@"Date was selected");
    // Set date to: DayOfWeek - Month DD, Year
    [self setCalendarLabelForDate:date];
    
}

- (void) eventsDidChange:(NSMutableArray *)events {
    _events = events;
    [self.view_eventTable reloadData];
}

// Hide the month view so more event blocks may be seen
- (void) hideMonthView {
    [UIView animateWithDuration:0.15 animations:^{
        _lcst_calendarHeight.constant=0;
        _lcst_daysHeight.constant=0;
    }];
    
}

// Display the hidden month view
- (void) showMonthView {
    [UIView animateWithDuration:0.15 animations:^{
        _lcst_calendarHeight.constant = _calendarView.contentSize.height;
        _lcst_daysHeight.constant=20;
    }];
}


// Updates the calendar label
- (void) setCalendarLabelForDate:(NSDate*) date {
    if(self.lcst_calendarHeight.constant>0){
        // Month view is showing, only display month and year
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *monthName = [[formatter monthSymbols] objectAtIndex:comp.month-1];
        [self.btn_selectedDate setTitle:[NSString stringWithFormat:@"%@, %ld",monthName,comp.year] forState:(UIControlStateNormal)];
    } else {
        NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
        [self.btn_selectedDate setTitle:localizedDateTime forState:(UIControlStateNormal)];
    }
}

// Notification was received by the OS
- (void) didReceiveNotification:(NSNotification*) notification {

    
    if([notification.name isEqualToString:@"Calendar Events Loaded"]) {
        
        // Update the date source
        if(notification.object == [_calendarView getSelectedDayModel]){
            _events = [_calendarView getSelectedDayModel].eventsList;
            [self.view_eventTable reloadData];
        }
    }
    
    
}





@end
