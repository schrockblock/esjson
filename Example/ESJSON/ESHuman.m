//
//  ESHuman.m
//  ESJSON
//
//  Created by Elliot Schrock on 11/5/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import "ESHuman.h"

@implementation ESHuman

+ (ESHuman *)generateNeo
{
    ESHuman *neo = [[ESHuman alloc] init];
    neo.objectId = 1;
    neo.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:53 * 365 * 24 * 60 * 60 * 1000];
    neo.name = @"Neo";
    neo.age = 25;
    neo.hasTakenRedPill = YES;
    return neo;
}

+ (ESHuman *)generateTrinity
{
    ESHuman *trinity = [[ESHuman alloc] init];
    trinity.objectId = 2;
    trinity.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:50 * 365 * 24 * 60 * 60 * 1000];
    trinity.name = @"Trinity";
    trinity.age = 28;
    trinity.hasTakenRedPill = YES;
    return trinity;
}

@end
