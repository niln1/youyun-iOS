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

#define SCHOOL_COLOR_HEX @"#3D714B"
#define SCHOOL_LIGHT_COLOR_HEX @"#16a085"
#define SCHOOL_BASE_COLOR_HEX @"#D6E6DB"

#define UI_SELECTION_ALPHA 0.5
#define UI_FG_COLOR [UIColor colorFromHexCode:SCHOOL_BASE_COLOR_HEX]
#define UI_BG_COLOR [UIColor colorFromHexCode:SCHOOL_COLOR_HEX]
#define UI_SHADOW_COLOR [UIColor colorFromHexCode:SCHOOL_LIGHT_COLOR_HEX]
#define UI_SELECTION_COLOR [UI_SHADOW_COLOR colorWithAlphaComponent:UI_SELECTION_ALPHA]

#define UI_CORNER_RADIUS 10.0f

#define UI_DEFAULT_CELL_ID @"UITableViewCell"
#define UI_PICKUP_DETAIL_CELL_ID @"YYPickupReportDetailTableViewCell"
#define UI_PICKUP_TEACHER_CELL_ID @"YYPickupReportTeacherTableViewCell"

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
static NSString * const GET_REMINDERS_API = @"/api/v1/reminders";
static NSString * const GET_CHILDREN_API = @"/api/v1/users/child";
static NSString * const CREATE_REMINDER_API = @"/api/v1/reminders";
static NSString * const UPDATE_REMINDER_API = @"/api/v1/reminders/%@";
static NSString * const DELETE_REMINDER_API = @"/api/v1/reminders/%@";

/************************************************
 * Notifications
 ************************************************/

static NSString * const REMINDERS_DID_CHANGE_NOTIFICATION = @"REMINDER_DID_CHANGE_NOTIFICATION";
