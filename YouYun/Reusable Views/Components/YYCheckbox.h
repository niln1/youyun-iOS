//
//  YYCheckbox.h
//  YouYun
//
//  Created by Ranchao Zhang on 4/15/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface YYCheckbox : UIView

typedef NS_ENUM(NSInteger, YYCheckboxState) {
    YYCheckboxStateUnchecked,
    YYCheckboxStateChecked,
    YYCheckboxStateDisabled
};

@property (nonatomic, copy) void (^onTap)(BOOL checked);
@property (nonatomic) BOOL checked;
@property (nonatomic) BOOL enabled;
@property (nonatomic, retain) FAKIonIcons *icon;
@property (nonatomic, retain) FAKIonIcons *checkedIcon;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *checkedColor;
@property (nonatomic, retain) UIColor *disabledColor;
@property (nonatomic, retain) UIImageView *iconImageView;

- (id)initWithWidth:(CGFloat) width;
- (void)setState:(YYCheckboxState) state;

@end
