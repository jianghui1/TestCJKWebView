//
//  CJLayoutHelper.h
//  CJWebBrowserDemo
//
//  Created by Jie Cao on 9/26/15.
//  Copyright © 2015 JieCao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CJLayoutHelper : NSObject
+ (NSLayoutConstraint *)addHeightConstraintForView: (UIView *)view height:(CGFloat)height;
+(void) addInsetSpacingConstraintsWithinnerView: (UIView *)innerView outerView: (UIView *)outerView insets: (UIEdgeInsets)insets;

+(void) addVerticalSpacningConstrainsWithInnerView: (UIView *)innerView outerView:(UIView *)outerView topSpacing:(CGFloat)topSpacing bottomSpacing:(CGFloat)bottomSpacing;

+(void) addHorizontalSpacningConstrainsWithInnerView: (UIView *)innerView outerView:(UIView *)outerView leadingSpacing:(CGFloat)leadingSpacing trailingSpacing:(CGFloat)trailingSpacing;
@end
