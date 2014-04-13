//
//  YYNewReminderView.h
//  YouYun
//
//  Created by Ranchao Zhang on 4/10/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYNewReminderView : UIView

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *dueDateLabel;
@property (nonatomic, weak) IBOutlet UITextField *messageInput;

@end
