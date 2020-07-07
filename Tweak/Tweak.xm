NSString *etaTime;

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
    } else {
        [formatter setDateFormat:@"HH:mm"];
    }

    NSString *eta = [formatter stringFromDate:date];

    NSDictionary *dict = @{@"eta":eta};
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.h4ckua11.gmsbeta/etaChanged" object:nil userInfo:dict];
    
    return %orig;
}

%end

%hook ApplicationWillTerminateEvent

+(id)descriptor {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.h4ckua11.gmsbeta/mapsDidTerminate" object:nil userInfo:nil];
    return %orig;
}

%end

%hook GMSVectorMapView

-(BOOL)isNavigating {
    NSDictionary *dict = @{@"isNavigating":[NSNumber numberWithBool:%orig]};
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.h4ckua11.gmsbeta/isNavigatingChanged" object:nil userInfo:dict];
    return %orig;
}

%end

%hook _UIStatusBarStringView
- (instancetype)initWithFrame:(CGRect)arg1 {
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateETA:) name:@"com.h4ckua11.gmsbeta/etaChanged" object:nil];
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(isNavigatingChanged:) name:@"com.h4ckua11.gmsbeta/isNavigatingChanged" object:nil];
  [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(mapsDidTerminate) name:@"com.h4ckua11.gmsbeta/mapsDidTerminate" object:nil];
  return %orig;
}

-(void)setText:(id)text {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist"];
    
    if(!prefs){
        prefs = [[NSMutableDictionary alloc] init];
    }

    if([[prefs objectForKey:@"isNavigating"] boolValue] == YES){
        if([prefs objectForKey:@"etaTime"]){
            if([text containsString:@":"]) {
                text = [prefs objectForKey:@"etaTime"];
            }
        }
    }
    %orig;
}

%new
- (void)updateETA:(NSNotification *)noti {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist"];
    if(!prefs){
        prefs = [[NSMutableDictionary alloc] init];
    }
    NSString *eta = [noti.userInfo objectForKey:@"eta"];
    NSString *_originalText = MSHookIvar<NSString*>(self, "_originalText");
    etaTime = eta;
    //HBLogDebug(@"EtaTime: %@", etaTime);
    if([etaTime containsString:@":"]){
            [prefs setObject:etaTime forKey:@"etaTime"];
            [prefs writeToFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist" atomically:YES];
            if([_originalText containsString:@":"]) {
                [self setText:etaTime];
            }
    }
}

%new
-(void)isNavigatingChanged:(NSNotification *)noti {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist"];
    NSNumber *isNavigating = [noti.userInfo objectForKey:@"isNavigating"];

    if(!prefs){
        prefs = [[NSMutableDictionary alloc] init];
    }

    if([isNavigating boolValue] == YES) {
        if([[prefs objectForKey:@"isNavigating"] boolValue] == NO){
            [prefs setObject:[NSNumber numberWithBool:1] forKey:@"isNavigating"];
            [prefs writeToFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist" atomically:YES];
        }
    } else {
        if([[prefs objectForKey:@"isNavigating"] boolValue] == YES){
            [prefs removeObjectForKey:@"etaTime"];
            [prefs setObject:[NSNumber numberWithBool:0] forKey:@"isNavigating"];
            [prefs writeToFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist" atomically:YES];
        }
    }
}

%new
-(void)mapsDidTerminate {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist"];
    [prefs removeObjectForKey:@"etaTime"];
    [prefs setObject:[NSNumber numberWithBool:0] forKey:@"isNavigating"];
    [prefs writeToFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist" atomically:YES];
}

%end