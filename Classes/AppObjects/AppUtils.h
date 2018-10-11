//
//  AppUtils.h
//  linphone
//
//  Created by admin on 11/5/17.
//
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABRecord.h>

#import "ContactObject.h"
#import "LinphoneAppDelegate.h"

@interface AppUtils : NSObject

+ (CGSize)getSizeWithText: (NSString *)text withFont: (UIFont *)font;
+ (CGSize)getSizeWithText: (NSString *)text withFont: (UIFont *)font andMaxWidth: (float )maxWidth;

//  Hàm random ra chuỗi ký tự bất kỳ với length tuỳ ý
+ (NSString *)randomStringWithLength: (int)len;

//  get giá trị ngày giờ hiện tại
+ (NSString *)getCurrentDateTime;

/* Kiểm tra folder cho view chat */
+ (void)checkFolderToSaveFileInViewChat;

+ (UIFont *)fontRegularWithSize: (float)fontSize;

+ (UIFont *)fontBoldWithSize: (float)fontSize;

+ (NSString *)convertUTF8StringToString: (NSString *)string;
+ (NSString *)getAvatarFromContactPerson: (ABRecordRef)person;

+ (NSString *)checkTodayForHistoryCall: (NSString *)dateStr;
+ (NSString *)checkYesterdayForHistoryCall: (NSString *)dateStr;

+ (NSString *)getCurrentDate;
/* Lấy thời gian hiện tại cho message */
+ (NSString *)getCurrentTime;

+ (NSString *)getCurrentTimeStamp;

+ (NSString *)getCurrentTimeStampNotSeconds;

/* Get UDID of device */
+ (NSString*)uniqueIDForDevice;

+ (NSString *)convertUTF8CharacterToCharacter: (NSString *)parentStr;
+ (NSString *)getNameForSearchOfConvertName: (NSString *)convertName;

/*--Hàm crop một ảnh với kích thước--*/
+ (UIImage*)cropImageWithSize:(CGSize)targetSize fromImage: (UIImage *)sourceImage;
+ (ContactObject *)getContactWithId: (int)idContact;

+ (void)createLocalNotificationWithAlertBody: (NSString *)alertBodyStr andInfoDict: (NSDictionary *)infoDict ofUser: (NSString *)user;

/* Xoá file details của message */
+ (void)deleteDetailsFileOfMessage: (NSString *)typeMessage andDetails: (NSString *)detail andThumb: (NSString *)thumb;

/*----- KIỂM TRA LOẠI CỦA FILE ĐANG NHẬN -----*/
+ (NSString *)checkFileExtension: (NSString *)fileName;

// Hàm crop image từ 1 image
+ (UIImage *)squareImageWithImage:(UIImage *)sourceImage withSizeWidth:(CGFloat)sideLength;

+ (UIImage *)getImageOfDirectoryWithName: (NSString *)imageName;
+ (NSString *)stringTimeFromInterval: (NSTimeInterval)interval;
+ (NSString *)stringDateFromInterval: (NSTimeInterval)interval;

// get data của hình ảnh với tên file
+ (NSData *)getFileDataOfMessageResend: (NSString *)fileName andFileType: (NSString *)fileType;

// Get string của hình ảnh với tên hình ảnh
+ (NSString *)getImageDataStringOfDirectoryWithName: (NSString *)imageName;

//  Tạo avatar cho group chat
+ (UIImage *)createAvatarForCurrentGroup: (NSArray *)listAvatar;

/*--Hàm save một ảnh từ view--*/
+ (NSData *) makeImageFromView: (UIView *)aView;

//  Tạo một image được crop từ một callnex
+ (UIImage *)createImageFromDataString: (NSString *)strData withCropSize: (CGSize)cropSize;

//  Get thông tin của một contact
+ (NSString *)getNameOfContact: (ABRecordRef)aPerson;

//  Get tên (custom label) của contact
+ (NSString *)getNameOfPhoneOfContact: (ABRecordRef)aPerson andPhoneNumber: (NSString *)phoneNumber;

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

+ (NSArray *)saveImageToFiles: (UIImage *)imageSend withImage: (NSString *)imageName;

// Ghi video file vào folder document
+ (BOOL)saveVideoToFiles: (NSData *)videoData withName: (NSString *)videoName;

+ (NSString *)getPBXNameWithPhoneNumber: (NSString *)phonenumber;
+ (NSString *)getAvatarOfContact: (int)idContact;

+ (UIImage *)getImageDataWithName: (NSString *)imageName;

//  Lấy status của user
+ (UIImage *)imageWithView:(UIView *)aView withSize: (CGSize)resultSize;

+ (NSString *)getDeviceModel;
+ (NSString *)getDeviceNameFromModelName: (NSString *)modelName;
+ (NSString *)getCurrentOSVersionOfDevice;
+ (NSString *)getCurrentVersionApplicaton;
+ (BOOL)soundForCallIsEnable;
+ (UIColor *)randomColorWithAlpha: (float)alpha;
+ (void)sendMessageForOfflineForUser: (NSString *)IDRecipient fromSender: (NSString *)Sender withContent: (NSString *)content andTypeMessage: (NSString *)typeMessage withGroupID: (NSString *)GroupID;

//  Added by Khai Le on 04/10/2018
+ (void)addCornerRadiusTopLeftAndBottomLeftForButton: (id)view radius: (float)radius withColor: (UIColor *)borderColor border: (float)borderWidth;
+ (void)addCornerRadiusTopRightAndBottomRightForButton: (id)view radius: (float)radius withColor: (UIColor *)borderColor border: (float)borderWidth;

// Remove all special characters from string
+ (NSString *)removeAllSpecialInString: (NSString *)phoneString;

+ (NSString *)getDateStringFromTimeInterval: (double)timeInterval;
+ (NSString *)getTimeStringFromTimeInterval:(double)timeInterval;

@end
