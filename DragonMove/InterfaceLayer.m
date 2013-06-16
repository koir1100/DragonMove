//
//  InterfaceLayer.m
//
//  Created by Sander Vispoel on 4/14/13.
//  Revised by Yonggu Choi on 16/6/13.
//
//
#import "cocos2d.h"
#import "InterfaceLayer.h"

@implementation InterfaceLayer

@synthesize playerScore=_playerScore;
@synthesize levelSpeed=_levelSpeed;

-(id)init
{
    if((self=[super init]))
    {
        _gameScore = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Arial" fontSize:20];
        [self addChild:_gameScore];
        
        _gameScore.position = ccp(64,32);
        
        _playerScore = 0;
        _levelSpeed = 0.1f;
    }
    
    return self;
}

-(CCLabelTTF *)getPlayerScoreTxt
{
    return [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", _playerScore] fontName:@"Arial" fontSize:20];
}

-(int)getPlayerScore
{
    return _playerScore;
}

-(void)setPlayerScore:(int)playerScore
{
    _playerScore = playerScore;
    [_gameScore setString:[NSString stringWithFormat:@"Score: %i", _playerScore]];
}

-(void)addScore:(int)value
{
    _playerScore += value;
    [_gameScore setString:[NSString stringWithFormat:@"Score: %i", _playerScore]];
}

-(void)setPlayerScorePositionX:(CGFloat)x Y:(CGFloat)y
{
    _gameScore.position = ccp(x,y);
}

-(float)getLevelSpeed
{
    return _levelSpeed;
}

-(void)setLevelSpeed:(float)levelSpeed
{
    _levelSpeed = levelSpeed;
}

-(void)controlLevelSpeed:(float)value
{
    _levelSpeed *= value;
}

-(void)slowLevelSpeed:(float)levelSpeed
{
    _tempSpeed = levelSpeed;
    _levelSpeed = 0.1f;
}

-(void)fastLevelSpeed:(float)levelSpeed
{
    _tempSpeed = levelSpeed;
    _levelSpeed = 0.005f;
}

-(float)getRestoreLevelSpeed
{
    return _tempSpeed;
}

@end
