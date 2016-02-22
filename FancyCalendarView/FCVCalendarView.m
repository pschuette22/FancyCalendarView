//
//  FCVCalendarView.m
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/17/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import "FCVCalendarView.h"
#import "FCVCalendarDayView.h"
#import "FCVCalendarMonthView.h"
#import "FCVConstants.h"

#define ANIMATION_DURATION 0.1

@implementation FCVCalendarView {
    CGPoint panStartPoint;
    CGPoint lastTouchPoint;
    CGSize _contentSize;
    
}

// When the view is deallocated, unregister for the notification
-(void) dealloc {
    // Unregister for notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

// When notifications are received from the UI
- (void) didReceiveNotification:(NSNotification*) notification {
    NSLog(@"Notification Received with Name: %@",notification.name);
    
    // If a day was selected,
    if([notification.name isEqualToString:@"Date Selected"]) {
        NSDate *selectedDate = notification.object;
        [self setSelectedDate:selectedDate withAnimationDuration:0];
    } else if ([notification.name isEqualToString:@"Calendar Events Loaded"]) {
        
        // Passed the model of the day in which notifications were loaded
        FCVDayModel *model = notification.object;
        
        if (_previousMonth && [_previousMonth isDateInMonth:model.date]) {
            [_previousMonth eventsDidUpdate:model];
        } else if (_currentMonth && [_currentMonth isDateInMonth:model.date]) {
            [_currentMonth eventsDidUpdate:model];
        } else if (_nextMonth && [_nextMonth isDateInMonth:model.date]) {
            [_nextMonth eventsDidUpdate:model];
        }
        
    }
}

/*
 * Get the content size of this view.
 * This does not necessarily represent the current size of the view,
 * it holds how large the view would like to be
 */
- (CGSize) getContentSize {
    return _contentSize;
}

///////////////////////
//
# pragma mark Gestures
//
///////////////////////

/*
 * Initialize the gestures that this view recognizes
 */
- (void) initGestures {
//    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    
    [self addGestureRecognizer:_panRecognizer];
    [self addGestureRecognizer:_swipeRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:@"Date Selected" object:nil];
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:@"Calendar Events Loaded" object:nil];
}

- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showNextMonthWithAnimation:YES withDuration:ANIMATION_DURATION];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showPreviousMonthWithAnimation:YES withDuration:ANIMATION_DURATION];
    }
    
}

//
- (IBAction)panDetected:(UIPanGestureRecognizer *)sender {
    
    // If the pan ended
    if(sender.state == UIGestureRecognizerStateEnded ||sender.state == UIGestureRecognizerStateCancelled)
    {
        
        CGFloat delta_x = lastTouchPoint.x-panStartPoint.x;
        //    NSLog(@"Adjust yo self");
        if(delta_x > 0){
            
            // If swiped more than 30% of the screen, show previous month
            if(delta_x > .4*self.bounds.size.width){
                float duration = ANIMATION_DURATION*(self.frame.size.width-delta_x)/self.frame.size.width;
                [self showPreviousMonthWithAnimation:YES withDuration:duration];
            } else {
                
                [self setFramePositionsWithAnimationDuration:ANIMATION_DURATION];
            }
            
        } else {
            
            // If swiped to next month for more than %40 of the screen
            if (delta_x < -.4*self.bounds.size.width){
                float duration = ANIMATION_DURATION*(self.frame.size.width+delta_x)/self.frame.size.width;
                [self showNextMonthWithAnimation:YES withDuration:duration];
            } else {
                [self setFramePositionsWithAnimationDuration:ANIMATION_DURATION];
                
            }
            
        }
        
    }
    
    // Make sure they are only dragging with one finger
    if(sender.numberOfTouches == 1){
        //    NSLog(@"Pan: %ld",(long)[sender state]);
        // If the gesture began, set the start point
        if(sender.state == UIGestureRecognizerStateBegan) {
            panStartPoint = [sender locationInView:self];
        }
        lastTouchPoint = [sender locationInView:self];
        
        // If the state changed, account for the translation
        if (sender.state == UIGestureRecognizerStateChanged) {
            
            CGPoint changePoint = [sender locationInView:self];
            CGFloat delta_x = changePoint.x-panStartPoint.x;
            if(delta_x >= 0){
                // Move the current calendar to show the view under it
                [UIView animateWithDuration:0.05 animations:^{
                    _currentMonth.frame = CGRectMake(delta_x,0,_currentMonth.getContentSize.width, _currentMonth.getContentSize.height);
                    // Resize the calendar under
                }];
            } else if (delta_x<0) {
                // Move the next month view over the current month view
                [UIView animateWithDuration:0.05 animations:^{
                    _nextMonth.frame = CGRectMake(self.bounds.size.width+delta_x, 0, _nextMonth.getContentSize.width, _nextMonth.getContentSize.height);
                    // Move the frame delta x
                }];
                
            }
            //     NSLog(@"Pan delta x = %f",delta_x);
        }
        
    }
}


