# ReTyPe
RTP: emending your errors

[![AutoHotkey](https://img.shields.io/badge/Language-AutoHotkey-yellowgreen.svg)](https://autohotkey.com/) ![](https://img.shields.io/badge/State-Stable-green.svg)

---

## Introduction

#### About

An automation and UI improvement suite written in AutoHotKey to improve the RTP|One user experience.

#### Origins

[RTP|One](http://www.activenetwork.com/solutions/rtp-one) by [Active Network](http://www.activenetwork.com/) is "_Ski & Attractions Management Software_". Whilst the software is undoubtedly extensive and powerful, not much focus was put on UI or Ux, and I found it incredibly frustrating to work with. Furthermore, the particular way in which RTP had been configured for my place of work meant there was large amounts of monotonous repetitive tasks.

ReTyPe is my solution to many of the frustrations I had when using RTP full-time for a year, which was then expanded to incorporate requests from colleagues within my team, before expanding further to facilitate and automate tasks company-wide for different departments.

#### Release

I imagine anyone else spending a lot of time in RTP having similar frustrations so I wanted to release this software as [FOSS](https://en.wikipedia.org/wiki/Free_and_open-source_software) in the hope it will make RTP a little more user-friendly.

The project first started around four years ago as a bunch of simple procedural scripts, but over the course of a year became a fully object oriented modular framework, in to which you can plugin any RTP fixing improvements you want. I had wished to release this a long long time ago, but work priorities kinda got in the way of spending the time to clean it up for public release.

However, my time with RTP is soon coming to an end and I realise if I don't do it now, I won't be able to help anyone install and use ReTyPe as I soon won't have an instance against which to test.

## Compatibility

The features in this software were built using `AutoHotKey v1.1.13.01` against `RTP|One 2013.1.1` so YMMV against future versions. We were never able to upgrade beyond that RTP version due to compatibility issues. Any later (or backward compatible) version of AHK should work fine.

## Pre-requisites

- [AutoHotKey v1.1.x](https://autohotkey.com/download/)
- Nothing will work without the client in stall of RTP|One

## Features

The best way to see what it can do is to have a nosey through the file header comments in the [refills](https://github.com/Hwulex/ReTyPe/tree/master/refills]) directory, but here's a few of some of the favourites

#### Administration

- @@TODO@@ Insert wiki links
- Treeview menu resizing (so you can see more than 10 things!)
- Bulk price multiple products by transposing a grid from Excel
- Bulk delete items from ANY list view
- Synchronise product media output
- Bulk create inventory pools
- Clone discounts (with options)
- Bulk update product component pricing
- AccessCode lookup box on components

#### Food and Beverage

- Swipe/login using RFID passes rather than mag-stripe cards

#### ONE Resort

- Automate credit card recharges (failed DTL, resort charge, etc)
- Prevent ENTER key auto-sending confirmation emails (seriously, Ux?)

#### Rental Tools

- Remove next-to-useless Print button on batch transfer (only works with serial printers) and replace with a Post & Print that auto-fires a transfer report

#### Customer Manager

- Automate adding pre-defined comments
- Automate adding hotlists

### Configuration

Configuration `.ini` files read from `%A_AppData%\ReTyPe\`. These are per-user as RTP's window and object IDs can change user-to-user on the same machine. A directory named `ReTyPe` should be created manually at `C:\Users\username\appdata\Roaming\` and then populated with the example set of files from the `conf` directory. Quite often the only required changed user-to-user is the main RTP instance identifier `Element=1`, though there are many more settings if required.

As well as config for latching on RTP, ReTyPe can be configured here whether or not to have a toolbar, which buttons to show, etc. Furthermore, many individual refills can also be configured with here with a corresponding file. Details are within each individual class file.

## Installation

I've never spent the time to build a proper installer. For development I run the scripts as-is with AutoHotKey, but for production  the script is compiled and distributed on our VM array.

Depending on how you want your setup, all of these steps are optional.

1. Create somewhere for the code to belong
 - We use: `c:\Program Files\ReTyPe\`
 - The scripts or compiled `.exe` can be run from anywhere, but we keep it with all other installed software
2. Create a Start Menu shortcut
 - Per-user: `C:\Users\username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
 - All users: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp`
 - Only required if you want it loaded at boot
3. Create the per-user config repository
 - `c:\Users\username\AppData\Roaming\ReTyPe`
 - Run the program before you create this as everything might work without any changes (but I doubt it)

### Run from source

1. Run `retype.ahk`

Hopefully that's it. Open, or focus, RTP and you should see a toolbar in its titlebar

![ReTyPe Loaded](https://snag.gy/RsN2MZ.jpg)

If all the button menus are empty the first time, just re-load ReTyPe (through the `?` menu)

![ReTyPe Menus](https://snag.gy/3Iscyw.jpg)


### Compilation

The entire ReTyPe suite can be compiled to a distributable `.exe` file removing the requirement to install AHK on client machines on which you wish to run it. Just point the [AHK2EXE](https://github.com/fincs/Ahk2Exe) compiler at the `retype.ahk` script, enter `retype.exe` for the output file, choose the included `retype.ico`, and it'll do the rest. I have built for both x86 (32 bit) and x64 (64 bit) successfully.

![Compiler settings](https://snag.gy/8GOMx4.jpg)

The compiled `.exe` will still read `.ini` files from user settings (see above).

## Configuration

## Questions, Comments, Quemments
