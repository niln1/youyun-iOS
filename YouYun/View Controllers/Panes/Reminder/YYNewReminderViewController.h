//
//  YYNewReminderViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 4/13/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DateCellsController/DateCellsController.h>
#import "UIViewController+Addon.h"

@interface YYNewReminderViewController : UIViewController<DateCellsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, retain) DateCellsController *dateCellsController;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@end
