//
//  ESJSONTests.m
//  ESJSONTests
//
//  Created by Elliot on 11/04/2016.
//  Copyright (c) 2016 Elliot. All rights reserved.
//

// https://github.com/Specta/Specta

#import "ESHuman.h"
#import "ESJSON.h"
#import "ISO8601DateFormatter.h"
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(ESJSONSpec)

describe(@"fromJson", ^{
    it(@"can deserialize JSON into an object", ^{
        ESHuman *neo = [ESHuman generateNeo];
        NSDictionary *shipJson = @{@"id":@1001};
        NSDictionary *trinityJson = @{@"id":@2,@"name":@"Trinity",@"age":@28};
        NSDictionary *json = @{@"id":@(neo.objectId),@"name":neo.name,@"age":@(neo.age), @"ship":shipJson, @"love_interest":trinityJson, @"has_taken_red_pill":@YES};
        neo = [ESJSON modelOfClass:[ESHuman class] fromJson:json];
        
        expect(neo.objectId).to.equal(1);
        expect(neo.name).to.equal(@"Neo");
        expect(neo.age).to.equal(25);
        expect(neo.hasTakenRedPill).to.equal(YES);
        expect(neo.loveInterest).notTo.beNil();
        if (neo.loveInterest){
            expect(neo.loveInterest.name).to.equal(@"Trinity");
            expect(neo.loveInterest.age).to.equal(28);
            expect(neo.loveInterest.objectId).to.equal(2);
        }
    });
});

describe(@"toJson", ^{
    it(@"can serialize JSON from an object", ^{
        ESHuman *neo = [ESHuman generateNeo];
        neo.loveInterest = [ESHuman generateTrinity];
        
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        formatter.includeTime = YES;
        NSString *dateString = [formatter stringFromDate:neo.loveInterest.createdAt];
        
        NSDictionary *json = [ESJSON toJson:neo];
        
        expect(json).notTo.beNil();
        expect(json[@"id"]).to.equal(@1);
        expect(json[@"age"]).to.equal(@25);
        expect(json[@"name"]).to.equal(@"Neo");
        expect(json[@"love_interest"]).to.equal(@{@"id":@2,@"created_at":dateString,@"name":@"Trinity",@"age":@28,@"has_taken_red_pill":@YES});
    });
});

SpecEnd

