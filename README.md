# styleUP
Built with Xcode Version 8.2 (8C38)
Supports iPhone & iPad

### Notes
If given more time I'd like to have looked into dropping down to a Metal-based image view for displaying CIImages.

### Change log 12/26:
* Created the Image Service to decouple requesting, filtering, and caching images from the PhotoGridCollectionViewController.
* Used PHImageManager instead of PHImageCachingManager since ImageService handles caching of photos (filtered and unfiltered). 
* Fixed comment typo - “performance”
* Fixed a label word wrapping bug
* Preview filters for FilterSelectionCollectionViewController
* Removed unused assets
* Localized filter names
* General cleanup - variable and method renaming, spacing, pragma marks
