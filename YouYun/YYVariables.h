//
//  YYAppDelegate.h
//  YouYun
//
//  Created by Ranchao Zhang on 2/28/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
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
#define UI_FG_COLOR [UIColor whiteColor]
#define UI_BG_COLOR [UIColor turquoiseColor]
#define UI_SHADOW_COLOR [UIColor nephritisColor]
#define UI_SELECTION_COLOR [UI_SHADOW_COLOR colorWithAlphaComponent:UI_SELECTION_ALPHA]

#define UI_CORNER_RADIUS 10.0f

#define UI_DEFAULT_CELL_ID @"UITableViewCell"
#define UI_PICKUP_DETAIL_CELL_ID @"YYPickupReportDetailTableViewCell"

/************************************************
 * Socket Events
 ************************************************/

static NSString * const CREATE_PICKUP_REPORT_EVENT = @"pickup::create";
static NSString * const FETCH_CHILD_PICKUP_REPORT_EVENT = @"pickup::parent::get-child-report";
static NSString * const FETCH_CHILD_PICKUP_REPORT_SUCCESS_EVENT = @"pickup::parent::get-child-report::success";
static NSString * const ADD_ABSENCE_TO_PICKUP_REPORT_EVENT = @"pickup::parent::add-absence";
static NSString * const ADD_ABSENCE_TO_PICKUP_REPORT_SUCCESS_EVENT = @"pickup::parent::add-absence::success";
static NSString * const ADD_ABSENCE_TO_PICKUP_REPORT_FAILURE_EVENT = @"pickup::parent::add-absence::failure";

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
