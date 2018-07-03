#import <Preferences/Preferences.h>

@interface SpotifyAlarmListController: PSListController {
}
@end

@implementation SpotifyAlarmListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"SpotifyAlarm" target:self] retain];
	}
	return _specifiers;
}

/* The "Visit me on github" link inside the Preferences button */
- (void)link {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/shane1027"]];
} 
@end

// vim:ft=objc
