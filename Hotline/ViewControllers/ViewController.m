//
//  ViewController.m
//  Hotline
//
//  Created by Dan Zachary Caruñgay on 5/18/22.
//

#import "ViewController.h"
#import "CallManager.h"
#import "WebRTCViewController.h"

#import <TwilioVideo/TwilioVideo.h>

@interface ViewController () <CallManagerDelegate>

@end

@implementation ViewController

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Prepare for segue");
    if ([[segue identifier] isEqualToString:@"showWebRTC"]) {
        WebRTCViewController *vc = [segue destinationViewController];
        [vc setUrlString:@"https://webrtc-demo-ios-557a85eef1a3.herokuapp.com/"];
    }
}

#pragma mark - VC Lifecycle

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isIncoming) {
        [[CallManager sharedInstance] reportIncomingCallForUUID:self.uuid name:self.name];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.uuid == nil) {
        self.uuid = [NSUUID new];
    }
    [[CallManager sharedInstance] setDelegate:self];
}

#pragma mark - IBActions

- (IBAction)simulateCallAction:(id)sender {
    [[CallManager sharedInstance] reportIncomingCallForUUID:self.uuid name:@"Sample User"];
}

- (IBAction)startCall:(id)sender {
    [self performSegueWithIdentifier:@"showMeetingView" sender:nil];
}

#pragma mark - CallManagerDelegate

- (void)callDidAnswer {
    NSLog(@"Call Did Answer");
//    [self performSegueWithIdentifier:@"showMeetingView" sender:nil];
    [self performSegueWithIdentifier:@"showWebRTC" sender:nil];
}

- (void)callDidEnd {

}

- (void)callDidHold:(BOOL)isOnHold {

}

- (void)callDidFail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error connecting to call" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
