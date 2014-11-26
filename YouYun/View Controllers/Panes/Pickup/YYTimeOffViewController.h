//
//  YYTimeOffViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 6/18/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <socket.IO/SocketIO.h>
#import <socket.IO/SocketIOPacket.h>
#import "YYHTTPManager.h"
#import "YYTimeOffDetailViewController.h"

@interface YYTimeOffViewController : UIViewController <SocketIODelegate>

@property (nonatomic, retain) SocketIO *socket;

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *children;

@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) UILabel *subtitleView;

@end
