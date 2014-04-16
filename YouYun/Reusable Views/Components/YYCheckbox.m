//
//  YYCheckbox.m
//  YouYun
//
//  Created by Ranchao Zhang on 4/15/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYCheckbox.h"

@implementation YYCheckbox

- (id)init
{
    return [self initWithWidth:44];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithWidth:(CGFloat) width
{
    self = [super initWithFrame:CGRectMake(0, 0, width, width)];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    CGFloat width = self.frame.size.width;
    
    _checked = NO;
    _enabled = YES;
    _icon = [FAKIonIcons ios7CircleOutlineIconWithSize:width - 10];
//    _checkedIcon = [FAKIonIcons ios7CircleFilledIconWithSize:width - 10];
    _checkedIcon = [FAKIonIcons ios7CheckmarkIconWithSize:width - 10];
    _color = UI_BG_COLOR;
    _checkedColor = UI_BG_COLOR;
    _disabledColor = [UIColor silverColor];
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    _iconImageView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:_iconImageView];
    
    [self setChecked:_checked andEnabled:_enabled];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkboxTapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)checkboxTapped:(UITapGestureRecognizer *) tapGestureRecognizer
{
    if (_enabled && tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setChecked:!_checked];
        if (_onTap) {
            _onTap(_checked);
        }
    }
}

- (void)setChecked:(BOOL) checked
{
    [self setChecked:checked andEnabled:_enabled];
}

- (void)setEnabled:(BOOL)enabled
{
    [self setChecked:_checked andEnabled:enabled];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setChecked:_checked andEnabled:_enabled];
}

- (void)setCheckedColor:(UIColor *)checkedColor
{
    _checkedColor = checkedColor;
    [self setChecked:_checked andEnabled:_enabled];
}

- (void)setDisabledColor:(UIColor *)disabledColor
{
    _disabledColor = disabledColor;
    [self setChecked:_checked andEnabled:_enabled];
}

- (void)setChecked:(BOOL) checked andEnabled:(BOOL) enabled
{
    _checked = checked;
    _enabled = enabled;
    FAKIonIcons *icon = checked ? _checkedIcon : _icon;
    UIColor *color = enabled ? (checked ? _checkedColor : _color) : _disabledColor;
    [icon addAttribute:NSForegroundColorAttributeName value:color];
    _iconImageView.image = [icon imageWithSize:self.frame.size];
}

- (void)setState:(YYCheckboxState) state;
{
    FAKIonIcons *icon;
    switch (state) {
        case YYCheckboxStateUnchecked:
            icon = _icon;
            break;
        case YYCheckboxStateChecked:
            break;
        case YYCheckboxStateDisabled:
            break;
    }
}

@end
