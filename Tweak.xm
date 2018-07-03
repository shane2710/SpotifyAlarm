#include <UIKit/UIKit.h>
#import "common.h"

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.spookybois.spotifyalarm.plist"
#define SAEnabled GetPrefBool(@"enabled")
#define SAShuffle GetPrefBool(@"shuffle")
#define SARandom GetPrefBool(@"random")
#define SAAlarm GetPrefBool(@"alarmonly")

inline bool GetPrefBool(NSString *key) {
    return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

%hook EditAlarmViewController

-(void)loadView
{
    %orig;

    NSLog(@"[SpotifyAlarm]:[Variable Check] enabled: %d shuffle: %d random: %d  alarmonly: %d", (int)SAEnabled, (int)SAShuffle, (int)SARandom, (int)SAAlarm);

}
%end
