//
//  YYCheckbox.m
//  YouYun
//
//  Created by Ranchao Zhang on 3/29/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYCheckboxButton.h"

@implementation YYCheckboxButton

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTintColor:[UIColor clearColor]];
    [self addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _fontSizeDifference = 5.0f;
    [self setColor:[UIColor blackColor]];
    [self setSelectedColor:[UIColor blackColor]];
    [self setDisabledColor:[UIColor darkGrayColor]];
}

- (void)dealloc
{
    [self removeTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)checkboxClicked:(id)sender
{
    [self setSelected:!self.selected];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    CGFloat diameter = MIN(self.frame.size.width, self.frame.size.height) - _fontSizeDifference;
    FAKIonIcons *icon = [FAKIonIcons ios7CircleOutlineIconWithSize:diameter];
    [icon addAttribute:NSForegroundColorAttributeName value:color];
    [self setBackgroundImage:[icon imageWithSize:self.frame.size] forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    CGFloat diameter = MIN(self.frame.size.width, self.frame.size.height) - _fontSizeDifference;
    FAKIonIcons *icon = [FAKIonIcons ios7CircleFilledIconWithSize:diameter];
    [icon addAttribute:NSForegroundColorAttributeName value:selectedColor];
    [self setBackgroundImage:[icon imageWithSize:self.frame.size] forState:UIControlStateSelected];
}

- (void)setDisabledColor:(UIColor *)disabledColor
{
    _disabledColor = disabledColor;
    CGFloat diameter = MIN(self.frame.size.width, self.frame.size.height) - _fontSizeDifference;
    FAKIonIcons *icon;
    if (self.isSelected) {
        icon = [FAKIonIcons ios7CircleFilledIconWithSize:diameter];
    } else {
        icon = [FAKIonIcons ios7CircleOutlineIconWithSize:diameter];
    }
    [icon addAttribute:NSForegroundColorAttributeName value:disabledColor];
    [self setBackgroundImage:[icon imageWithSize:self.frame.size] forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setDisabledColor:_disabledColor];
}

@end
