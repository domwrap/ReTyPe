# ReTyPe
RTP: emending your errors

---

## Introduction

#### Origins

[RTP|One](http://www.activenetwork.com/solutions/rtp-one) by [Active Network](http://www.activenetwork.com/) is "_Ski & Attractions Management Software_". Whilst the software is undoubtedly extensive and powerful, not much focus was put on UI or Ux, and I found it incredibly frustrating to work with. Furthermore, the particular way in which RTP had been configured for my place of work meant there was large amounts of monotonous repetitive tasks.

ReTyPe is my solution to many of the frustrations I had when using RTP full-time for a year, which was then expanded to incorporate requests from colleagues within my team, before expanding further to facilitate and automate tasks company-wide for different departments.

#### Release

I imagine anyone else spending a lot of time in RTP probably getting as frustrated with it as I did, so I wanted to release this software as [FOSS ](https://en.wikipedia.org/wiki/Free_and_open-source_software) in the hope I may make the time they do spending using RTP that little more tolerable.

I first started writing this code four years ago and over the course of a year, built it in to a fully object oriented modular framework, in to which you can plugin any RTP fixing improvements you want. I had wished to release this a long long time ago, but work priorities kinda got in the way of spending the time to clean it up for public release.

However, my time with RTP is soon coming to an end and I realise if I don't do it now, I won't be able to help anyone install and use ReTyPe as I soon won't have an instance against which to test.

## Compatibility

The features in this software were built against RTP|One 2013.1.1 so YMMV against future versions. We were never able to upgrade beyond that version due to regression issues and eStore/tStore compatibility.

## Features

The best way to see what it can do is to have a nosey through the file header comments in the [refills](https://github.com/Hwulex/ReTyPe/tree/master/refills]) directory, but here's a few of some of my (our) favourites

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

#### ONE Resort

- Automate credit card recharges (failed DTL, resort charge, etc)
- Prevent ENTER key auto-sending confirmation emails (seriously, Ux?)

#### Rental Tools

- Remove next-to-useless Print button on batch transfer (as only works with serial printers) and replace with a Post & Print that auto-fires a transfer report

#### Customer Manager

- Automate adding pre-defined comments
- Automate adding hotlists

#### Food and Beverage

- Swipe/login using RFID passes rather than mag-stripe cards

## Installation
### AutoHotKey
### Run from source
### Compilation

## Configuration

## Questions, Comments, Quemments
