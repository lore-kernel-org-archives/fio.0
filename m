Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:43564 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbbDCNBt convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 3 Apr 2015 09:01:49 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Need support about value IOPS Which FIO measured 
Date: Fri, 3 Apr 2015 13:00:44 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A857BA9@G9W0745.americas.hpqcorp.net>
References: <loom.20150403T130620-703@post.gmane.org>
In-Reply-To: <loom.20150403T130620-703@post.gmane.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nguyen Viet Dung <dungnguyenviet@vccorp.vn>, "fio@vger.kernel.org" <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Nguyen Viet Dung
> Sent: Friday, April 03, 2015 6:43 AM
> To: fio@vger.kernel.org
> Subject: Need support about value IOPS Which FIO measured
> 
> Dear
> I'm a IT. I use FIO test performance my Hard disk on system of my
> company. I searched about IOPS of hard disk on internet. And see that:
> Spin Speed 	Interface 	Average IOPS
> 5,900 rpm 	SATA 	        47
> 7,200 rpm 	SATA 	        75
> 10,000 rpm 	SATA / SAS 	150
> 15,000 rpm 	SAS 	        175
> 
> So, when i use FIO measure my hardisk (western 500GB
> I showed my result: IOPS read=34271, IOPS write=1198. This my result so
> big.
> I can't understand value IOPS of Fio.
> 
> I hope receiver your reply. Thanks you so much.
> 
> 
> testrw: (g=0): rw=rw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=8
> fio 1.59
> Starting 1 process
> testrw: Laying out IO file(s) (1 file(s) / 100MB)

Using a file means you're going through a filesystem and the page
cache.  Using such a tiny file ensures that all writes are just
going to system memory, and reads are getting cache hits and 
coming from system memory.

> testrw: (groupid=0, jobs=1): err= 0: pid=8565
>   read : io=77180KB, bw=137087KB/s, iops=34271 , runt=   563msec
>     slat (usec): min=1 , max=386 , avg= 3.57, stdev=15.60
>     clat (usec): min=4 , max=1453 , avg=155.63, stdev=126.97
>      lat (usec): min=5 , max=1456 , avg=159.35, stdev=130.95

The latency numbers also show this isn't accessing the HDD;
HDD seek times are in ms, not us.

Use the block device (e.g., /dev/sda) and access the full capacity
of the drive to see the real HDD results.

Also, if the HDD has its own write cache enabled, you'll get
distorted results on writes.

