@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface _UIStatusBarStringView : UILabel
@end

%hook GMSNavFooterRouteSummaryView

- (BOOL)setTimeRemaining:(CGFloat)arg1 distanceRemaining:(id)arg2 distanceAccessible:(id)arg3 arrivalTimeZone:(id)arg4 systemTimeZone:(id)arg5 timingClock:(id)arg6{
    NSInteger timeInSeconds = (int)arg1;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeInSeconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist"];
    if(!prefs){
        prefs = [[NSDictionary alloc] init];
    }

    if([[prefs objectForKey:@"timeFormat"] isEqualToString:@"am/pm"]){
        [formatter setDateFormat:@"hh:mm a"];
    } else if([[prefs objectForKey:@"timeFormat"] isEqualToString:@"24h"]){
        [formatter setDateFormat:@"HH:mm"];
    }

    NSString *eta = [formatter stringFromDate:date];
    
    NSDictionary *dict = @{@"theInfo":eta};
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.h4ckua11.gmsbeta" object:nil userInfo:dict];

    return %orig;
}

%end

%hook _UIStatusBarStringView
- (instancetype)initWithFrame:(CGRect)arg1 {
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTheNoti:) name:@"com.h4ckua11.gmsbeta" object:nil];
  return %orig;
}


%new
- (void)receivedTheNoti:(NSNotification *)noti {
    NSString *eta = [noti.userInfo objectForKey:@"theInfo"];
    NSString *_originalText = MSHookIvar<NSString*>(self, "_originalText");
    if([_originalText containsString:@":"]) {
        [self setText:eta];
    }
}

%end