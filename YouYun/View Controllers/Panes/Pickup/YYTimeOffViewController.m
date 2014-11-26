//
//  YYTimeOffViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 6/18/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYTimeOffViewController.h"

@interface YYTimeOffViewController ()

@end

@implementation YYTimeOffViewController

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

- (NSDictionary *)processPickupReport:(NSDictionary *) report
{
    NSString *reportID = report[@"_id"];
    NSString *reportDate = report[@"date"];
//    BOOL needToPickup = _.any(report[@"needToPickupList"], _.isEqual(childID));
    return @{@"_id": reportID};
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
            NSDictionary *allData = data[@"args"][0];
            _children = allData[@"children"];
            
            NSArray *reports = allData[@"reports"];
            
            NSMutableArray *timeSheet = [@[] mutableCopy];
            for (NSDictionary *report in reports) {
                [timeSheet addObject:[self processPickupReport:report]];
            }
//
//            _data = newData;
//            
//            [_table reloadData];
        }
        
//        else if ([messageName isEqualToString:ADD_ABSENCE_TO_PICKUP_REPORT_SUCCESS_EVENT]) {
//            NSDictionary *newData = [self processPickupReport:data[@"args"][0]];
//            
//            for (NSInteger i = 0; i < _data.count; i++) {
//                NSDictionary *oldData = _data[i];
//                if ([oldData[@"_id"] isEqualToString:newData[@"_id"]]) {
//                    _data[i] = newData;
//                    [_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    break;
//                }
//            }
//        } else if ([messageName isEqualToString:FAILURE_EVENT]) {
//            [_table reloadData];
//        }
    }
    @catch (NSException *exception) {
        OLog(exception);
    }
    @finally {
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UI_DEFAULT_CELL_ID forIndexPath:indexPath];
    NSDictionary *child = _children[indexPath.item];
    NSAssert(child[@"username"] != nil, @"Child should have a username");
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", child[@"firstname"], child[@"lastname"]];
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBgView.backgroundColor = INVERSE_LIGHT_COLOR;
    cell.selectedBackgroundView = selectedBgView;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _children.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYTimeOffDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:[YYTimeOffDetailViewController identifier]];
    detail.child = _children[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
