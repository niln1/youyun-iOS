//
//  YYTimelineViewController.h
//  YouYun
//
//  Created by Zhihao Ni on 3/21/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHTTPManager.h"
#import "YYUser.h"
#import "YYTimelineTableViewCell.h"

@interface YYTimelineViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *feeds;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, weak) IBOutlet UITableView *table;

@end
