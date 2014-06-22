//
//  YYTimeOffViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 6/18/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHTTPManager.h"

@interface YYTimeOffViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *children;

@end
