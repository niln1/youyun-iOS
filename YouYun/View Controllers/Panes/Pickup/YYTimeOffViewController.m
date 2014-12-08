//
//  YYTimeOffViewController.m
//  YouYun
//
//  Created by Zhihao Ni & Ranchao Zhang on 6/18/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "YYTimeOffViewController.h"

// View Based constant
static NSString * const STUDENT_IS_ABSENT= @"isAbsent";

@interface YYTimeOffViewController ()

@end

@implementation YYTimeOffViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    
    // init a socket
    _socket = [[SocketIO alloc] initWithDelegate:self];
    // connect to server
    [_socket connectToHost:[YYHTTPManager I].serverHost onPort:[[YYHTTPManager I].serverPort integerValue]];
    
    _children = @[];
}

- (void)initialize
{
    // Nav UI setup
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 160, 44);
    UIView* headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0, 6, 160, 20);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:17];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = FG_COLOR;
    titleView.text = @"Pickup Timesheet";
    titleView.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 22, 160, 44-20);
    _subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    _subtitleView.backgroundColor = [UIColor clearColor];
    _subtitleView.font = [UIFont systemFontOfSize:10];
    _subtitleView.textAlignment = NSTextAlignmentCenter;
    _subtitleView.textColor = INFO_LIGHT_COLOR;
    _subtitleView.text = @"Connecting...";
    _subtitleView.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:_subtitleView];
    
    self.navigationItem.titleView = headerTitleSubtitleView;
    
    // refresh control

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = BG_COLOR;
    self.refreshControl.tintColor = INVERSE_LIGHT_COLOR;
    [self.refreshControl addTarget:self
                            action:@selector(getChildFutureReport)
                  forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:self.refreshControl];
    
    self.view.backgroundColor = BG_COLOR;
    self.table.backgroundColor = BG_COLOR;
    [self.table setSeparatorColor:SCHOOL_COLOR];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getChildFutureReport
{
    [_socket sendEvent:FETCH_CHILD_PICKUP_REPORT_EVENT withData:@{}];
}

- (void)updateTableView
{
    [_table reloadData];
}


// process report to { _id:xxx,  date: xxx, data : [{name: location: userImage: absence:}] }
- (NSDictionary *)processPickupReport:(NSDictionary *) report
{
    NSMutableArray *data = [@[] mutableCopy];
    
    _.array(_children).each(^(NSString *childID){
        _.array(report[@"needToPickupList"]).each(^(NSDictionary *student) {
            if (student[@"_id"] == childID) {
                [data addObject:@{
                    @"_id": student[@"_id"],
                    @"fullname": student[@"fullname"],
                    @"pickupLocation": student[@"pickupLocation"],
                    @"userImage": student[@"userImage"],
                    STUDENT_IS_ABSENT: @NO
                }];
            }
        });
        
        _.array(report[@"absenceList"]).each(^(NSDictionary *student) {
            if (student[@"_id"] == childID) {
                [data addObject:@{
                      @"_id": student[@"_id"],
                      @"fullname": student[@"fullname"],
                      @"pickupLocation": student[@"pickupLocation"],
                      @"userImage": student[@"userImage"],
                      STUDENT_IS_ABSENT: @YES
                }];
            }
        });
    });

    return @{
             @"_id": report[@"_id"],
             @"date": report[@"date"],
             @"data": data
    };
}

#pragma subtitle

- (void) showErrorMessage: (NSString *)message {
    _subtitleView.text = message;
    _subtitleView.textColor = ERROR_LIGHT_COLOR;
}

- (void) showSuccessMessage: (NSString *)message {
    _subtitleView.text = message;
    _subtitleView.textColor = SUCCESS_LIGHT_COLOR;
}

- (void) showInfoMessage: (NSString *)message {
    _subtitleView.text = message;
    _subtitleView.textColor = INFO_LIGHT_COLOR;
}

#pragma mark - SocketIODelegate
// TODO: make this more generic
- (void) socketIODidConnect:(SocketIO *)socket {
    OLog(@"Connected");
    [self showSuccessMessage:@"Connected"];
    [self getChildFutureReport];
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    OLog(@"Disconnected");
    [self showErrorMessage:@"Disconnected"];
    [self performSelector:@selector(reconnectSocket) withObject:nil afterDelay:10.0];
    
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    [self showErrorMessage:@"Disconnected"];
    [self performSelector:@selector(reconnectSocket) withObject:nil afterDelay:10.0];
}

