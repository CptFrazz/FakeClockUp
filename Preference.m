#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface LicenseController : PSViewController {
  UITextView *view;
}
@end

@implementation LicenseController

- (id)initForContentSize:(CGSize)size
{
  if ([[PSViewController class] instancesRespondToSelector:@selector(initForContentSize:)])
    self = [super initForContentSize:size];
  else
    self = [super init];
  if (self) {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    view = [[UITextView alloc] initWithFrame:frame];
    NSData *data = [NSData dataWithContentsOfFile:@"/Library/PreferenceBundles/FakeClockUpSettings.bundle/LICENSE"];
    view.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
    view.editable = NO;
    view.font = [UIFont systemFontOfSize:8.0f];
    if ([self respondsToSelector:@selector(navigationItem)])
      [[self navigationItem] setTitle:@"License"];
  }
  return self;
}

- (UIView *)view {
	return view;
}

- (CGSize)contentSize {
	return [view frame].size;
}

- (void)dealloc
{
	[view release];
  view = nil;
	[super dealloc];
}
@end

__attribute__((visibility("hidden")))
@interface FCPreferenceController : PSListController
- (id)specifiers;
@end

@implementation FCPreferenceController

- (id)specifiers
{
  if (_specifiers == nil) {
    _specifiers = [[self loadSpecifiersFromPlistName:@"FakeClockUp" target:self] retain];
  }
  return _specifiers;
}

- (void)setDurationValue:(id)value specifier:(id)specifier
{
  [self setPreferenceValue:value specifier:specifier];
  float duration = [value floatValue];
  float sliderValue;
  if (duration == 1.0f) {
    sliderValue = 10;
  } else if (duration < 1) {
    sliderValue = (1.0 - duration) * 10.0 + 10;
  } else {
    sliderValue = 11.0f - duration;
  }
  PSSpecifier *sliderSpecifier = [self specifierForID:@"slider"];
  [self setPreferenceValue:[NSNumber numberWithFloat:sliderValue] specifier:sliderSpecifier];
  [self reloadSpecifier:sliderSpecifier];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
}

- (void)setSliderValue:(id)value specifier:(id)specifier
{
  [self setPreferenceValue:value specifier:specifier];
  int sliderValue = [value intValue];
  double duration;
  if (sliderValue == 10) {
    duration = 1.0f;
  } else if (sliderValue > 10) {
    duration = 1.0L - (double)(sliderValue % 10) / 10.0L;
  } else {
    duration = 11.0f - (double)sliderValue;
  }
  PSSpecifier *durationSpecifier = [self specifierForID:@"duration"];
  [self setPreferenceValue:[NSString stringWithFormat:@"%f", duration] specifier:durationSpecifier];
  [self reloadSpecifier:durationSpecifier];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)openCydia:(id)specifier {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/jp.r-plus.sleipnizerforsafari"]];
}

- (void)openGithub:(id)specifier {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/r-plus/FakeClockUp/"]];
}

@end

