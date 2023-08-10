//
//  AppDelegate.m
//  Hotline
//
//  Created by Dan Zachary Caruñgay on 5/18/22.
//

#import "AppDelegate.h"
#import <PushKit/PushKit.h>
#import "CallManager.h"

@interface AppDelegate () <PKPushRegistryDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - PKPushRegistryDelegate

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
    if([credentials.token length] == 0) {
        NSLog(@"voip token NULL");
        return;
    }
    
    NSLog(@"Credentials Token: %@", credentials.token);
    NSString *deviceToken = [self fetchDeviceToken:credentials.token];
    NSLog(@"Device Token: %@", deviceToken);
}

-(NSString *)fetchDeviceToken:(NSData *)deviceToken {
    NSUInteger len = deviceToken.length;
        if (len == 0) {
            return nil;
        }
        const unsigned char *buffer = deviceToken.bytes;
        NSMutableString *hexString  = [NSMutableString stringWithCapacity:(len * 2)];
        for (int i = 0; i < len; ++i) {
            [hexString appendFormat:@"%02x", buffer[i]];
        }
        return [hexString copy];
}

-(void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion {
    NSLog(@"Received push: %@", payload.dictionaryPayload);
    
    NSUUID *uuid = [NSUUID new];
    NSDictionary *data = payload.dictionaryPayload[@"data"];
    NSString *name = [data objectForKey:@"caller_name"];
    
    [[CallManager sharedInstance] reportIncomingCallForUUID:uuid name:name];
    
//    ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
//    viewController.name = name;
//    viewController.uuid = uuid;
//    viewController.isIncoming = YES;
//    UIViewController *mainViewController = self.window.rootViewController;
//    [mainViewController presentViewController:viewController animated:YES completion:nil];
}


@end
