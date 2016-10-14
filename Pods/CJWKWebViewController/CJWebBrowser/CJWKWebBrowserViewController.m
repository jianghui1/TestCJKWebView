//
//  CJWebBrowserViewController.m
//  CJWebBrowserDemo
//
//  Created by Jie Cao on 9/26/15.
//  Copyright © 2015 JieCao. All rights reserved.
//

@import WebKit;
#import "CJWKWebBrowserViewController.h"
#import "CJLayoutHelper.h"

NSInteger bottomViewHeight = 44;

@interface CJWKWebBrowserViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UILabel *inputTitleLabel;

@property (nonatomic, strong) NSLayoutConstraint *topViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomViewHeightConstraint;

@property (nonatomic, strong) NSLayoutConstraint *topViewTopAlignmentConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomViewBottomAlignmentConstraint;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic) BOOL isAnimatingTopBarAndBottonBar;

@end

@implementation CJWKWebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.scrollView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _topView = [[UIView alloc]init];
    [self.view addSubview:_topView];
    _topView.translatesAutoresizingMaskIntoConstraints = false;
    _topView.backgroundColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
    NSLayoutConstraint *topViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant: 0.0];
    [self.view addConstraint:topViewTopConstraint];
    self.topViewTopAlignmentConstraint = topViewTopConstraint;
    
    NSLayoutConstraint *topViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    [self.view addConstraint:topViewLeadingConstraint];
    
    NSLayoutConstraint *topViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    [self.view addConstraint:topViewTrailingConstraint];
    
    _topViewHeightConstraint = [CJLayoutHelper addHeightConstraintForView:self.topView height:45.0];
    
    _bottomView = [[UIView alloc]init];
    [self.view addSubview:_bottomView];
    _bottomView.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *bottomViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraint:bottomViewBottomConstraint];
    self.bottomViewBottomAlignmentConstraint = bottomViewBottomConstraint;
    
    NSLayoutConstraint *bottomViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    [self.view addConstraint:bottomViewLeadingConstraint];
    
    NSLayoutConstraint *bottomViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    [self.view addConstraint:bottomViewTrailingConstraint];
    
    _bottomViewHeightConstraint = [CJLayoutHelper addHeightConstraintForView:self.bottomView height:bottomViewHeight];
    [self addToolBar];
    [self addInputAndTitleView];
    
    _webView = [[WKWebView alloc]init];
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    
    [self.view addSubview:_webView];
    _webView.translatesAutoresizingMaskIntoConstraints = false;
    //[_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //[_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.view addConstraint:bottomConstraint];
    
    NSLayoutConstraint *webViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    [self.view addConstraint:webViewLeadingConstraint];
    
    NSLayoutConstraint *webViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    [self.view addConstraint:webViewTrailingConstraint];
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)addToolBar{
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    _backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped)];
    [_backButton setEnabled:_webView.canGoBack];
    
    _forwardButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Forward"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonTapped)];
    [_forwardButton setEnabled:_webView.canGoForward];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _closeButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
    toolBar.items = @[_backButton, _forwardButton, flexibleButton, _closeButton];
    [_bottomView addSubview:toolBar];
    [CJLayoutHelper addInsetSpacingConstraintsWithinnerView:toolBar outerView:_bottomView insets:UIEdgeInsetsZero];
}

