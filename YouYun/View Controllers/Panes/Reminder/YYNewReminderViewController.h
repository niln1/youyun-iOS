//
//  YYNewReminderViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 4/13/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DateCellsController/DateCellsController.h>
#import <FAKIonIcons.h>
#import "YYMessage.h"
#import "UIViewController+Addon.h"
#import "YYTextFieldTableViewCell.h"
#import "YYHTTPManager.h"

@interface YYNewReminderViewController : UIViewController<DateCellsControllerDelegate, UINavigationBarDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, retain) DateCellsController *dateCellsController;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateFormatter *jsDateFormatter;

@end
