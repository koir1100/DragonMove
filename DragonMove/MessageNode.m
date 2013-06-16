/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "MessageNode.h"

@implementation MessageNode

@synthesize scorePlus, scoreMinus, snakeMinus, ineffective, warning;

-(id) init
{	
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	const float X_POSITION_OF_MESSAGE = windowSize.width/2.0;
	const float Y_POSITION_OF_MESSAGE = 400.0f;
	CGPoint pos = CGPointMake(X_POSITION_OF_MESSAGE, Y_POSITION_OF_MESSAGE);
	
	self = [super init];
	
	if (self)
	{
		scorePlus = [CCLabelTTF labelWithString:@"+10 SCORE" fontName:@"Arial" fontSize:20];
		[self addChild:scorePlus];
        
        scoreMinus = [CCLabelTTF labelWithString:@"-5 SCORE : FAKE CANDY" fontName:@"Arial" fontSize:20];
        scoreMinus.color = ccYELLOW;
        [self addChild:scoreMinus];
        
        snakeMinus = [CCLabelTTF labelWithString:@"One Snake's Tail removed" fontName:@"Arial" fontSize:20];
        [self addChild:snakeMinus];
        
        ineffective = [CCLabelTTF labelWithString:@"Ineffective item" fontName:@"Arial" fontSize:20];
        ineffective.color = ccMAGENTA;
        [self addChild:ineffective];
        
        warning = [CCLabelTTF labelWithString:@"WARNING : ENEMY SNAKE APPEAR!" fontName:@"Arial" fontSize:20];
        warning.color = ccRED;
        [self addChild:warning z:400];
		
		for (CCLabelTTF *label in [self children])
        {
			// 각각의 노드에 대한 위치는 화면의 중앙 상단으로 한다
			label.position = pos;
			// 스프라이트는 처음에는 숨겨둔다
			label.visible = NO;
		}
	}
	
	return self;
}

// showMessage 메소드는 int를 매개변수로 받아서 각 스프라이트를 지역변수 sprite에 할당함.
-(void)showMessage:(int)message
{
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
	const float X_POSITION_OF_MESSAGE = windowSize.width/2.0;
	const float Y_POSITION_OF_MESSAGE = 400;
	CGPoint pos = CGPointMake(X_POSITION_OF_MESSAGE, Y_POSITION_OF_MESSAGE);
	
	[self showMessage:message atPosition:pos];
}

-(void)showMessage:(int)message atPosition:(CGPoint)pos
{
	CCLabelTTF *label		= nil;
	id		action			= nil;

	// 메시지 종류에 따라 서로 다른 메시지 액션
	switch ( message ) 
    {
		case SCORE_PLUS_MESSAGE:
			label = scorePlus;
			label.visible = YES;
			[label setPosition:ccp(pos.x, 32)];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.5 opacity:250],
					  [CCDelayTime actionWithDuration:0.9], 
					  [CCEaseBackIn actionWithAction:
					   [CCMoveTo actionWithDuration:0.2 position:ccp(pos.x, -50)]],
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;
            
		case FAKE_CANDY_MESSAGE:
			label = scoreMinus;
			label.visible = YES;
			[label setPosition:ccp(pos.x, 32)];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.5 opacity:250],
					  [CCDelayTime actionWithDuration:0.9],
					  [CCEaseBackIn actionWithAction:
					   [CCMoveTo actionWithDuration:0.2 position:ccp(pos.x, -50)]],
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;
            
		case SNAKE_MINUS_MESSAGE:
			label = snakeMinus;
			label.visible = YES;
			[label setPosition:ccp(pos.x, 32)];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.5 opacity:250],
					  [CCDelayTime actionWithDuration:0.9],
					  [CCEaseBackIn actionWithAction:
					   [CCMoveTo actionWithDuration:0.2 position:ccp(pos.x, -50)]],
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;

		case INEFFECTIVE_ITEM_MESSAGE:
			label = ineffective;
			label.visible = YES;
			[label setPosition:ccp(pos.x, 32)];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.5 opacity:250],
					  [CCDelayTime actionWithDuration:0.9],
					  [CCEaseBackIn actionWithAction:
					   [CCMoveTo actionWithDuration:0.2 position:ccp(pos.x, -50)]],
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;
            
		case WARNING_MESSAGE:
			label = warning;
			label.visible = YES;
			[label setPosition:ccp(pos.x, 55)];
			action = [CCSequence actions:
					  [CCFadeTo actionWithDuration:0.5 opacity:250],
                      [CCBlink actionWithDuration:2 blinks:5],
					  [CCDelayTime actionWithDuration:0.9],
					  [CCEaseBackIn actionWithAction:
					   [CCMoveTo actionWithDuration:0.2 position:ccp(pos.x, -50)]],
					  [CCFadeTo actionWithDuration:0.01 opacity:0],
					  nil];
			break;
	}
	
	// 순차적인 액션을 보여줌
	[label runAction:action];
	return;
}

-(id)scaledMoveAction:(CCSprite *)sprite
{
	CGSize	windowSize			= [[CCDirector sharedDirector] winSize];
	float	halfOfWindowWidth	= windowSize.width/2.0f;
	CGPoint targetPoint			= ccp(halfOfWindowWidth,
									windowSize.height+sprite.contentSize.height+30);		
	
	// 두 가지 종류의 spawning action을 만든다
	id move = [CCSpawn actions:	
					 [CCEaseBackIn actionWithAction:
					  [CCMoveTo actionWithDuration:0.4 position:targetPoint]], 
					 [CCEaseBackIn actionWithAction:
					  [CCScaleTo actionWithDuration:0.4 scale:0.4f]],
					 nil] ;

	return move;
}

-(void) dealloc
{
    [scorePlus release];
    [scoreMinus release];
    [snakeMinus release];
    [ineffective release];
    [warning release];
    [super dealloc];
}

@end
