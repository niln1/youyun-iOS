//
//  YYTimelineViewController.m
//  YouYun
//
//  Created by Zhihao Ni on 3/21/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "YYTimelineViewController.h"

@interface YYTimelineViewController ()

@end

@implementation YYTimelineViewController

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
    [self initialize];
    [self fetchFeeds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialize
{
    // UI setup
    self.view.backgroundColor = BG_COLOR;
    self.table.backgroundColor = BG_COLOR;
    
    [self.table setSeparatorColor:SCHOOL_COLOR];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = BG_COLOR;
    self.refreshControl.tintColor = INVERSE_LIGHT_COLOR;
    [self.refreshControl addTarget:self
                            action:@selector(fetchFeeds)
                  forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:self.refreshControl];
    
    self.navigationItem.title = @"HanLin";
    
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
        // if iOS 8
        self.table.rowHeight = UITableViewAutomaticDimension;
        self.table.estimatedRowHeight = 60.0;
    }
}

#pragma mark - API

- (void)fetchFeeds
{
    NSDictionary *parameter = @{@"signature" : @"tempkey",
                                @"userId": [YYUser I].userID};
    [[YYHTTPManager I] GET:GET_FEEDS_API withURLEncodedParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        OLog(responseObject);
        [self.refreshControl endRefreshing];
        _feeds = [responseObject[@"result"] mutableCopy];
        if ([_feeds count] == 0) {
            [self.view bringSubviewToFront:_infoLabel];
        } else {
            [self.view sendSubviewToBack:_infoLabel];
            [_table reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        OLog(@"failure");
        [self.refreshControl endRefreshing];
        [self.view bringSubviewToFront:_infoLabel];
        OLog(error);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTimelineTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:UI_TIMELINE_CELL_ID];
    @try {
        NSDictionary *info = _feeds[indexPath.row];
        cell.feedMessageLabel.text = info[@"message"];
        [cell setImageByType:info[@"type"] InfoType:info[@"infoType"]];
        [cell setTimeLabel:info[@"timeStamp"]];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    @catch (NSException *exception) {
        OLog(exception);
    }
    @finally {
    }
    return cell;
}

#pragma mark - UITableViewCell

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
