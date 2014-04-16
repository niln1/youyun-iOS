//
//  YYReminderTableViewCell.h
//  YouYun
//
//  Created by Ranchao Zhang on 3/29/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MarqueeLabel/MarqueeLabel.h>
#import "YYCheckbox.h"

@interface YYReminderTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet YYCheckbox *checkbox;
@property (nonatomic, weak) IBOutlet MarqueeLabel *title;
@property (nonatomic, weak) IBOutlet MarqueeLabel *subtitle;

@end
