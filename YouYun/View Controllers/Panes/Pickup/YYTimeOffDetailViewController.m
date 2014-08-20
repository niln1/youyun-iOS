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
    
    // init a socket
    _socket = [[SocketIO alloc] initWithDelegate:self];
    // connect to server
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
    @try {
        NSDictionary *data = [packet dataAsJSON];
        NSString *messageName = data[@"name"];
        if ([messageName isEqualToString:FETCH_CHILD_PICKUP_REPORT_SUCCESS_EVENT]) {
            NSArray *allReports = data[@"args"][0];
            
            NSMutableArray *newData = [@[] mutableCopy];
            for (NSDictionary *report in allReports) {
                [newData addObject:[self processPickupReport:report]];
            }
            
            _data = newData;
            [self sortPickupReport];
            
            [_table reloadData];
        } else if ([messageName isEqualToString:ADD_ABSENCE_TO_PICKUP_REPORT_SUCCESS_EVENT]) {
            NSDictionary *newData = [self processPickupReport:data[@"args"][0]];
            
            for (NSInteger i = 0; i < _data.count; i++) {
                NSDictionary *oldData = _data[i];
                if ([oldData[@"_id"] isEqualToString:newData[@"_id"]]) {
                    _data[i] = newData;
                    [_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                }
            }
        } else if ([messageName isEqualToString:ADD_ABSENCE_TO_PICKUP_REPORT_FAILURE_EVENT]) {
            [_table reloadData];
        }
    }
    @catch (NSException *exception) {
        OLog(exception);
    }
    @finally {
    }
}

- (void)sortPickupReport
{
    _data = [[_data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [NSDate dateForJSTimeString:obj1[@"date"]];
        NSDate *date2 = [NSDate dateForJSTimeString:obj2[@"date"]];
        
        return [date1 compare:date2];
    }] mutableCopy];
}

- (NSDictionary *)processPickupReport:(NSDictionary *) report
{
    NSString *childID = _child[@"_id"];
    NSString *reportID = report[@"_id"];
    NSString *reportDate = report[@"date"];
    BOOL needToPickup = _.any(report[@"needToPickupList"], _.isEqual(childID));
    return @{@"_id": reportID,
             @"date": reportDate,
             @"needToPickup": @(needToPickup)};
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYPickupReportDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UI_PICKUP_DETAIL_CELL_ID forIndexPath:indexPath];
    
    @try {
        NSDictionary *reportInfo = _data[indexPath.row];
        cell.label.text = reportInfo[@"date"];
        [cell.toggle setOn:[reportInfo[@"needToPickup"] boolValue] animated:NO];
        [cell.toggle addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.toggle.tag = indexPath.row;
    }
    @catch (NSException *exception) {
        OLog(exception);
    }
    @finally {
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data ? _data.count : 0;
}

- (void)switchValueChanged:(UISwitch *) toggle
{
    NSInteger row = toggle.tag;
    BOOL needToPickup = toggle.on;
    NSDictionary *reportInfo = _data[row];
    [_socket sendEvent:ADD_ABSENCE_TO_PICKUP_REPORT_EVENT withData:@{
        @"reportID" : reportInfo[@"_id"],
        @"childID" : _child[@"_id"],
        @"needToPickup" : needToPickup ? @"true" : @"false"
    }];
}

@end
