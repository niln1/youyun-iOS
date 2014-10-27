//
//  YYTeacherPickupViewController.h
//  YouYun
//
//  Created by Zhihao Ni on 7/31/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <socket.IO/SocketIO.h>
#import <socket.IO/SocketIOPacket.h>
#import "YYPickupReportTeacherTableViewCell.h"
#import "YYHTTPManager.h"
#import "NSDate+Addon.h"

@interface YYTeacherPickupViewController : UIViewController<SocketIODelegate>

@property (nonatomic, retain) SocketIO *socket;
@property (nonatomic, retain) NSString *reportID;
@property (nonatomic, retain) NSMutableArray *students;

@property (nonatomic, weak) IBOutlet UITableView *table;

@property (nonatomic) NSInteger currentWeekDay;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

@end