//
//  FCVCalendarView.h
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/17/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class FCVCalendarView, FCVCalendarMonthView, FCVCalendarDayView, FCVDayModel, UISwipeGestureRecognizer, UIPanGestureRecognizer, UITapGestureRecognizer;

@protocol FCVCalendarViewDelegate <NSObject>

@optional
- (void) frameDidChange:(CGRect) frame;
- (void) selectedDateDayChange: (NSDate *)day;
- (void) eventsDidChange:(NSMutableArray *)events;


@end

@interface FCVCalendarView : UIView


@property (nonatomic,getter=getSize) CGSize contentSize;
@property (nonatomic, weak, setter=setDelegate:) id<FCVCalendarViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;

@property (strong, nonatomic) FCVCalendarMonthView *previousMonth;
@property (strong, nonatomic) FCVCalendarMonthView *currentMonth;
@property (strong, nonatomic) FCVCalendarMonthView *nextMonth;
@property (strong, nonatomic) FCVCalendarDayView *selectedDayView;;


// Gesture recognizers
- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender;
- (IBAction)panDetected:(UIPanGestureRecognizer *)sender;


// Class Methods
- (void) initGestures;
- (void) setSelectedDate: (NSDate*) date withAnimationDuration: (float) duration;
- (FCVDayModel*) getSelectedDayModel;
- (void) showNextMonthWithAnimation:(BOOL) doAnimate withDuration:(float) duration;
- (void) showPreviousMonthWithAnimation:(BOOL) doAnimate withDuration:(float) duration;
- (void) didReceiveNotification:(NSNotification*) notification;
- (CGSize) getContentSize;
- (NSDate*) getSelectedDate;

@end
