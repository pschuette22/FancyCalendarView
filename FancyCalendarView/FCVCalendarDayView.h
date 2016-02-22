//
//  FCVCalendarDayView.h
//  Fancy Calendar View
//
//  Created by Peter Schuette on 2/11/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCVDayModel.h"

@interface FCVCalendarDayView : UIView

@property (weak, nonatomic) IBOutlet UIView *view_base;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UIView *view_eventsIndicator;
@property (getter=isSelected) BOOL isSelected;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

//-(id) initWithFrame:(CGRect)frame withModel:(FCVDayModel*)dayModel;
- (void) setDayModel:(FCVDayModel *)dayModel ;
- (FCVDayModel *) getDayModel;
- (void) setSelected:(BOOL) isSelected;
- (BOOL) isDate: (NSDate*) date;
- (void) setEventsIndicator;

// Detect taps on days in the calendar
- (IBAction) tapDetected:(UITapGestureRecognizer*) sender;


@end
