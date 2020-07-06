#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface PSListController ()
@end

@interface ETARootListController : PSListController
    - (void)viewDidLoad;
    - (NSMutableArray *)specifiers;

    - (id)readPreferenceValue:(PSSpecifier *)specifier;
    - (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier;
@end