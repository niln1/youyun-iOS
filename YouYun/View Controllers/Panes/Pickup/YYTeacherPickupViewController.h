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
#import <CRToast/CRToast.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "YYPickupReportTeacherNeedPickTableViewCell.h"
#import "YYPickupReportTeacherPickedTableViewCell.h"
#import "YYHTTPManager.h"
#import "NSDate+Addon.h"

@interface YYTeacherPickupViewController : UIViewController<SocketIODelegate>

@property (nonatomic, retain) SocketIO *socket;
@property (nonatomic, retain) NSString *reportID;
@property (nonatomic, retain) NSMutableArray *needPickArray;
@property (nonatomic, retain) NSMutableArray *pickedArray;

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;

@property (nonatomic, weak) IBOutlet UIView *topInfoView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic) NSInteger currentWeekDay;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, retain) UILabel *subtitleView;

@end