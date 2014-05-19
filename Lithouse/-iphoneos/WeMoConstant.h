//
//  filename Constant.h
//
//  Created by Belkin International, Software Engineering on XX/XX/XX.
//  Copyright (c) 2012-2013 Belkin International, Inc. and/or its affiliates. All rights reserved.
//
/*
 Belkin International, Inc. retains all right, title and interest (including all intellectual property rights) in and to this computer program, which is protected by applicable intellectual property laws.  Unless you have obtained a separate written license from Belkin International, Inc., you are not authorized to utilize all or a part of this computer program for any purpose (including reproduction, distribution, modification, and compilation into object code), and you must immediately destroy or return to Belkin International, Inc. all copies of this computer program.  If you are licensed by Belkin International, Inc., your rights to utilize this computer program are limited by the terms of that license.
 
 To obtain a license, please contact Belkin International, Inc.
 
 This computer program contains trade secrets owned by Belkin International, Inc. and, unless unauthorized by Belkin International, Inc. in writing, you agree to maintain the confidentiality of this computer program and related information and to not disclose this computer program and related information to any other person or entity.
 
 THIS COMPUTER PROGRAM IS PROVIDED AS IS WITHOUT ANY WARRANTIES, AND BELKIN INTERNATIONAL, INC. EXPRESSLY DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING THE WARRANTIES OF MERCHANTIBILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT.
 */

#ifndef WeMo_Universal_Constant_h
#define WeMo_Universal_Constant_h


#define DEVICE_UDN          @"Device UDN"
#define PUSH_NOTIFICATION_VALUE     @"Push Notification Value"
#define BINARY_STATE        @"BinaryState"
#define BINARY_PUSH_NOTIFICATION_KEY        @"Binary"
#define BINARY_STATE_OFF        @"0"
#define BINARY_STATE_IDLE        @"8"
#define BINARY_STATE_ON        @"1"

#define SCREEN_TITLE            @"Device Screen"
#define DEVICE_DETAIL_TITLE     @"Device Detail"
#define REFRESH_BUTTON_TITLE            @"Refresh"
#define ALERT_BUTTON_TITLE              @"Message"
#define ALERT_ERROR_TITLE              @"Error"
#define OK_BUTTON                       @"OK"
#define STATE_CHANGE_ERROR_MESSAGE      @"Failed to change the state. Error code(%d)"  
#define NETWORK_CHANGE_MESSAGE          @"Kindly connect to home router from Wi-Fi Settings."
#define DEVICE_REMOVED_MESSAGE          @"Device is removed"
#define FRIENDLY_NAME_CHANGED           @"Friendly Name changed successfully."
#define FRIENDLY_NAME_CHANGE_ERROR      @"Failed to change name."    
#define FRIENDLY_NAME                   @"Friendly Name" 
#define SAVE_BUTTON                     @"Save"

#define WEMO_SWITCH                 @"WeMo Switch"
#define WEMO_SENSOR                 @"WeMo Motion"
#define WEMO_LIGHTSWITCH                 @"WeMo Lightswitch"
#define WEMO_INSIGHT                 @"WeMo Insight"

#define DEVICE_TYPE                 @"type"
#define DEVICE_NAME                 @"Name"
#define DEVICE_FIRMWARE_VERSION                 @"F/W"
#define DEVICE_MAC_ADDRESS                 @"macAddress"
#define DEVICE_SERIAL_NUMBER                 @"serialNumber"
#define DEVICE_UDN_STRING                 @"udn"

#define DEVICE_RESTORE_SUCCESSFULLY         @"This device is removed."
#define CANCEL_BUTTON           @"Cancel"
#define TAKE_PHOTO          @"Take Photo"
#define CHOOSE_FROM_GALLERY          @"Choose from gallery"
#define FAILED_TO_OPEN_GALLERY      @"Cannot open photo library"
#define CHANGED_ICON_MESSAGE        @"Changed icon successfully."
#define DEVICE_SETTINGS_RESTORE_MESSAGE     @"Your device settings are restored successfully."
#define FAILED_TO_RESTORE_FACTORY_DEFAULT       @"Failed to restore to factory default."



#define CHANGE_ICON                 @"Change device icon"
#define CHANGE_FRIENDLY_NAME                 @"Change device friendly name"
#define RESTORE_SETTINGS                 @"Reset Settings"
#define RESTORE_TO_FACTORY_DEFAULT                @"Restore to factory default"

#define WEMO_SSID           @"WeMo"
#define EMPTY_STRING           @""


#define SERVICETYPEEVENT        @"urn:Belkin:service:basicevent:1"
#define ACT_GETBINARYSTATE      @"GetBinaryState"


#endif
