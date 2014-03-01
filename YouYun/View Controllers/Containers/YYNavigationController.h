//
//  MLNavigationController.h
//  MusicLunatic
//
//  Created by Ranchao Zhang on 6/13/13.
//  Copyright (c) 2013 Ranchao Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYSwipeToPopViewController <NSObject>

- (BOOL)shouldAllowSwipeToPop;

@end

@interface YYNavigationController : UINavigationController <UIGestureRecognizerDelegate>

@end
