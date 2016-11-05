//
//  ESServerObject.m
//  ESJSON
//
//  Created by Elliot Schrock on 11/5/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import "ESServerObject.h"

@implementation ESServerObject

+ (NSDictionary *)esjsonPropertyToKeyMap
{
    return @{@"objectId":@"id"};
}

@end
