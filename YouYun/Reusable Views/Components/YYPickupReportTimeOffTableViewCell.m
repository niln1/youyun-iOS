//
//  YYPickupReportTimeOffTableViewCell.m
//  YouYun
//
//  Created by Zhihao Ni on 11/26/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "YYPickupReportTimeOffTableViewCell.h"

@implementation YYPickupReportTimeOffTableViewCell

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
    self.studentImageView.layer.cornerRadius = self.studentImageView.frame.size.height /2;
    self.studentImageView.layer.masksToBounds = YES;
    self.studentImageView.layer.borderWidth = 1;
    self.studentImageView.layer.borderColor = SCHOOL_COLOR.CGColor;
    
    self.contentView.backgroundColor = BG_COLOR;
    self.fullNameLabel.textColor = SCHOOL_DARK_COLOR;
    self.pickupLocationLabel.textColor = SCHOOL_VERY_LIGHT_COLOR;
    
    self.timeOffButton.titleLabel.numberOfLines = 0;
    self.timeOffButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void) updateTimeOffButtonByVariable: (BOOL)isAbsent
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setLineSpacing: 5.0f];
    
    if (isAbsent) {
        self.timeOffButton.backgroundColor = SUCCESS_LIGHT_COLOR;
        self.timeOffButton.titleLabel.textColor = SUCCESS_COLOR;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"change to\n" attributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f],
            NSParagraphStyleAttributeName:style
        }]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Pick By School" attributes:@{
            NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue"  size:12.0f],
            NSParagraphStyleAttributeName:style
        }]];
        [self.timeOffButton setAttributedTitle:attString forState: UIControlStateNormal];
    } else {
        self.timeOffButton.backgroundColor = INFO_LIGHT_COLOR;
        self.timeOffButton.titleLabel.textColor = INFO_COLOR;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"change to\n" attributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f],
            NSParagraphStyleAttributeName:style
        }]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Pick By Me" attributes:@{
            NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue"  size:12.0f],
            NSParagraphStyleAttributeName:style
        }]];
        [self.timeOffButton setAttributedTitle:attString forState: UIControlStateNormal];
    }
}

@end
