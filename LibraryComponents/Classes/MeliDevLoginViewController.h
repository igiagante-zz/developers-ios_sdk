//
//  MeliDevLoginViewController.h
//  Pods
//
//  Created by Ignacio Giagante on 12/9/16.
//
//

#import <UIKit/UIKit.h>

typedef void (^OnLoginCompleted)(NSDictionary *);
typedef void (^OnLoginErrorDetected)(NSString *);

@interface MeliDevLoginViewController : UIViewController

@property (copy) NSString * redirectUrl;
@property (nonatomic, copy) OnLoginCompleted onLoginCompleted;
@property (nonatomic, copy) OnLoginErrorDetected onErrorDetected;

@end
