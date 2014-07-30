//
//  YYTimeOffDetailViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 6/21/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYTimeOffDetailViewController.h"

@interface YYTimeOffDetailViewController ()

@end

@implementation YYTimeOffDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _socket = [[SocketIO alloc] initWithDelegate:self];
    [_socket connectToHost:[YYHTTPManager I].serverHost onPort:[[YYHTTPManager I].serverPort integerValue]];
    
    OLog(_child);
}

- (void)viewDidAppear:(BOOL)animated
{
    [_socket sendEvent:FETCH_CHILD_PICKUP_REPORT_EVENT withData:@{@"childId" : _child[@"_id"]}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SocketIODelegate

// message delegate
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage >>> data: %@", [packet dataAsJSON]);
}

// event delegate
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent >>> data: %@", [packet dataAsJSON]);
}

@end
