//
//  WebRTCViewController.h
//  Hotline
//
//  Created by Dan Zachary Caruñgay on 7/25/23.
//

#import <UIKit/UIKit.h>
#import <Webkit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebRTCViewController : UIViewController <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webview;
@property (nonatomic, retain) NSString *urlString;

@end

NS_ASSUME_NONNULL_END
