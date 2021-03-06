#import "TGSharedMediaSelectionPanelView.h"

#import "TGFont.h"
#import "TGImageUtils.h"
#import "TGModernButton.h"
#import "TGStringUtils.h"

@interface TGSharedMediaSelectionPanelView ()
{
    UIView *_separatorView;
    TGModernButton *_shareButton;
    TGModernButton *_deleteButton;
    UILabel *_label;
}

@end

@implementation TGSharedMediaSelectionPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = UIColorRGB(0xf7f7f7);
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = UIColorRGB(0xb2b2b2);
        [self addSubview:_separatorView];
        
        _shareButton = [[TGModernButton alloc] init];
        _shareButton.modernHighlight = true;
        [_shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
        
        _deleteButton = [[TGModernButton alloc] init];
        _deleteButton.modernHighlight = true;
        [_deleteButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = TGAccentColor();
        _label.font = TGSystemFontOfSize(17.0f);
        [self addSubview:_label];
        
        [self _updateButtonImages];
    }
    return self;
}

- (void)setShareEnabled:(bool)shareEnabled
{
    _shareEnabled = shareEnabled;
    
    _shareButton.hidden = !_shareEnabled;
}

- (void)setDeleteEnabled:(bool)deleteEnabled {
    _deleteEnabled = deleteEnabled;
    
    _deleteButton.hidden = !_deleteEnabled;
}

- (void)setSelecterItemCount:(NSUInteger)selecterItemCount
{
    bool updateImages = (_selecterItemCount == 0) != (selecterItemCount == 0);
    _selecterItemCount = selecterItemCount;
    if (updateImages)
        [self _updateButtonImages];
    _shareButton.userInteractionEnabled = _selecterItemCount != 0;
    _deleteButton.userInteractionEnabled = _selecterItemCount != 0;
    
    if (_selecterItemCount == 0)
        _label.text = @"";
    else
    {
        _label.text = [[NSString alloc] initWithFormat:TGLocalized([TGStringUtils integerValueFormat:@"SharedMedia.ItemsSelected_" value:_selecterItemCount]), [[NSString alloc] initWithFormat:@"%d", (int)_selecterItemCount]];
    }
    [_label sizeToFit];
    [self layoutLabel];
}

- (void)_updateButtonImages
{
    UIImage *shareImage = _selecterItemCount == 0 ? [UIImage imageNamed:@"ModernConversationActionForward_Disabled.png"] : [UIImage imageNamed:@"ModernConversationActionForward.png"];
    [_shareButton setImage:shareImage forState:UIControlStateNormal];
    
    UIImage *deleteImage = _selecterItemCount == 0 ? [UIImage imageNamed:@"ModernConversationActionDelete_Disabled.png"] : [UIImage imageNamed:@"ModernConversationActionDelete.png"];
    [_deleteButton setImage:deleteImage forState:UIControlStateNormal];
}

- (void)shareButtonPressed
{
    if (_shareSelectedItems)
        _shareSelectedItems();
}

- (void)deleteButtonPressed
{
    if (_deleteSelectedItems)
        _deleteSelectedItems();
}

- (void)layoutLabel
{
    _label.frame = CGRectMake(CGFloor((self.frame.size.width - _label.frame.size.width) / 2.0f), CGFloor((self.frame.size.height - _label.frame.size.height) / 2.0f) + 1.0f, _label.frame.size.width, _label.frame.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    _separatorView.frame = CGRectMake(0.0f, 0.0f, frame.size.width, TGIsRetina() ? 0.5f : 1.0f);
    _shareButton.frame = CGRectMake(frame.size.width - 56.0f, TGRetinaPixel, 56.0f, 44.0f);
    _deleteButton.frame = CGRectMake(0.0f, TGRetinaPixel, 52.0f, 44.0f);
    
    [self layoutLabel];
}

@end
