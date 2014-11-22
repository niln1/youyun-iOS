//
//  YYTimelineTableViewCell.m
//  YouYun
//
//  Created by Zhihao Ni on 11/20/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "YYTimelineTableViewCell.h"

@implementation YYTimelineTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setupUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI
{
    self.contentView.backgroundColor = BG_COLOR;
    self.feedMessageLabel.textColor = SCHOOL_DARK_COLOR;
    self.timeStampLabel.textColor = SCHOOL_VERY_LIGHT_COLOR;
}

- (void)setImageByType:(NSString *)type InfoType:(NSString *)infoType {
    FAKFontAwesome *imageIcon;
    UIColor *imageColor;
    
    if ([type isEqualToString:FEED_TYPE_SCHOOL]) {
        imageIcon = [FAKFontAwesome graduationCapIconWithSize:20];
    } else if ([type isEqualToString:FEED_TYPE_PICKUP]) {
        imageIcon = [FAKFontAwesome busIconWithSize:20];
    } else {
        imageIcon = [FAKFontAwesome infoIconWithSize:20];
    }
    
    if ([infoType isEqualToString:INFO_TYPE_ERROR]) {
        imageColor = ERROR_LIGHT_COLOR;
    } else if ([infoType isEqualToString:INFO_TYPE_SUCCESS]) {
        imageColor = SUCCESS_LIGHT_COLOR;
    } else {
        imageColor = INFO_LIGHT_COLOR;
    }
    [imageIcon addAttribute:NSForegroundColorAttributeName value:imageColor];
    _feedTypeLabel.textAlignment = NSTextAlignmentCenter;
    _feedTypeLabel.attributedText = [imageIcon attributedString];
}

- (void)setTimeLabel:(NSString *)timeString {
    NSDate *date = [NSDate dateForJSTimeString:timeString];
    _timeStampLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];;
}

@end
