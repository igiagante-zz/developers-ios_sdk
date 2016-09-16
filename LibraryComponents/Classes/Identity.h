//
//  Identity.h
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import <Foundation/Foundation.h>
#import "AccessToken.h"

@interface Identity : NSObject

@property (copy) NSString * clientId;
@property (nonatomic, strong) AccessToken * accessToken;

@end
