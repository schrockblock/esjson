//
//  ESHuman.h
//  ESJSON
//
//  Created by Elliot Schrock on 11/5/16.
//  Copyright © 2016 Elliot. All rights reserved.
//

#import "ESServerObject.h"
@class ESHumanShip;

@interface ESHuman : ESServerObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *hairColor;
@property (nonatomic) int age;
@property (nonatomic) BOOL hasTakenRedPill;
@property (nonatomic, strong) ESHumanShip *ship;
@property (nonatomic, strong) ESHuman *loveInterest;
@property (nonatomic, strong) NSArray *titles;

+ (ESHuman *)generateNeo;
+ (ESHuman *)generateTrinity;
@end
