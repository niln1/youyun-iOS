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
@property (nonatomic, retain) NSDictionary *report;

@property (nonatomic, weak) IBOutlet UITableView *table;

@end