- (void) connectSocket {
    [self showInfoMessage:@"Connecting..."];
    [_socket connectToHost:[YYHTTPManager I].serverHost onPort:[[YYHTTPManager I].serverPort integerValue]];
}

- (void) reconnectSocket {
    [_socket disconnect];
    [self connectSocket];
}

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
            [self.refreshControl endRefreshing];
            NSDictionary *allData = data[@"args"][0];
            _children = allData[@"children"];
            
            NSArray *reports = allData[@"reports"];
            
            NSMutableArray *timeSheet = [@[] mutableCopy];
            for (NSDictionary *report in reports) {
                [timeSheet addObject:[self processPickupReport:report]];
            }
            
            _tableDataSource = timeSheet;
            
            if ([_tableDataSource count] == 0) {
                [self.view bringSubviewToFront:_infoLabel];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Future TimeSheet" message:@"There is report setup right now, try Pull to Refresh or check later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                [self.view sendSubviewToBack:_infoLabel];
                [_table reloadData];
            }
        }
        
        else if ([messageName isEqualToString:ADD_ABSENCE_TO_PICKUP_REPORT_SUCCESS_EVENT]) {
            // update to a better way
            [self getChildFutureReport];
        } else if ([messageName isEqualToString:FAILURE_EVENT]) {
            [self.refreshControl endRefreshing];
            [self.view bringSubviewToFront:_infoLabel];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Future TimeSheet" message:@"There is report setup right now, try Pull to Refresh or check later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [_table reloadData];
        }
    }
    @catch (NSException *exception) {
        OLog(exception);
    }
    @finally {
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYPickupReportTimeOffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UI_PICKUP_PARENT_TIMESHEET_CELL_ID forIndexPath:indexPath];
    NSDictionary *child = _tableDataSource[indexPath.section][@"data"][indexPath.row];
    NSAssert(child[@"fullname"] != nil, @"Child should have a name");
    cell.fullNameLabel.text = child[@"fullname"];
    cell.pickupLocationLabel.text = child[@"pickupLocation"];
    [cell updateTimeOffButtonByVariable:[child[STUDENT_IS_ABSENT] boolValue]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        return [(NSArray *)_tableDataSource[section][@"data"] count];
    }
    @catch (NSException *exception) {
        OLog(exception);
        return 0;
    }
    @finally {
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake (10,4,tableView.bounds.size.width-10,16)];
    headerView.backgroundColor = SCHOOL_VERY_LIGHT_COLOR;
    labelHeader.textColor = FG_COLOR;
    labelHeader.font = [labelHeader.font fontWithSize:13];
    NSDate *date = [NSDate dateForJSTimeString:_tableDataSource[section][@"date"]];
    labelHeader.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    [headerView addSubview:labelHeader];
    
    return headerView;
}

#pragma mark - CellButtonDelegate
- (IBAction)onButtonClick:(id)sender
{
    NSIndexPath *indexPath = [self GetIndexPathFromSender:sender];
    
    NSLog(@"%ld %ld", (long)indexPath.section, (long)indexPath.row);
    
    NSDictionary *child = _tableDataSource[indexPath.section][@"data"][indexPath.row];
    [_socket sendEvent:ADD_ABSENCE_TO_PICKUP_REPORT_EVENT withData:@{
                                                                     @"reportID" : _tableDataSource[indexPath.section][@"_id"],
                                                                     @"childID" : child[@"_id"],
                                                                     @"needToPickup" : [child[STUDENT_IS_ABSENT] boolValue] ? @"true" : @"false"
                                                                     }];
}

-(NSIndexPath*)GetIndexPathFromSender:(id)sender{
    
    if(!sender) { return nil; }
    
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = sender;
        return [self.table indexPathForCell:cell];
    }
    
    return [self GetIndexPathFromSender:((UIView*)[sender superview])];
}

//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    YYTimeOffDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:[YYTimeOffDetailViewController identifier]];
//    detail.child = _children[indexPath.row];
//    [self.navigationController pushViewController:detail animated:YES];
//}

@end
