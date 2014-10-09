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

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [UIWebView new];
    webView.frame = self.view.frame;
    webView.scalesPageToFit = YES;
    
    NSString *fullURL = @"https://github.com/marcobullin/spofilog/wiki/Impressum";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
}


@end