-(void)addInputAndTitleView {

    _inputView = [[UIView alloc]init];
    [self.topView addSubview:_inputView];
    [CJLayoutHelper addInsetSpacingConstraintsWithinnerView:_inputView outerView:_topView insets:UIEdgeInsetsZero];
    
    _inputTextField = [[UITextField alloc]init];
    _inputTextField.borderStyle = UITextBorderStyleNone;
    _inputTextField.delegate = self;
    [_inputView addSubview:_inputTextField];
    
    UIEdgeInsets inputInsets = UIEdgeInsetsMake(5, 20, 5, 45);
    [CJLayoutHelper addInsetSpacingConstraintsWithinnerView:_inputTextField outerView:_inputView insets:inputInsets];
    
    UIImage *cancelImage = [[UIImage imageNamed:@"Cancel" ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [_cancelButton setImage:cancelImage forState:UIControlStateNormal];
    [_cancelButton setImage:cancelImage forState:UIControlStateHighlighted];
    [_cancelButton setImage:cancelImage forState:UIControlStateSelected];
    
    [_cancelButton addTarget:self action:@selector(cancelInputButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:_cancelButton];
    [CJLayoutHelper addVerticalSpacningConstrainsWithInnerView:_cancelButton outerView:_inputView topSpacing:10.0 bottomSpacing:10.0];
    
    NSLayoutConstraint *cancelButtonLeadingConstraint = [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_inputTextField attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
    [_inputView addConstraint:cancelButtonLeadingConstraint];
    
    NSLayoutConstraint *cancelButtonTrailingConstraint = [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_inputView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10.0];
    
    [_inputView addConstraint:cancelButtonTrailingConstraint];
    
    _inputTitleLabel = [[UILabel alloc]init];
    [_topView addSubview:_inputTitleLabel];
    [CJLayoutHelper addInsetSpacingConstraintsWithinnerView:_inputTitleLabel outerView:_topView insets:UIEdgeInsetsZero];
    [_topView bringSubviewToFront:_inputTitleLabel];
    
    _inputTitleLabel.userInteractionEnabled = YES;
    _inputTitleLabel.textAlignment = NSTextAlignmentCenter;
    _inputTitleLabel.backgroundColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleViewTapped)];
    [_inputTitleLabel addGestureRecognizer:tapGestureRecognizer];
}

-(void)titleViewTapped{
    [UIView animateWithDuration:0.5 animations:^{
        self.inputTitleLabel.alpha = 0.0;
        self.inputTextField.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.topView sendSubviewToBack:self.inputTitleLabel];
        [self.topView bringSubviewToFront:self.inputView];
        [_inputTextField becomeFirstResponder];
    }];
    
}


-(void)backButtonTapped{
    [_webView goBack];
}

-(void)forwardButtonTapped{
    [_webView goForward];
}

-(void)closeButtonTapped{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelInputButtonTapped{
    [UIView animateWithDuration:0.5 animations:^{
        self.inputTextField.alpha = 0.0;
        self.inputTitleLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.topView sendSubviewToBack:self.inputView];
        [self.topView bringSubviewToFront:self.inputTitleLabel];
    }];
    [_inputTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)lowMemoryWarning {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)loadUrl:(NSURL *)url{
    _url = url;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    _inputTitleLabel.text = url.host;
    _inputTextField.text = url.absoluteString;
    [_webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [_backButton setEnabled:webView.canGoBack];
    [_forwardButton setEnabled:webView.canGoForward];
    _inputTextField.text = webView.URL.absoluteString;
    _inputTitleLabel.text = webView.URL.host;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.webView.scrollView.panGestureRecognizer translationInView:self.view].y < 0.0){
        if (!self.isAnimatingTopBarAndBottonBar){
            self.isAnimatingTopBarAndBottonBar = true;
            self.topViewTopAlignmentConstraint.constant = -45.0;
            self.bottomViewBottomAlignmentConstraint.constant = 44.0;
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished){
                self.isAnimatingTopBarAndBottonBar = false;
            }];
        }
    } else {
        if (!self.isAnimatingTopBarAndBottonBar){
            self.isAnimatingTopBarAndBottonBar = true;
            self.topViewTopAlignmentConstraint.constant = 0.0;
            self.bottomViewBottomAlignmentConstraint.constant = 0.0;
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.isAnimatingTopBarAndBottonBar = false;
            }];
        }
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *inputText = textField.text;
    NSURL *url = [[NSURL alloc]initWithString:inputText];
    [self loadUrl:url];
    [self cancelInputButtonTapped];
    return YES;
}

-(void)keyboardWillHide{
    [self.topView sendSubviewToBack:self.inputView];
    [self.topView bringSubviewToFront:self.inputTitleLabel];
}


@end
