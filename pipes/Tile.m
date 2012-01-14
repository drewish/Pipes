//
//  Tile.m
//  pipes
//
//  Created by andrew morton on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"
#import "StartScreenLayer.h"

@implementation Tile
+(BOOL)connectNorth {return false; }
+(BOOL)connectEast {return false; }
+(BOOL)connectSouth {return false; }
+(BOOL)connectWest { return false; }

@synthesize sprite;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;    
}
- (id)initWithSprite:(CCSprite*) s
{
    self = [self init];
    if (self) {
        sprite = s;
    }
    return self;
}

-(void)endGame
{
    [[CCDirector sharedDirector] replaceScene:[StartScreenLayer scene]];
}

-(void)flowInFromNorth
{
    [self endGame];
}

-(void)flowInFromEast
{
    [self endGame];    
}

-(void)flowInFromSouth
{
    [self endGame];
}

-(void)flowInFromWest
{
    [self endGame];    
}
@end


@implementation TileEmpty : Tile
@end


@implementation TilePump
@end

@implementation TileN
+(BOOL)connectNorth {return true; }
@end

@implementation TileS
+(BOOL)connectSouth {return true; }
@end

@implementation TileE
+(BOOL)connectEast {return true; }
@end

@implementation TileW
+(BOOL)connectWest {return true; }
@end



@implementation TileSE
+(BOOL)connectEast {return true; }
+(BOOL)connectSouth {return true; }
@end

@implementation TileSW
+(BOOL)connectSouth {return true; }
+(BOOL)connectWest {return true; }
@end

@implementation TileEW
+(BOOL)connectEast {return true; }
+(BOOL)connectWest {return true; }
@end

@implementation TileNESW
+(BOOL)connectNorth {return true; }
+(BOOL)connectEast {return true; }
+(BOOL)connectSouth {return true; }
+(BOOL)connectWest {return true; }
@end

@implementation TileNE
+(BOOL)connectNorth {return true; }
+(BOOL)connectEast {return true; }
@end

@implementation TileNW
+(BOOL)connectNorth {return true; }
+(BOOL)connectWest {return true; }
@end

@implementation TileNS
+(BOOL)connectNorth {return true; }
+(BOOL)connectSouth {return true; }
@end
