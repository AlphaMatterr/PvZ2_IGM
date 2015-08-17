/*
	Features:
	
	1. Unlimited Sun
	2. Unlimited Coins
	3. Unlimited Food
	4. Lots of Plant Food at Start of Level
	5. Free Planting
	6. Click Level to Unlock/Complete
	7. No Cooldown
	8. Buy Stuff From Store For Free
	9. Invincible Plants
	10. All Zombies Drop Sprouts
	11. Infinite World Keys
	
	Credits:
	
	αlphaMΛTTΞR
*/

#import "writeDataBypassASLR.h"

@interface SexyApplicationDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@end

int offsets[11] = {0xCB87C   , 0x11110C, 0x1BF4B4  , 0xCF5E8   , 0x283680  , 0x1E7D8E  , 0x1D3EF0  , 0x2E0C5C  , 0x128066  , 0x1FF902  , 0x2B5E46};
int before[11]  = {0xC4F8F450, 0x1144  , 0xC0F80811, 0x5BF2B6FD, 0xA7F06AFD, 0x43F1E3F9, 0x57F132F9, 0x4AF07CFA, 0x03F277F8, 0x2BF129FC, 0x75F087F9};
int after[11]   = {0xC4F8F470, 0x3144  , 0xC0F80871, 0x0120C046, 0x0120C046, 0x0120C046, 0x0120C046, 0x0120C046, 0x0120C046, 0x0120C046, 0x0120C046};

BOOL enabled[11] ={false,false,false,false,false,false,false,false,false,false,false,};

UIView *hookedView, *hackView;
UITableView *tableView;

NSMutableArray *cellNames;
NSString *gameVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
int numTaps = 0;

%hook SexyApplicationDelegate
- (void)applicationDidBecomeActive:(id)fp8 {
	hookedView = MSHookIvar<UIView *>(self, "mView");
	UIAlertView *popup;
	
	UIButton *hackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[hackBtn setFrame: CGRectMake( 0, (0.95 * hookedView.bounds.size.height), (0.10 * hookedView.bounds.size.width), (0.10 * hookedView.bounds.size.height) )];
	[hackBtn setTitle:@"" forState:UIControlStateNormal];
	[hackBtn addTarget:self action:@selector(tableFlip) forControlEvents:UIControlEventTouchUpInside];
	
	if ([gameVersion isEqualToString:@"3.8.1"]) {
		[hookedView addSubview: hackBtn];
		popup = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Detected App Version: %@",gameVersion] message:@"Version is Correct!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
		[popup show];
		[popup release];
	} else {
		popup = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"ERROR: Invalid App Version! (Detected V.%@)",gameVersion] message:@"Version Supported: 3.8.1" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
		[popup show];
		[popup release];
	}

	hackView = [[UIView alloc] initWithFrame:CGRectMake(0,0, hookedView.bounds.size.width, hookedView.bounds.size.height)];
	[hackView setBackgroundColor:[UIColor clearColor]];
	[hookedView addSubview:hackView];
	[hackView setHidden:YES];

	tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, hookedView.bounds.size.width,hookedView.bounds.size.height) style:UITableViewStyleGrouped];
	[tableView setBackgroundView:nil];
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	tableView.backgroundColor = [UIColor clearColor];
	[hackView addSubview:tableView];
	[tableView setHidden:YES];

	%orig;
}

- (void)applicationWillResignActive:(id)fp8 {
	[hackView setHidden:YES];
	[tableView setHidden:YES];
	[hackView release];
	[tableView release];
	%orig;
}

-(void)dealloc {
	[tableView release];
	[hackView release];
	%orig;
}

%new
-(void)tableFlip {
	if (hackView.hidden == YES || tableView.hidden == YES) {
		[hackView setHidden:NO];
		[tableView setHidden:NO];
	} else if (hackView.hidden == NO || tableView.hidden == NO) {
		[hackView setHidden:YES];
		[tableView setHidden:YES];
	}
}

%new
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

%new
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	cellNames = [[NSMutableArray arrayWithObjects:@"Unlimited Sun", @"Unlimited Coins", @"Unlimited Food", @"Lots of Food at Start of Level", @"Free Planting", @"Click Level to Unlock/Complete", @"Zero Planting Cooldown", @"Free Store", @"Invincible Plants", @"All Zombies Drop Sprouts", @"Infinite World Keys", @"Return",nil] retain];
	return [cellNames count];
}

%new
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* const switchCell = @"SwitchCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCell];

	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.text = [cellNames objectAtIndex:indexPath.row];
		[cell setBackgroundColor:[UIColor whiteColor]];
		cell.textLabel.textColor = [UIColor blackColor];
	}
	if (enabled[indexPath.row] && indexPath.row != [cellNames count] - 1) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

%new
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone && [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:([cellNames count] - 1) inSection:0]]) {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}

	if (numTaps == 5) {
		UIAlertView *alertCreds = [[UIAlertView alloc] initWithTitle:@"Modded By αlphaMΛTTΞR" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil,nil];
		[alertCreds show];
		[alertCreds release];
		numTaps = 0;
	}

	if (enabled[indexPath.row]) {
		enabled[indexPath.row] = false;
		writeData(offsets[indexPath.row], before[indexPath.row]);
	} else {
		enabled[indexPath.row] = true;
		writeData(offsets[indexPath.row], after[indexPath.row]);
	}
	
	if (indexPath.row == [cellNames count] - 1) {
		[hackView setHidden:YES];
		[tableView setHidden:YES];
		numTaps++;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

%end