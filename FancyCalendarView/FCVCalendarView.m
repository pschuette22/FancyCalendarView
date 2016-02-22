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

#define ANIMATION_DURATION 0.15

@implementation FCVCalendarView {
    CGPoint panStartPoint;
    CGPoint lastTouchPoint;
    
}


// Initialize the gesture recognizers
- (void) initGestures {
//    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [self addGestureRecognizer:_panRecognizer];
    [self addGestureRecognizer:_swipeRecognizer];
}


/*
 * Set the currently selected date
 */

-(void) setSelectedDate:(NSDate *)date {
    
    // Determine if current month contains selected date
    if(_currentMonth && [_currentMonth isDateInMonth:date]){
        // No changes need to be made, will update the currently selected date
    } else if (_previousMonth && [_previousMonth isDateInMonth:date]){
        // If the previous month contains the date
        _nextMonth = _currentMonth;
        _currentMonth = _previousMonth;
        [self loadPreviousMonthViewForDate:date];
    } else if (_nextMonth && [_nextMonth isDateInMonth:date]) {
        // If the next month contains the date
        _previousMonth = _currentMonth;
        _currentMonth = _nextMonth;
        [self loadNextMonthViewForDate:date];
    } else {
        [self loadPreviousMonthViewForDate:date];
        [self loadCurrentMonthViewForDate:date];
        [self loadNextMonthViewForDate:date];
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
    
    // Notify the delegate the day did change
    if (_delegate && [_delegate respondsToSelector:@selector(frameDidChange:)]){
        [_delegate frameDidChange:_currentMonth.frame];
    }
    
    
    
}

- (void) showNextMonthWithAnimation:(BOOL) doAnimate withDuration: (float) duration {
    // Get the next month of the selected date
    NSDate *today = [NSDate date];
    
    if([_nextMonth isDateInMonth:today]){
        [self setSelectedDate:today];
    } else {
        [self setSelectedDate:_nextMonth.getFirstDateOfMonth];
    }
    
    [self setFramePositionsWithAnimationDuration:doAnimate?duration:0];
}

- (void) showPreviousMonthWithAnimation:(BOOL) doAnimate withDuration: (float) duration{
    // Get the next month of the selected date
    NSDate *today = [NSDate date];
    
    if([_previousMonth isDateInMonth:today]){
        [self setSelectedDate:today];
    } else {
        [self setSelectedDate:_previousMonth.getFirstDateOfMonth];
    }

    [self setFramePositionsWithAnimationDuration:doAnimate?duration:0];
    
}
// Animate layout changes
-(void) setFramePositionsWithAnimationDuration:(float) duration {
    [UIView animateWithDuration:duration animations:^{
        _previousMonth.frame = CGRectMake(0,0,_previousMonth.getContentSize.width, _previousMonth.getContentSize.height);
        _currentMonth.frame = CGRectMake(0,0,_currentMonth.getContentSize.width, _currentMonth.getContentSize.height);
        _nextMonth.frame = CGRectMake(self.bounds.size.width+5, 0, _nextMonth.getContentSize.width, _nextMonth.getContentSize.height);
    }];
}

// Simple getter
- (FCVDayModel*) getSelectedDayModel {
    return _selectedDayModel;
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
    _previousMonth = [[FCVCalendarMonthView alloc] initWithFrame:self.bounds withMonth:previousMonthModel];
    [UIView animateWithDuration:0.1 animations:^{
        _previousMonth.frame = CGRectMake(0, 0, _previousMonth.getContentSize.width, _previousMonth.getContentSize.height);
        if(_currentMonth){
            [self insertSubview:_previousMonth belowSubview:_currentMonth];
        } else if(_nextMonth){
            [self insertSubview:_previousMonth belowSubview:_nextMonth];
        } else {
            [self addSubview:_previousMonth];
        }
    }];
    
}


// Load month view as current month view
- (void) loadCurrentMonthViewForDate: (NSDate*)date  {
    
    CGRect frame = self.bounds;
    FCVMonthModel *currentMonthModel = [[FCVMonthModel alloc] initWithDate:date];
    _currentMonth = [[FCVCalendarMonthView alloc] initWithFrame:frame withMonth:currentMonthModel];
    [UIView animateWithDuration:0.1 animations:^{
        _currentMonth.frame = CGRectMake(0, 0, _currentMonth.getContentSize.width, _currentMonth.getContentSize.height);
        if(_previousMonth){
            [self insertSubview:_currentMonth aboveSubview:_previousMonth];
        } else if (_nextMonth) {
            [self insertSubview:_currentMonth belowSubview:_nextMonth];
        } else {
            [self addSubview:_currentMonth];
        }
    }];
    
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
    _nextMonth = [[FCVCalendarMonthView alloc] initWithFrame:self.bounds withMonth:nextMonthModel];
    [UIView animateWithDuration:0.1 animations:^{
        // Frame is off screen
        _nextMonth.frame = CGRectMake(self.bounds.size.width+5, 0, _nextMonth.getContentSize.width, _nextMonth.getContentSize.height);
        if(_currentMonth) {
            [self insertSubview:_nextMonth aboveSubview:_currentMonth];
        } else if(_previousMonth) {
            [self insertSubview:_nextMonth aboveSubview:_previousMonth];
        } else {
            [self addSubview:_nextMonth];
        }
    }];
}


- (void) setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    self.tapGestureRecognizer = tapGestureRecognizer;
}


// Gesture recognizers
- (IBAction)tapDetected:(UITapGestureRecognizer *)sender {
    
    if([sender.view respondsToSelector:@selector(getDayModel)]){
        // If this view felt a day model
        FCVCalendarDayView * dayView = (FCVCalendarDayView*)sender.view;
        [self setSelectedDate:dayView.getDayModel.date];
        
    }
    
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
            if(delta_x > .5*self.bounds.size.width){
                float duration = ANIMATION_DURATION*(self.frame.size.width-delta_x)/self.frame.size.width;
                [self showPreviousMonthWithAnimation:YES withDuration:duration];
            } else {
                
                [self setFramePositionsWithAnimationDuration:ANIMATION_DURATION];
            }
            
        } else {
            
            // If swiped to next month for more than %30 of the screen
            if (delta_x < -.5*self.bounds.size.width){
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





@end
