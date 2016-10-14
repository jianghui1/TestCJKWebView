//
//  CJWebBrowserViewController.h
//  CJWebBrowserDemo
//
//  Created by Jie Cao on 9/26/15.
//  Copyright © 2015 JieCao. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

@interface CJWKWebBrowserViewController : UIViewController<UITextFieldDelegate, WKNavigationDelegate, UIScrollViewDelegate>

-(void)loadUrl:(NSURL *)url;

@end
