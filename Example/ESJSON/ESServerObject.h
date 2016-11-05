//
//  ESServerObject.h
//  ESJSON
//
//  Created by Elliot Schrock on 11/5/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESServerObject : NSObject
@property (nonatomic) int objectId;
@property (nonatomic, strong) NSDate *createdAt;
@end
