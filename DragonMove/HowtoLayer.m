//
//  HowtoLayer.m
//  Cocos2dGame
//
//  Created by DongGyu Park on 13. 2. 14..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "HowtoLayer.h"

@implementation HowtoLayer

@synthesize imageBG;

- (id) init
{
	if((self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *bgSprite = [CCSprite spriteWithFile:@"bg_howto_blank.png"];
        CCSprite *gameTitle = [CCSprite spriteWithFile:@"title_howto.png"];
		[bgSprite setAnchorPoint:CGPointZero];
		[bgSprite setPosition:CGPointZero];
		[self addChild:bgSprite z:0 tag:kTagHowtoBackground];
        gameTitle.position = ccp(size.width*2/9, size.height*8/9);
        [self addChild:gameTitle z:60];
        // HowtoLayer에 필요한 이미지 삽입
        
        imageBG = [UIImage imageNamed:@"bg_howto_content.png"];
        imageView = [[UIImageView alloc] initWithImage:imageBG];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [imageView setFrame:CGRectMake(10,0,imageBG.size.width,imageBG.size.height)];
        
        // scrollView의 크기를 정하고 이 scrollView에
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 70, 465, 230)];
        [scrollView setContentSize:CGSizeMake(imageBG.size.width,imageBG.size.height)];
        [scrollView addSubview:imageView];
        [imageView release];
        
        // scrollView의 delegate 지정
        scrollView.delegate = self;
        // scrollView는 zoom In/Out이 불가능함
        scrollView.maximumZoomScale = 1.0f;
        scrollView.minimumZoomScale = 1.0f;
        
        [[[CCDirector sharedDirector] view] addSubview:scrollView];
        
        //ScrollView를 FadeIn으로 나타나게 함
        scrollView.alpha = 0;
        
        [UIScrollView beginAnimations:@"FadeIn" context:nil];
        [UIScrollView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIScrollView setAnimationDuration:1.6];
        scrollView.alpha = 1;
        
		CCMenuItem *closeMenuItem = [CCMenuItemImage itemWithNormalImage:@"btn_b1.png" selectedImage:@"btn_b2.png" target:self selector:@selector(closeMenuCallback:)];
		CCMenu *menu = [CCMenu menuWithItems:closeMenuItem, nil];
		menu.position = ccp(size.width*8/9, size.height*8/9);
		[self addChild:menu z:133 tag:kTagHowtoMenu];
        // 돌아가기 버튼 제작
	}
	return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)onExit
{
    // 장면에서 소거되면 superview로 부터 scrollView를 제거시킨다
    [scrollView removeFromSuperview];
    //	NSLog(@"scrollview removed");
}

// 메뉴가 최종적으로 아래위로 움직이는 애니메이션을 위한 메소드
-(void) menuMoveUpDown:(id)sender withOffset:(int)offset
{
	// CCMoveBy에 의해 상대적인 위치로 이동한다
	id moveUp = [CCMoveBy actionWithDuration:0.9 position:ccp(0, offset)];
	id moveDown = [CCMoveBy actionWithDuration:0.9 position:ccp(0, -offset)];
	// 아래위 움직임을 반복한다
	id moveUpDown = [CCSequence actions:moveUp, moveDown, nil];
	
	[sender runAction:[CCRepeatForever actionWithAction:moveUpDown]];
}

-(void)menuMove1:(id)sender
{
	[self menuMoveUpDown:sender withOffset:5];
}

- (void) gotoMenu
{
    // FadeOut되면서 사라짐
    [UIScrollView beginAnimations:@"FadeOut" context:nil];
    [UIScrollView setAnimationDelegate:self];
    [UIScrollView setAnimationDuration:0]; //애니메이션 일어나는시간
    scrollView.alpha = 0;
    
    [SceneManager goMenu];
}

- (void) closeMenuCallback: (id) sender
{
    //[self removeChild:introLogoScrollView cleanup:NO];
    [self performSelector:@selector(gotoMenu)
               withObject:nil
               afterDelay:0.5];
}

@end
