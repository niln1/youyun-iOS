//
//  YYTimelineTableViewCell.h
//  YouYun
//
//  Created by Zhihao Ni on 11/20/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FAKFontAwesome.h>
#import "NSDate+Addon.h"

@interface YYTimelineTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *feedMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel *feedTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeStampLabel;

- (void)setImageByType:(NSString *)type InfoType:(NSString *)infoType;
- (void)setTimeLabel:(NSString *)timeString;

@end
