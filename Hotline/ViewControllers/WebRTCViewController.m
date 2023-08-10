//
//  WebRTCViewController.m
//  Hotline
//
//  Created by Dan Zachary Caruñgay on 7/25/23.
//

#import "WebRTCViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WebRTCViewController ()

@end

@implementation WebRTCViewController

#pragma mark - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.urlString == nil || [self.urlString isEqual: @""] || [self.urlString isKindOfClass:[NSNull class]]) {
        self.urlString = @"https://webrtc-demo-ios-557a85eef1a3.herokuapp.com/";
    }
    [self createWebview];
}

#pragma mark - Private functions

- (IBAction)reload:(id)sender {
    [self.webview reload];
}

- (void)createWebview {
    self.webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self configureWebview]];
    [self.webview setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.webview setAllowsLinkPreview:NO];
    [self.webview setNavigationDelegate:self];
    
    self.view = self.webview;
    [self configureAudioSession];
//    [self loadUrl];
}

- (WKWebViewConfiguration *) configureWebview {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config setDataDetectorTypes:WKDataDetectorTypeAll];
    [config setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeNone];
    [config setAllowsInlineMediaPlayback:YES];
    
    return config;
}

- (void)configureAudioSession {
    NSLog(@"🟢 Configuring Audio Session");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError* err;
    [audioSession setCategory:AVAudioSessionCategoryMultiRoute error:&err];
    if (err) {
        NSLog(@"error setting audio category %@",err);
    }
    [audioSession setMode:AVAudioSessionModeDefault error:&err];
    if (err) {
        NSLog(@"error setting audio Mode %@",err);
    }
    double sampleRate = 44100.0;
    [audioSession setPreferredSampleRate:sampleRate error:&err];
    if (err) {
        NSLog(@"Error %ld, %@",(long)err.code, err.localizedDescription);
    }
    NSTimeInterval bufferDuration = .005;
    [audioSession setPreferredIOBufferDuration:bufferDuration error:&err];
    if (err) {
        NSLog(@"Error %ld, %@",(long)err.code, err.localizedDescription);
    }
    [audioSession setActive:YES error:&err];
    if (err) {
        NSLog(@"Error set Active failed: %@", err.localizedDescription);
    }
    
    [self loadUrl];
}

- (void)configureRTCSession {
    
}

- (void)loadUrl {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    //[self.webview loadRequest:request];
    
    [self verifyAVPermissionWithCompletion:^(AVAuthorizationStatus authStatus) {
        if (authStatus == AVAuthorizationStatusAuthorized) {
            NSLog(@"AV permission allowed.");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webview loadRequest:request];
            });
        } else {
            NSLog(@"AV permission denied");
        }
    }];
}

- (void)verifyAVPermissionWithCompletion:(void (^)(AVAuthorizationStatus authStatus))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        //Check Video
        [self checkVideoPermissionsWithCompletion:^(AVAuthorizationStatus authStatus) {
            if (authStatus == AVAuthorizationStatusAuthorized) {
                [self checkAudioPermissionsWithCompletion:^(AVAuthorizationStatus authStatus) {
                    if (authStatus == AVAuthorizationStatusAuthorized) {
                        completion(AVAuthorizationStatusAuthorized);
                    } else {
                        NSLog(@"Audio Permission denied");
                        completion(AVAuthorizationStatusDenied);
                    }
                }];
            } else {
                NSLog(@"Video Permission denied");
                completion(AVAuthorizationStatusDenied);
            }
        }];
        
    });
}

- (void)checkVideoPermissionsWithCompletion:(void (^)(AVAuthorizationStatus authStatus))completion {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        completion(AVAuthorizationStatusAuthorized);
    } else if(authStatus == AVAuthorizationStatusDenied) {
        completion(AVAuthorizationStatusDenied);
    } else if(authStatus == AVAuthorizationStatusRestricted) {
        completion(AVAuthorizationStatusRestricted);
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    completion(AVAuthorizationStatusAuthorized);
                } else {
                    completion(AVAuthorizationStatusDenied);
                }
            }];
        });
    }
}

- (void)checkAudioPermissionsWithCompletion:(void (^)(AVAuthorizationStatus authStatus))completion {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        completion(AVAuthorizationStatusAuthorized);
    } else if(authStatus == AVAuthorizationStatusDenied) {
        completion(AVAuthorizationStatusDenied);
    } else if(authStatus == AVAuthorizationStatusRestricted) {
        completion(AVAuthorizationStatusRestricted);
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    completion(AVAuthorizationStatusAuthorized);
                } else {
                    completion(AVAuthorizationStatusDenied);
                }
            }];
        });
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"Started loading URL: %@", webView.URL.absoluteString);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"Finished loading URL: %@", webView.URL.absoluteString);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Failed loading URL: %@", webView.URL.absoluteString);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
