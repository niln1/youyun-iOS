//
//  YYNewReminderView.m
//  YouYun
//
//  Created by Ranchao Zhang on 4/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYNewReminderView.h"

@implementation YYNewReminderView

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"YYNewReminderView" owner:self options:nil];
        self = views[0];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
