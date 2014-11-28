//
//  YYPickupReportTimeOffTableViewCell.h
//  YouYun
//
//  Created by Zhihao Ni on 11/26/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYPickupReportTimeOffTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *studentImageView;
@property (nonatomic, weak) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupLocationLabel;
@property (nonatomic, weak) IBOutlet UIButton *timeOffButton;

-(void) updateTimeOffButtonByVariable: (BOOL)isAbsent;

@end
