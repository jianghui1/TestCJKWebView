//
//  CJLayoutHelper.m
//  CJWebBrowserDemo
//
//  Created by Jie Cao on 9/26/15.
//  Copyright © 2015 JieCao. All rights reserved.
//

#import "CJLayoutHelper.h"

@implementation CJLayoutHelper
+ (NSLayoutConstraint *)addHeightConstraintForView: (UIView *)view height:(CGFloat)height {
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    [view addConstraint:constraint];
    return constraint;
}


// Creates constraints between views with insets specified
+(void) addInsetSpacingConstraintsWithinnerView: (UIView *)innerView outerView: (UIView *)outerView insets: (UIEdgeInsets)insets {
    innerView.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:insets.top];
    [outerView addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-insets.bottom];
    [outerView addConstraint:bottomConstraint];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:insets.left];
    [outerView addConstraint:leadingConstraint];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-insets.right];
    [outerView addConstraint:trailingConstraint];
}

+(void) addHorizontalSpacningConstrainsWithInnerView: (UIView *)innerView outerView:(UIView *)outerView leadingSpacing:(CGFloat)leadingSpacing trailingSpacing:(CGFloat)trailingSpacing {
    innerView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:leadingSpacing];
    [outerView addConstraint:leadingConstraint];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-trailingSpacing];
    [outerView addConstraint:trailingConstraint];
}

+(void) addVerticalSpacningConstrainsWithInnerView: (UIView *)innerView outerView:(UIView *)outerView topSpacing:(CGFloat)topSpacing bottomSpacing:(CGFloat)bottomSpacing {
    innerView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpacing];
    [outerView addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:outerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-bottomSpacing];
    [outerView addConstraint:bottomConstraint];
}

@end
