//
//  YYTimeOffDetailViewController.h
//  YouYun
//
//  Created by Ranchao Zhang on 6/21/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <socket.IO/SocketIO.h>
#import <socket.IO/SocketIOPacket.h>
#import "YYHTTPManager.h"

@interface YYTimeOffDetailViewController : UIViewController<SocketIODelegate>

@property (nonatomic, retain) SocketIO *socket;

@end
