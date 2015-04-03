Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbbDCMaG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 3 Apr 2015 08:30:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1Ye0jb-0000jX-OY
	for fio@vger.kernel.org; Fri, 03 Apr 2015 14:30:04 +0200
Received: from localhost ([localhost])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Fri, 03 Apr 2015 14:30:03 +0200
Received: from dungnguyenviet by localhost with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Fri, 03 Apr 2015 14:30:03 +0200
From: Nguyen Viet Dung <dungnguyenviet@vccorp.vn>
Subject: Need support about value IOPS Which FIO measured 
Date: Fri, 3 Apr 2015 11:42:39 +0000 (UTC)
Message-ID: <loom.20150403T130620-703@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Dear
I'm a IT. I use FIO test performance my Hard disk on system of my company. I
searched about IOPS of hard disk on internet. And see that:
Spin Speed 	Interface 	Average IOPS
5,900 rpm 	SATA 	        47
7,200 rpm 	SATA 	        75
10,000 rpm 	SATA / SAS 	150
15,000 rpm 	SAS 	        175

So, when i use FIO measure my hardisk (western 500GB 
I showed my result: IOPS read=34271, IOPS write=1198. This my result so big.
I can't understand value IOPS of Fio. 

I hope receiver your reply. Thanks you so much.


testrw: (g=0): rw=rw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=8
fio 1.59
Starting 1 process
testrw: Laying out IO file(s) (1 file(s) / 100MB)

testrw: (groupid=0, jobs=1): err= 0: pid=8565
  read : io=77180KB, bw=137087KB/s, iops=34271 , runt=   563msec
    slat (usec): min=1 , max=386 , avg= 3.57, stdev=15.60
    clat (usec): min=4 , max=1453 , avg=155.63, stdev=126.97
     lat (usec): min=5 , max=1456 , avg=159.35, stdev=130.95
    bw (KB/s) : min=135464, max=135464, per=98.82%, avg=135464.00, stdev= 0.00
  write: io=25220KB, bw=44796KB/s, iops=11198 , runt=   563msec
    slat (usec): min=35 , max=612 , avg=69.98, stdev=54.35
    clat (usec): min=15 , max=1006 , avg=148.85, stdev=117.44
     lat (usec): min=51 , max=1462 , avg=220.05, stdev=135.48
    bw (KB/s) : min=44208, max=44208, per=98.69%, avg=44208.00, stdev= 0.00


