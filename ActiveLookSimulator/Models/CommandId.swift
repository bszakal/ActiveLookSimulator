//
//  CommandId.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 10/08/2025.
//

import Foundation

enum CommandId: UInt8 {
    case power = 0
    case clear = 1
    case grey = 2
    case demo = 3
    @available(*, deprecated, renamed:"demo", message: "use demo commandID instead")
    case test = 4    // deprecated since 4.0.0
    case battery = 5
    case vers = 6
    case led = 8
    case shift = 9
    case settings = 10

    case luma = 16

    case sensor = 32
    case gesture = 33
    case als = 34

    case color = 48
    case point = 49
    case line = 50
    case rect = 51
    case rectf = 52
    case circ = 53
    case circf = 54
    case txt = 55
    case polyline = 56
    case holdFlush = 57

    case widget = 58
    
    case qspiErase = 13
    case qspiWrite = 14

    case imgSave = 65
    case imgDisplay = 66
    case imgStream = 68
    case imgSave1bpp = 69
    case imgDelete = 70
    case imgList = 71

    case fontList = 80
    case fontSave = 81
    case fontSelect = 82
    case fontDelete = 83

    case layoutSave = 96
    case layoutDelete = 97
    case layoutDisplay = 98
    case layoutClear = 99
    case layoutList = 100
    case layoutPosition = 101
    case layoutDisplayExtended = 102
    case layoutGet = 103
    case layoutClearExtended = 104
    case layoutClearAndDisplay = 105
    case layoutClearAndDisplayExtended = 106

    case gaugeDisplay = 112
    case gaugeSave = 113
    case gaugeDelete = 114
    case gaugeList = 115
    case gaugeGet = 116

    case pageSave = 128
    case pageGet = 129
    case pageDelete = 130
    case pageDisplay = 131
    case pageClear = 132
    case pageList = 133
    case pageClearAndDisplay = 134

    case animSave = 149
    case animDelete = 150
    case animDisplay = 151
    case animClear = 152
    case animList = 153
    
    case pixelCount = 165
    case getChargingCounter = 167
    case getChargingTime = 168
    case resetChargingParam = 170

    case wConfigID = 161
    case rConfigID = 162
    case setConfigID = 163

    case cfgWrite = 208
    case cfgRead = 209
    case cfgSet = 210
    case cfgList = 211
    case cfgRename = 212
    case cfgDelete = 213
    case cfgDeleteLessUsed = 214
    case cfgFreeSpace = 215
    case cfgGetNb = 216

    case shutdown = 224
    case reset = 225
    
    case unknown = 255
}
