//
//  CallManager.h
//  Hotline
//
//  Created by Dan Zachary Caruñgay on 5/18/22.
//

#import <Foundation/Foundation.h>

@protocol CallManagerDelegate <NSObject>

- (void)callDidAnswer;
- (void)callDidEnd;
- (void)callDidHold:(BOOL)isOnHold;
- (void)callDidFail;

@end

@interface CallManager : NSObject

+ (CallManager*)sharedInstance;
- (void)reportIncomingCallForUUID:(NSUUID*)uuid phoneNumber:(NSString*)phoneNumber;
- (void)reportIncomingCallForUUID:(NSUUID*)uuid name:(NSString*)name;
- (void)startCallWithPhoneNumber:(NSString*)phoneNumber;
- (void)endCall;
- (void)holdCall:(BOOL)hold;

@property (nonatomic, weak) id<CallManagerDelegate> delegate;

@end
