//
//  ViewController.m
//  TestHtmlParse
//
//  Created by 진 창훈 on 13. 3. 18..
//  Copyright (c) 2013년 진 창훈. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"

#define ID_NODE 0
#define CATEGORY_NODE 2
#define SUBJECT_NODE 2
#define NAME_NODE 4
#define TIME_NODE 6
#define READ_NODE 8

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextView *logView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onReadBtnClicked:(id)sender
{
//	[self parseList];
//	[self parseChehum];
	[self parseHongbo];
}

- (void) parseList
{
	NSString* url = @"http://www.clien.net/cs2/bbs/board.php?bo_table=cm_iphonien";
	NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	TFHpple* doc = [[TFHpple alloc] initWithHTMLData:data];
	NSArray* items = [doc searchWithXPathQuery:@"//tr[@class='mytr']"];
		
	NSMutableString* logs = [NSMutableString new];
	[self.logView setClearsOnInsertion:YES];
	
	for (TFHppleElement* element in items)
	{
		NSString* uid = [[element.children[ID_NODE] firstChild] content];
		
		NSInteger subjectNode = SUBJECT_NODE;
		NSInteger nameNode = NAME_NODE;
		NSInteger timeNode = TIME_NODE;
		NSInteger readNode = READ_NODE;
		
		TFHppleElement* categoryElement = element.children[CATEGORY_NODE];
		NSString* categoryLink = nil;
		NSString* categoryTitle = nil;
		
		if ([[[categoryElement attributes] valueForKey:@"class"] isEqualToString:@"post_category"])
		{
			categoryLink = [[categoryElement.firstChild attributes] valueForKey:@"href"];
			categoryTitle =[[categoryElement.children[0] firstChild] content];
			
			subjectNode += 2;
			nameNode += 2;
			timeNode += 2;
			readNode += 2;
		}
		
		TFHppleElement* subjectElement = element.children[subjectNode];
		NSString* link = [[subjectElement.children[1] attributes] valueForKey:@"href"];
		NSString* title =[[subjectElement.children[1] firstChild] content];
		
		NSInteger nameNodeCnt = subjectElement.children.count;
		NSInteger reply = 0;
		
		if (nameNodeCnt >= 3)
		{
			NSString* replyStr = [[subjectElement.children[3] firstChild] content];
			replyStr =  [replyStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
			replyStr =  [replyStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
			reply = replyStr.integerValue;
		}
		
		TFHppleElement* nameElement = element.children[nameNode];
		NSString* name = [[nameElement.children[0] firstChild] content];
		if (name == nil)
			name = [[nameElement.children[0] attributes] valueForKey:@"src"];
		
		NSString* time = [[[element.children[timeNode] firstChild] attributes] valueForKey:@"title"];
		
		NSString* read = [[element.children[readNode] firstChild] content];
		
		NSString* log = [NSString stringWithFormat:@"\n글id : %@\n카테고리 링크 : %@\n카테고리 제목 : %@\n링크 : %@\n제목 : %@\n이름 : %@\n시간 : %@\n조회 : %@\n댓글 : %d\n\n", uid, categoryLink, categoryTitle, link, title, name, time, read, reply];
		
		[logs appendString:log];
		NSLog(@"%@", log);
		[self.logView setText:logs];
	}
}

//  체험단사용기, 알뜰구매, 쿠폰/이벤트
- (void) parseChehum
{
	NSString* url = @"http://www.clien.net/cs2/bbs/board.php?bo_table=jirum";
	NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	TFHpple* doc = [[TFHpple alloc] initWithHTMLData:data];
	NSArray* items = [doc searchWithXPathQuery:@"//div[@class='board_main']//table//tbody//tr"];
	
	NSMutableString* logs = [NSMutableString new];
	[self.logView setClearsOnInsertion:YES];
	
	NSInteger currentIndex = 0;
	for (TFHppleElement* element in items)
	{
		if (currentIndex < 3)
		{
			currentIndex++;
			continue;
		}

		NSString* uid = [[element.children[1] firstChild] content];

		NSInteger categoryNode = CATEGORY_NODE + 1;
		NSInteger subjectNode = SUBJECT_NODE + 1;
		NSInteger nameNode = NAME_NODE + 1;
		NSInteger timeNode = TIME_NODE + 1;
		NSInteger readNode = READ_NODE + 1;

		TFHppleElement* categoryElement = element.children[categoryNode];
		NSString* categoryLink = nil;
		NSString* categoryTitle = nil;

		if ([[[categoryElement attributes] valueForKey:@"class"] isEqualToString:@"post_category"])
		{
			categoryLink = [[categoryElement.firstChild attributes] valueForKey:@"href"];
			categoryTitle =[[categoryElement.children[0] firstChild] content];

			subjectNode += 2;
			nameNode += 2;
			timeNode += 2;
			readNode += 2;
		}

		TFHppleElement* subjectElement = element.children[subjectNode];
		NSString* link = [[subjectElement.children[1] attributes] valueForKey:@"href"];
		NSString* title =[[subjectElement.children[1] firstChild] content];

		NSInteger nameNodeCnt = subjectElement.children.count;
		NSInteger reply = 0;

		if (nameNodeCnt >= 3)
		{
			NSString* replyStr = [[subjectElement.children[3] firstChild] content];
			replyStr =  [replyStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
			replyStr =  [replyStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
			reply = replyStr.integerValue;
		}

		TFHppleElement* nameElement = element.children[nameNode];
		NSString* name = [[nameElement.children[0] firstChild] content];
		if (name == nil)
			name = [[nameElement.children[0] attributes] valueForKey:@"src"];

		NSString* time = [[[element.children[timeNode] firstChild] attributes] valueForKey:@"title"];

		NSString* read = [[element.children[readNode] firstChild] content];

		NSString* log = [NSString stringWithFormat:@"\n글id : %@\n카테고리 링크 : %@\n카테고리 제목 : %@\n링크 : %@\n제목 : %@\n이름 : %@\n시간 : %@\n조회 : %@\n댓글 : %d\n\n", uid, categoryLink, categoryTitle, link, title, name, time, read, reply];
		
		[logs appendString:log];
		NSLog(@"%@", log);
		[self.logView setText:logs];
	}
}

// 직접 홍보
-(void) parseHongbo
{
	NSString* url = @"http://www.clien.net/cs2/bbs/board.php?bo_table=hongbo";
	NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	TFHpple* doc = [[TFHpple alloc] initWithHTMLData:data];
	NSArray* items = [doc searchWithXPathQuery:@"//div[@class='board_main']//table//tbody//tr"];
	
	NSMutableString* logs = [NSMutableString new];
	[self.logView setClearsOnInsertion:YES];
	
	NSInteger currentIndex = 0;
	for (TFHppleElement* element in items)
	{
		if (currentIndex < 3)
		{
			currentIndex++;
			continue;
		}
		
		NSString* uid = [[element.children[1] firstChild] content];
		
		NSInteger categoryNode = CATEGORY_NODE + 1;
		NSInteger subjectNode = SUBJECT_NODE + 1;
		NSInteger nameNode = NAME_NODE + 1;
		NSInteger timeNode = TIME_NODE + 1;
		NSInteger readNode = READ_NODE + 1;
		
		TFHppleElement* categoryElement = element.children[categoryNode];
		NSString* categoryLink = nil;
		NSString* categoryTitle = nil;
		
		if ([[[categoryElement attributes] valueForKey:@"class"] isEqualToString:@"post_category"])
		{
			categoryLink = [[categoryElement.firstChild attributes] valueForKey:@"href"];
			categoryTitle =[[categoryElement.children[0] firstChild] content];
			
			subjectNode += 2;
			nameNode += 2;
			timeNode += 2;
			readNode += 2;
		}
		
		TFHppleElement* subjectElement = element.children[subjectNode];
		NSString* link = [[subjectElement.children[0] attributes] valueForKey:@"href"];
		NSString* title =[[subjectElement.children[0] firstChild] content];
		
		NSInteger nameNodeCnt = subjectElement.children.count;
		NSInteger reply = 0;
		
		if (nameNodeCnt > 3)
		{
			NSString* replyStr = [[subjectElement.children[3] firstChild] content];
			replyStr =  [replyStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
			replyStr =  [replyStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
			reply = replyStr.integerValue;
		}
		
		TFHppleElement* nameElement = element.children[nameNode];
		NSString* name = [[nameElement.children[0] firstChild] content];
		if (name == nil)
			name = [[nameElement.children[0] attributes] valueForKey:@"src"];
		
		NSString* time = [[[element.children[timeNode] firstChild] attributes] valueForKey:@"title"];
		
		NSString* read = [[element.children[readNode] firstChild] content];
		
		NSString* log = [NSString stringWithFormat:@"\n글id : %@\n카테고리 링크 : %@\n카테고리 제목 : %@\n링크 : %@\n제목 : %@\n이름 : %@\n시간 : %@\n조회 : %@\n댓글 : %d\n\n", uid, categoryLink, categoryTitle, link, title, name, time, read, reply];
		
		[logs appendString:log];
		NSLog(@"%@", log);
		[self.logView setText:logs];
	}
}
@end
