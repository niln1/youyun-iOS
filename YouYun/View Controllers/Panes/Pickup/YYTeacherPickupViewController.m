//
//  YYTeacherPickupViewController.m
//  YouYun
//
//  Created by Zhihao Ni on 7/31/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYTeacherPickupViewController.h"

@interface YYTeacherPickupViewController ()

@end

@implementation YYTeacherPickupViewController

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
    // UI setup
    self.view.backgroundColor = BG_COLOR;
    self.table.backgroundColor = BG_COLOR;
    self.segmentControl.tintColor = FG_COLOR;
    [self.segmentControl addTarget:self
                            action:@selector(updateTableView)
                            forControlEvents:UIControlEventValueChanged];
    self.topInfoView.backgroundColor = SCHOOL_COLOR;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = BG_COLOR;
    self.refreshControl.tintColor = INVERSE_LIGHT_COLOR;
    [self.refreshControl addTarget:self
                            action:@selector(getReportForToday)
                            forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:self.refreshControl];
    
    [self.table setSeparatorColor:SCHOOL_COLOR];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    // get day of week
    [self updateDayOfWeek];
    
    // init a socket
    _socket = [[SocketIO alloc] initWithDelegate:self];
    // connect to server
    [_socket connectToHost:[YYHTTPManager I].serverHost onPort:[[YYHTTPManager I].serverPort integerValue]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getReportForToday];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getReportForToday
{
    [_socket sendEvent:GET_REPORT_FOR_TODAY_EVENT withData:@{}];
}

- (void)updateTableView
{
    [_table reloadData];
}

- (void)updateDayOfWeek
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    self.currentWeekDay = [comps weekday];
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
        [self updateDayOfWeek];
        
        NSDictionary *data = [packet dataAsJSON];
        NSString *messageName = data[@"name"];
        if ([messageName isEqualToString:GET_REPORT_FOR_TODAY_SUCCESS_EVENT]) {
            [self.refreshControl endRefreshing];
            NSDictionary *report = data[@"args"][0];
            
            if (![report isKindOfClass:[NSNull class]]) {
                NSMutableArray *needPickArray = [@[] mutableCopy];
                NSMutableArray *pickedArray = [@[] mutableCopy];
                for (NSDictionary *studentInfo in report[@"needToPickupList"]) {
                    NSMutableDictionary *mutableInfo = [studentInfo mutableCopy];
                    mutableInfo[@"pickedUp"] = @(NO);
                    [needPickArray addObject:mutableInfo];
                }
                for (NSDictionary *studentInfo in report[@"pickedUpList"]) {
                    NSMutableDictionary *mutableInfo = [studentInfo mutableCopy];
                    mutableInfo[@"pickedUp"] = @(YES);
                    [pickedArray addObject:mutableInfo];
                }
                
                _reportID = report[@"_id"];
                _needPickArray = needPickArray;
                _pickedArray = pickedArray;
                [self sortPickupReport];
                
                _table.alpha = 1;
                [_table reloadData];
            } else {
                _table.alpha = 0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Report" message:@"There is no report for today" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }  else if ([messageName isEqualToString:PICKUP_STUDENT_SUCCESS_EVENT] || [messageName isEqualToString:STUDENT_PICKED_UP_EVENT]) {
            [_socket sendEvent:GET_REPORT_FOR_TODAY_EVENT withData:@{}];
            
        } else if ([messageName isEqualToString:FAILURE_EVENT]) {
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
    // TODO: sort by Location then time then name
    [_needPickArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *fullname1 = [NSString stringWithFormat:@"%@ %@ %@", obj1[@"firstname"], obj1[@"lastname"], obj1[@"_id"]];
        NSString *fullname2 = [NSString stringWithFormat:@"%@ %@ %@", obj2[@"firstname"], obj2[@"lastname"], obj2[@"_id"]];
        
        return [fullname1 compare:fullname2];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        YYPickupReportTeacherNeedPickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UI_PICKUP_TEACHER_NEED_PICK_CELL_ID forIndexPath:indexPath];
        @try {
            NSDictionary *studentInfo = _needPickArray[indexPath.row];
            cell.studentNameLabel.text = [NSString stringWithFormat:@"%@ %@", studentInfo[@"firstname"], studentInfo[@"lastname"]];
            cell.pickupLocationLabel.text = studentInfo[@"pickupLocation"];
            
            NSString *dateSelector;
            
            switch (self.currentWeekDay) {
                case 1:
                    dateSelector = @"sundayPickupTime";
                    break;
                case 2:
                    dateSelector = @"mondayPickupTime";
                    break;
                case 3:
                    dateSelector = @"tuesdayPickupTime";
                    break;
                case 4:
                    dateSelector = @"wednesdayPickupTime";
                    break;
                case 5:
                    dateSelector = @"thursdayPickupTime";
                    break;
                case 6:
                    dateSelector = @"fridayPickupTime";
                    break;
                case 7:
                    dateSelector = @"saturdayPickupTime";
                    break;
                default:
                    break;
            }
            
            if (dateSelector) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"HH:mm";
                NSDate *date = [dateFormatter dateFromString:studentInfo[@"studentPickupDetail"][dateSelector]];
                
                dateFormatter.dateFormat = @"h:mm a";
                NSString *pmamDateString = [dateFormatter stringFromDate:date];
                cell.pickedUpTimeLabel.text = pmamDateString;
            }
            
            cell.pickedUpSwitch.on = [studentInfo[@"pickedUp"] boolValue];
            
            cell.pickedUpSwitch.tag = indexPath.row;
            [cell.pickedUpSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
        }
        @catch (NSException *exception) {
            OLog(exception);
        }
        @finally {
        }
        
        return cell;
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        YYPickupReportTeacherNeedPickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UI_PICKUP_TEACHER_NEED_PICK_CELL_ID forIndexPath:indexPath];
        @try {
            NSDictionary *studentInfo = _pickedArray[indexPath.row];
            cell.studentNameLabel.text = [NSString stringWithFormat:@"%@ %@", studentInfo[@"firstname"], studentInfo[@"lastname"]];
            cell.pickupLocationLabel.text = studentInfo[@"pickupLocation"];
            
            cell.pickedUpSwitch.on = [studentInfo[@"pickedUp"] boolValue];
            
            cell.pickedUpSwitch.tag = indexPath.row;
            [cell.pickedUpSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
        }
        @catch (NSException *exception) {
            OLog(exception);
        }
        @finally {
        }
        
        return cell;

    } else {
        OLog(@"FATAL: Render A cell not in segment control");
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentControl.selectedSegmentIndex == 0) {
        return _needPickArray ? _needPickArray.count : 0;
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        return _pickedArray ?_pickedArray.count : 0;
    } else {
        return 0;
    }
}

- (void)switchClicked:(UISwitch *) aSwitch
{
    NSDictionary *studentInfo = _needPickArray[aSwitch.tag];
    [_socket sendEvent:PICKUP_STUDENT_EVENT withData:@{@"reportID" : _reportID, @"studentID" : studentInfo[@"_id"], @"pickedUp" : aSwitch.on ? @"true" : @"false"}];
}

@end
