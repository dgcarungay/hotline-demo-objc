//
//  ViewController.h
//  Hotline
//
//  Created by Dan Zachary Caruñgay on 5/18/22.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonnull, strong) NSUUID *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isIncoming;

@end

