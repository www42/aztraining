---
layout: post
title: "Fancy date formats"
date: 2020-07-01 13:08:11 ++0200
categories: fun cloud useless
---

This is a useless post on useless date formats. Have a lot of fun!

## Unix date formats
Today is

Wed Jul  1 13:15:16 CEST 2020

| Write that | to get this | Meaning
| ---------- | ----------- | ----------------
| %a         | Wed         | Weekday short
| %A         | Wednesday   | Weekday long
| %b         | Jul         | Month short
| %B         | July        | Month long
| %d         | 01          | Day two digits
| %e         | 1           | Day no leading 0

Example:

date "+%Y-%m-%d %H:%M:%S +%z"