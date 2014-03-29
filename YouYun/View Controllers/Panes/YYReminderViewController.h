//
//  YYReminderViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 3/21/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHTTPManager.h"
#import "YYReminderTableViewCell.h"

@interface YYReminderViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *reminders;

@end
