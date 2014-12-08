//
//  YYAppDelegate.h
//  YouYun
//
//  Created by Zhihao Ni and Ranchao Zhang on 2/28/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

/*
 TURQUOISE
 GREEN SEA
 
 EMERALD
 NEPHRITIS
 
 PETER RIVER
 BELIZE HOLE
 
 AMETHYST
 WISTERIA
 
 WET ASPHALT
 MIDNIGHT BLUE
 
 SUN FLOWER
 ORANGE
 
 CARROT
 PUMPKIN
 
 ALIZARIN
 POMEGRANATE
 
 CLOUDS
 SILVER
 
 CONCRETE
 ASBESTOS
 */

#define UI_SELECTION_ALPHA 0.5

#define SCHOOL_DARK_COLOR [UIColor colorFromHexCode:@"#124720"]
#define SCHOOL_COLOR [UIColor colorFromHexCode:@"#3D714B"]
#define SCHOOL_VERY_LIGHT_COLOR [UIColor colorFromHexCode:@"#81a98b"]

#define INVERSE_DARK_COLOR [UIColor colorFromHexCode:@"#233B4D"]
#define INVERSE_LIGHT_COLOR [UIColor colorFromHexCode:@"#4F6577"]

//$info-color: #DB8700
//$info-light-color: #FFD898


#define SUCCESS_COLOR [UIColor colorFromHexCode:@"#008161"]
#define SUCCESS_LIGHT_COLOR [UIColor colorFromHexCode:@"#81D8C2"]

#define ERROR_COLOR [UIColor colorFromHexCode:@"#BD0E2D"]
#define ERROR_LIGHT_COLOR [UIColor colorFromHexCode:@"#F894A6"]

#define INFO_COLOR [UIColor colorFromHexCode:@"#DB8700"]
#define INFO_LIGHT_COLOR [UIColor colorFromHexCode:@"#FFD898"]

#define FG_COLOR [UIColor colorFromHexCode:@"#ffffff"]
#define BG_COLOR [UIColor colorFromHexCode:@"#ecf0f1"]

#define UI_CORNER_RADIUS 10.0f

#define UI_DEFAULT_CELL_ID @"UITableViewCell"
#define UI_TIMELINE_CELL_ID @"YYTimelineTableViewCell"
#define UI_PICKUP_PARENT_TIMESHEET_CELL_ID @"YYPickupReportTimeOffTableViewCell"
#define UI_PICKUP_TEACHER_NEED_PICK_CELL_ID @"YYPickupReportTeacherNeedPickTableViewCell"
#define UI_PICKUP_TEACHER_PICKED_CELL_ID @"YYPickupReportTeacherPickedTableViewCell"
/** depreciated **/
#define UI_PICKUP_PARENT_STUDENT_CELL_ID @"YYPickupReportParentStudentTableViewCell"
#define UI_PICKUP_PARENT_DETAIL_CELL_ID @"YYPickupReportParentDetailTableViewCell"
/** **/

/************************************************
 * Socket Events
 ************************************************/

static NSString * const CREATE_PICKUP_REPORT_EVENT = @"pickup::create";
static NSString * const FETCH_CHILD_PICKUP_REPORT_EVENT = @"pickup::parent::get-future-child-report";
static NSString * const FETCH_CHILD_PICKUP_REPORT_SUCCESS_EVENT = @"pickup::parent::get-future-child-report::success";
static NSString * const ADD_ABSENCE_TO_PICKUP_REPORT_EVENT = @"pickup::parent::add-absence";
static NSString * const ADD_ABSENCE_TO_PICKUP_REPORT_SUCCESS_EVENT = @"pickup::parent::add-absence::success";
static NSString * const GET_REPORT_FOR_TODAY_EVENT = @"pickup::teacher::get-report-for-today";
static NSString * const GET_REPORT_FOR_TODAY_SUCCESS_EVENT = @"pickup::teacher::get-report-for-today::success";
static NSString * const GET_REPORT_FOR_TODAY_FAIL_EVENT = @"pickup::teacher::get-report-for-today::fail";
static NSString * const PICKUP_STUDENT_EVENT = @"pickup::teacher::pickup-student";
static NSString * const PICKUP_STUDENT_SUCCESS_EVENT = @"pickup::teacher::pickup-student::success";
static NSString * const STUDENT_PICKED_UP_EVENT = @"pickup::all::picked-up::success";
static NSString * const FAILURE_EVENT = @"all::failure";

/************************************************
 * API
 ************************************************/

static NSString * const LOGIN_API_PATH = @"/api/v1/account/login";
static NSString * const LOGOUT_API_PATH = @"/api/v1/account/logout";
static NSString * const GET_ACCOUNT_API = @"/api/v1/account";
static NSString * const ADD_ACCOUNT_DEVICE = @"/api/v1/account/device";
static NSString * const GET_REMINDERS_API = @"/api/v1/reminders";
static NSString * const GET_FEEDS_API = @"/api/v1/feeds";
static NSString * const GET_CHILDREN_API = @"/api/v1/users/child";
static NSString * const CREATE_REMINDER_API = @"/api/v1/reminders";
static NSString * const UPDATE_REMINDER_API = @"/api/v1/reminders/%@";
static NSString * const DELETE_REMINDER_API = @"/api/v1/reminders/%@";

/************************************************
 * Notifications
 ************************************************/

static NSString * const REMINDERS_DID_CHANGE_NOTIFICATION = @"REMINDER_DID_CHANGE_NOTIFICATION";

/************************************************
 * Misc
 ************************************************/

static NSString * const FEED_TYPE_SCHOOL = @"school";
static NSString * const FEED_TYPE_PICKUP = @"pickup";
static NSString * const INFO_TYPE_INFO = @"info";
static NSString * const INFO_TYPE_SUCCESS = @"success";
static NSString * const INFO_TYPE_ERROR = @"error";
