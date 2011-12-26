//
//  StartScreenLayer.m
//  pipes
//
//  Created by andrew morton on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StartScreenLayer.h"
#import "GameLayer.h"

@implementation StartScreenLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CCLayer *layer = [StartScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// Font Item
		CCMenuItemFont *itemNew = [CCMenuItemFont itemFromString:@"New Game" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
        }];
		[itemNew setFontSize:20];
		
		CCMenu *menu = [CCMenu menuWithItems: itemNew, nil];
		[menu alignItemsVertically];

        [self addChild: menu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

