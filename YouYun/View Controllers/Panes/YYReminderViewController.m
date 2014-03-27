//
//  YYReminderViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/21/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYReminderViewController.h"

static NSString * const GET_REMINDERS_API = @"/api/v1/reminders";
static NSString * const REMINDER_TABLE_VIEW_CELL_ID = @"REMINDER_TABLE_VIEW_CELL_ID";

@interface YYReminderViewController ()

@end

@implementation YYReminderViewController

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
    
    [self fetchReminders];
}

- (void)fetchReminders
{
    NSDictionary *parameter = @{@"signature" : @"tempkey"};
    [[YYHTTPManager I] GET:GET_REMINDERS_API parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        _reminders = responseObject[@"result"];
        [_table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        OLog(@"failure");
        OLog(error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:REMINDER_TABLE_VIEW_CELL_ID];
    NSDictionary *info = _reminders[indexPath.row];
    cell.textLabel.text = info[@"message"];
    return cell;
}

@end
