//
//  SBImprintViewController.m
//  sportblog
//
//  Created by Marco Bullin on 09/10/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBImprintViewController.h"

@interface SBImprintViewController ()

@end

@implementation SBImprintViewController
UIActivityIndicatorView *activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [UIWebView new];
    webView.frame = self.view.frame;
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake((self.view.frame.size.width / 2) - 25, (self.view.frame.size.height / 2) - 25, 50, 50);
    
    NSString *fullURL = @"http://marcobullin.github.io/spofilog/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
        [self.view addSubview:activityIndicator];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [activityIndicator startAnimating];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
 
    [activityIndicator stopAnimating];
}


@end
