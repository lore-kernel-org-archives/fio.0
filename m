Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56448 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1EEBMi (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 May 2011 21:12:38 -0400
Received: by vxi39 with SMTP id 39so1753381vxi.19
        for <fio@vger.kernel.org>; Wed, 04 May 2011 18:12:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 4 May 2011 18:12:37 -0700
Message-ID: <BANLkTinaacqHwb+UfoBbhC2V4EO9z6ZTpg@mail.gmail.com>
Subject: fio accessing boot drive
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: multipart/mixed; boundary=0016e646b582a80d6004a27d110c
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--0016e646b582a80d6004a27d110c
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I started using fio recently for raw disk performance testing.
I noticed at times that while I am running the attached test file on
/dev/sdb, which is a raid 6 volume, there is lot of activity on the
boot disk /dev/sda too.

Here's excerpt from iostat output :

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00  7300.20    0.00   73.60     0.00    27.16
755.76   143.93 1950.19  13.59 100.02
sdb               0.00     0.00    0.00  210.00     0.00     0.82
8.00    10.41   49.34   4.76 100.02

I'll appreciate any insight into what can be causing these kind of
accesses on the boot drive?
Can these accesses affect overall performance results on the actual test drive?

Thanks,
Vikram.

PS: I am using fio version 1.50

--0016e646b582a80d6004a27d110c
Content-Type: text/plain; charset=US-ASCII; name="fio_test.txt"
Content-Disposition: attachment; filename="fio_test.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnb04aah0

W2dsb2JhbF0KZGVzY3JpcHRpb249U3RhbmRhcmQgUGVyZm9ybWFuY2UgdGVzdApydW50aW1lPTEy
MApkaXJlY3Q9MQpmaWxlbmFtZT0vZGV2L3NkYgpudW1qb2JzPTIwCmdyb3VwX3JlcG9ydGluZwoK
W3NlcXJlYWRfNF0Kcnc9cmVhZApicz00awoKW3NlcXJlYWRfOF0Kc3RvbmV3YWxsCnJ3PXJlYWQK
YnM9OGsKCltzZXFyZWFkXzE2XQpzdG9uZXdhbGwKcnc9cmVhZApicz0xNmsKCltzZXFyZWFkXzMy
XQpzdG9uZXdhbGwKcnc9cmVhZApicz0zMmsKCltzZXFyZWFkXzY0XQpzdG9uZXdhbGwKcnc9cmVh
ZApicz02NGsKCltzZXFyZWFkXzEyOF0Kc3RvbmV3YWxsCnJ3PXJlYWQKYnM9MTI4awoKW3NlcXJl
YWRfMjU2XQpzdG9uZXdhbGwKcnc9cmVhZApicz0yNTZrCgpbc2Vxd3JpdGVfNF0Kc3RvbmV3YWxs
CnJ3PXdyaXRlCmJzPTRrCgpbc2Vxd3JpdGVfOF0Kc3RvbmV3YWxsCnJ3PXdyaXRlCmJzPThrCgpb
c2Vxd3JpdGVfMTZdCnN0b25ld2FsbApydz13cml0ZQpicz0xNmsKCltzZXF3cml0ZV8zMl0Kc3Rv
bmV3YWxsCnJ3PXdyaXRlCmJzPTMyawoKW3NlcXdyaXRlXzY0XQpzdG9uZXdhbGwKcnc9d3JpdGUK
YnM9NjRrCgpbc2Vxd3JpdGVfMTI4XQpzdG9uZXdhbGwKcnc9d3JpdGUKYnM9MTI4awoKW3NlcXdy
aXRlXzI1Nl0Kc3RvbmV3YWxsCnJ3PXdyaXRlCmJzPTI1NmsKCltyYW5kcmVhZF80XQpzdG9uZXdh
bGwKcnc9cmFuZHJlYWQKYnM9NGsKCltyYW5kcmVhZF84XQpzdG9uZXdhbGwKcnc9cmFuZHJlYWQK
YnM9OGsKCltyYW5kcmVhZF8xNl0Kc3RvbmV3YWxsCnJ3PXJhbmRyZWFkCmJzPTE2awoKW3JhbmRy
ZWFkXzMyXQpzdG9uZXdhbGwKcnc9cmFuZHJlYWQKYnM9MzJrCgpbcmFuZHJlYWRfNjRdCnN0b25l
d2FsbApydz1yYW5kcmVhZApicz02NGsKCltyYW5kcmVhZF8xMjhdCnN0b25ld2FsbApydz1yYW5k
cmVhZApicz0xMjhrCgpbcmFuZHJlYWRfMjU2XQpzdG9uZXdhbGwKcnc9cmFuZHJlYWQKYnM9MjU2
awoKW3JhbmR3cml0ZV80XQpzdG9uZXdhbGwKcnc9cmFuZHdyaXRlCmJzPTRrCgpbcmFuZHdyaXRl
XzhdCnN0b25ld2FsbApydz1yYW5kd3JpdGUKYnM9OGsKCltyYW5kd3JpdGVfMTZdCnN0b25ld2Fs
bApydz1yYW5kd3JpdGUKYnM9MTZrCgpbcmFuZHdyaXRlXzMyXQpzdG9uZXdhbGwKcnc9cmFuZHdy
aXRlCmJzPTMyawoKW3JhbmR3cml0ZV82NF0Kc3RvbmV3YWxsCnJ3PXJhbmR3cml0ZQpicz02NGsK
CltyYW5kd3JpdGVfMTI4XQpzdG9uZXdhbGwKcnc9cmFuZHdyaXRlCmJzPTEyOGsKCltyYW5kd3Jp
dGVfMjU2XQpzdG9uZXdhbGwKcnc9cmFuZHdyaXRlCmJzPTI1NmsK
--0016e646b582a80d6004a27d110c--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


