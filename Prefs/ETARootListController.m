#import "ETARootListController.h"

@implementation ETARootListController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (PSSpecifier *)specifierForKey:(NSString *)key {
    for (PSSpecifier *spec in _specifiers) {
        NSString *keyInLoop = [spec propertyForKey:@"key"];
        if ([keyInLoop isEqualToString:key]) {
            return spec;
        }
    }
    return nil;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist"];
    id object = [dict objectForKey:[specifier propertyForKey:@"key"]];
    if (!object) { 
        object = [specifier propertyForKey:@"default"];
    }
    return object;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist"];
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    [dict setObject:value forKey:[specifier propertyForKey:@"key"]];
    [dict writeToFile:@"/var/mobile/Library/Preferences/com.h4ckua11.gmsbeta.plist" atomically:YES];
}

- (NSMutableArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

@end