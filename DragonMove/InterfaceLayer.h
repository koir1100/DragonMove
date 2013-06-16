//
//  InterfaceLayer.h
//
//  Created by Sander Vispoel on 4/14/13.
//  Reviesed by Yonggu Choi on 16/6/13.
//
//

#import "CCLayer.h"

@interface InterfaceLayer : CCLayer
{
    int _playerScore;
    CCLabelTTF *_gameScore;
    float _levelSpeed;
    float _tempSpeed;
}

@property (nonatomic, assign) int playerScore;
@property (nonatomic, readwrite) float levelSpeed;
@property (nonatomic, readwrite) float tempSpeed;

-(CCLabelTTF *)getPlayerScoreTxt;
-(int)getPlayerScore;
-(void)addScore:(int)value;
-(void)setPlayerScorePositionX:(CGFloat)x Y:(CGFloat)y;

-(float)getLevelSpeed;
-(void)controlLevelSpeed:(float)value;
-(void)slowLevelSpeed:(float)levelSpeed;
-(void)fastLevelSpeed:(float)levelSpeed;
-(float)getRestoreLevelSpeed;

@end
