//
//  FCVEventDetailsCell.h
//  FancyCalendarView
//
//  Created by Peter Schuette on 2/22/16.
//  Copyright © 2016 Peter Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FCVEventDetailsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbl_eventTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbl_eventInfo;
@property (nonatomic, strong) IBOutlet UIView *view_base;


@end
