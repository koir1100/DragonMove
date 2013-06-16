//
//  SceneManager.m
//  Cocos2dGame Template
//
//  Created by ivis01 on 13. 2. 1..
//
//

#import "SceneManager.h"
#import "SimpleAudioEngine.h"

// Scene간 Transtion에 경과되는 디폴트 시간
#define TRANSITION_DURATION (1.0f)

@interface FadeWhiteTransition : CCTransitionFade
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s;
@end

@interface FadeBlackTransition : CCTransitionFade
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s;
@end

@interface ZoomFlipXLeftOver : CCTransitionFlipX
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s;
@end

@interface FlipYDownOver : CCTransitionFlipY
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s;
@end

@implementation FadeWhiteTransition
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s
{
	return [self transitionWithDuration:t scene:s withColor:ccWHITE];
}
@end

@implementation FadeBlackTransition
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s
{
	return [self transitionWithDuration:t scene:s withColor:ccBLACK];
}
@end

@implementation ZoomFlipXLeftOver
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s
{
	return [self transitionWithDuration:t scene:s orientation:kOrientationLeftOver];
}
@end

@implementation FlipYDownOver
+(id) transitionWithDuration:(ccTime) t scene:(CCScene*)s
{
	return [self transitionWithDuration:t scene:s orientation:kOrientationDownOver];
}
@end

static int sceneIdx=0;
static NSString *transitions[] =
{
	//@"FlipYDownOver",
	@"FadeWhiteTransition",
    @"FadeBlackTransition"
	//@"ZoomFlipXLeftOver",
};

Class nextTransition()
{
	// HACK: else NSClassFromString will fail
	[CCTransitionProgress node];
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

@implementation SceneManager

// 적절한 트랜지션과 딜레이 시간을 부여하도록 한다
+(void) goMenu
// 메뉴 화면으로 이동
{
    CCLayer *layer = [MenuLayer node];
    if( ![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
    {
        SimpleAudioEngine *sound = [SimpleAudioEngine sharedEngine];
        [sound playBackgroundMusic:@"bgsound.mp3" loop:YES];
    }
    [SceneManager go:layer withTransition:@"FadeWhiteTransition" ofDelay:.2f];
}

+(void) goGame
// 게임 화면으로 이동
{
    CCLayer *layer = [GameScene node];
    if( [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
    {
        SimpleAudioEngine *sound = [SimpleAudioEngine sharedEngine];
        [sound playBackgroundMusic:@"bgsound1.mp3" loop:YES];
    }
    [SceneManager go:layer withTransition:@"FadeBlackTransition" ofDelay:.2f];
}

+(void) goGameOver
// 게임 오버 화면으로 이동
{
    CCLayer *layer = [GameOverLayer node];
    [SceneManager go:layer withTransition:@"FadeBlackTransition" ofDelay:.2f];
}

+(void) goIntro
// Intro 화면으로 이동
{
    CCLayer *layer = [IntroduceLayer node];
    [SceneManager go:layer withTransition:@"FadeWhiteTransition" ofDelay:.2f];
}

+(void) goInfo
// Info 화면으로 이동
{
    CCLayer *layer = [InfoLayer node];
    [SceneManager go:layer withTransition:@"FadeWhiteTransition" ofDelay:.2f];    
}

+(void) goHowto
// Howto 화면으로 이동
{
    CCLayer *layer = [HowtoLayer node];
    [SceneManager go:layer withTransition:@"FadeBlackTransition" ofDelay:.2f];
}

+(void) go:(CCLayer *)layer withTransition:(NSString *)transitionString ofDelay:(float)t
{
    CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
    
	Class transition = NSClassFromString(transitionString);
	
	// 이미 실행중인 Scene이 있을 경우 replaceScene을 호출
	if ([director runningScene])
        [director replaceScene:[transition transitionWithDuration:t scene:newScene]];
    // 최초의 Scene은 runWithScene으로 구동시킴
	else
		[director runWithScene:newScene];
}

+(void) go:(CCLayer *)layer withTransition:(NSString *)transitionString
{
    CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
    
	Class transition = NSClassFromString(transitionString);
	
	// 이미 실행중인 Scene이 있을 경우 replaceScene을 호출
	if ([director runningScene])
        [director replaceScene:[transition transitionWithDuration:TRANSITION_DURATION scene:newScene]];
        // 최초의 Scene은 runWithScene으로 구동시킴
	else
		[director runWithScene:newScene];
}

+(void) go:(CCLayer *)layer
{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	
	Class transition = nextTransition();
	
	if ([director runningScene])
		[director replaceScene:[transition transitionWithDuration:TRANSITION_DURATION scene:newScene]];
    else
		[director runWithScene:newScene];
}

+(CCScene *) wrap:(CCLayer *)layer
{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}

@end