// Quick getter for retrieving the currently selected date
- (NSDate*) getSelectedDate {
    return [_selectedDayView getDayModel].date;
}

/*
 * Set the currently selected date
 */
-(void) setSelectedDate:(NSDate *)date withAnimationDuration: (float) duration {
    BOOL frameDidChange = NO;
    // Determine if current month contains selected date
    if(_currentMonth && [_currentMonth isDateInMonth:date]){
        // No changes need to be made, will update the currently selected date
    } else if (_previousMonth && [_previousMonth isDateInMonth:date]){
        // If the previous month contains the date
        [_nextMonth removeFromSuperview];
        _nextMonth = _currentMonth;
        _currentMonth = _previousMonth;
        [self loadPreviousMonthViewForDate:date];
        frameDidChange = YES;
    } else if (_nextMonth && [_nextMonth isDateInMonth:date]) {
        // If the previous month contains the date
        [_previousMonth removeFromSuperview];
        _previousMonth = _currentMonth;
        _currentMonth = _nextMonth;
        [self loadNextMonthViewForDate:date];
        frameDidChange = YES;
    } else {
        [self loadPreviousMonthViewForDate:date];
        [self loadCurrentMonthViewForDate:date];
        [self loadNextMonthViewForDate:date];
        frameDidChange = YES;
    }
    
    
    // Set the currently selected day view as not selected
    if(_selectedDayView){
        [_selectedDayView setSelected:NO];
    }
    // Set the selected day view
    _selectedDayView = [_currentMonth setSelectedDate:date];
    
    // Notify the delegate a day was selected
    if(_delegate && [_delegate respondsToSelector:@selector(selectedDateDayChange:)]){
        [_delegate selectedDateDayChange:date];
    }
    
    // Notify the delegate a day was selected
    if(_delegate && [_delegate respondsToSelector:@selector(eventsDidChange:)]){
        [_delegate eventsDidChange:[_selectedDayView getDayModel].eventsList];
    }
    
    
    
    // If the frames changed, make sure they are updated accordingly
    if(frameDidChange) {
        [self setFramePositionsWithAnimationDuration:duration];
    }
}

- (void) showNextMonthWithAnimation:(BOOL) doAnimate withDuration: (float) duration {
    // Get the next month of the selected date
    NSDate *today = [NSDate date];
    
    if([_nextMonth isDateInMonth:today]){
        [self setSelectedDate:today withAnimationDuration: ANIMATION_DURATION];
    } else {
        [self setSelectedDate:_nextMonth.getFirstDateOfMonth withAnimationDuration: ANIMATION_DURATION];
    }
    
}

- (void) showPreviousMonthWithAnimation:(BOOL) doAnimate withDuration: (float) duration{
    // Get the next month of the selected date
    NSDate *today = [NSDate date];
    
    if([_previousMonth isDateInMonth:today]){
        [self setSelectedDate:today withAnimationDuration:doAnimate?duration:0];
    } else {
        [self setSelectedDate:_previousMonth.getFirstDateOfMonth withAnimationDuration:doAnimate?duration:0];
    }

    
}
// Animate layout changes
-(void) setFramePositionsWithAnimationDuration:(float) duration {
    [UIView animateWithDuration:duration animations:^{
        _previousMonth.frame = CGRectMake(0,0,_previousMonth.getContentSize.width, _previousMonth.getContentSize.height);
        _currentMonth.frame = CGRectMake(0,0,_currentMonth.getContentSize.width, _currentMonth.getContentSize.height);
        _nextMonth.frame = CGRectMake(self.bounds.size.width+5, 0, _nextMonth.getContentSize.width, _nextMonth.getContentSize.height);
        
        // Notify the delegate the day did change
        if (_delegate && [_delegate respondsToSelector:@selector(frameDidChange:)]){
            [_delegate frameDidChange:_currentMonth.frame];
            
            if(_currentMonth.frame.size.height!=0 && _currentMonth.frame.size.width!=0){
                // Make sure content size is not being set to 0 height or width due to layout constraints
                _contentSize.height = _currentMonth.frame.size.height;
                _contentSize.width = _currentMonth.frame.size.width;
            }
            
        }
        
    }];
}

// Simple getter
- (FCVDayModel*) getSelectedDayModel {
    return [_selectedDayView getDayModel];
}

// Load and set the previous month
- (void) loadPreviousMonthViewForDate: (NSDate*)date {
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute| NSCalendarUnitSecond) fromDate:date];
    [comp setDay:1];
    [comp setHour:1];
    [comp setMinute:0];
    [comp setSecond:0];
    NSDate *firstOfMonth = [[NSCalendar currentCalendar] dateFromComponents:comp];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate* previous = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:firstOfMonth options:0];
    
    FCVMonthModel *previousMonthModel = [[FCVMonthModel alloc] initWithDate:previous];
    _previousMonth = [[FCVCalendarMonthView alloc] initWithFrame:self.frame withMonth:previousMonthModel];
    _previousMonth.frame = CGRectMake(0, 0, _previousMonth.getContentSize.width, _previousMonth.getContentSize.height);
    if(_currentMonth){
        [self insertSubview:_previousMonth belowSubview:_currentMonth];
    } else if(_nextMonth){
        [self insertSubview:_previousMonth belowSubview:_nextMonth];
    } else {
        [self addSubview:_previousMonth];
    }
    
}


// Load month view as current month view
- (void) loadCurrentMonthViewForDate: (NSDate*)date  {
    
    FCVMonthModel *currentMonthModel = [[FCVMonthModel alloc] initWithDate:date];
    _currentMonth = [[FCVCalendarMonthView alloc] initWithFrame:self.frame withMonth:currentMonthModel];
    _currentMonth.frame = CGRectMake(0, 0, _currentMonth.getContentSize.width, _currentMonth.getContentSize.height);
    if(_previousMonth){
        [self insertSubview:_currentMonth aboveSubview:_previousMonth];
    } else if (_nextMonth) {
        [self insertSubview:_currentMonth belowSubview:_nextMonth];
    } else {
        [self addSubview:_currentMonth];
    }
    
}


// Load and set the next month
- (void) loadNextMonthViewForDate: (NSDate*)date  {
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute| NSCalendarUnitSecond) fromDate:date];
    [comp setDay:1];
    [comp setHour:1];
    [comp setMinute:0];
    [comp setSecond:0];
    
    NSDate *firstOfMonth = [[NSCalendar currentCalendar] dateFromComponents:comp];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:1];
    NSDate* next = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:firstOfMonth options:0];

    FCVMonthModel *nextMonthModel = [[FCVMonthModel alloc] initWithDate:next];
    _nextMonth = [[FCVCalendarMonthView alloc] initWithFrame:self.frame withMonth:nextMonthModel];
    // Frame is off screen
    _nextMonth.frame = CGRectMake(self.bounds.size.width+5, 0, _nextMonth.getContentSize.width, _nextMonth.getContentSize.height);
    if(_currentMonth) {
        [self insertSubview:_nextMonth aboveSubview:_currentMonth];
    } else if(_previousMonth) {
        [self insertSubview:_nextMonth aboveSubview:_previousMonth];
    } else {
        [self addSubview:_nextMonth];
    }
}



@end
