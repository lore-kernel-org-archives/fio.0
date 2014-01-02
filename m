Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:43568 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814AbaABPqn (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 2 Jan 2014 10:46:43 -0500
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 62365B214C
	for <fio@vger.kernel.org>; Thu,  2 Jan 2014 15:40:37 +0000 (UTC)
Message-ID: <52C58868.4050800@nellans.org>
Date: Thu, 02 Jan 2014 09:40:24 -0600
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: very unstable IOPS in the same test on the same machine
References: <266864ba.12fb3.1435264174a.Coremail.tech8891@163.com>
In-Reply-To: <266864ba.12fb3.1435264174a.Coremail.tech8891@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: tech8891 <tech8891@163.com>, fio@vger.kernel.org


> Problem summary:
>   The IOPS is very unstable since I changed the number of  jobs from 2 to 4.  even I changed it back,  the IOPS performance also can't return back.
> # cat 1.fio
> [global]
> rw=randread
> size=128m
>
> [job1]
>
> [job2]
>
> when I run fio 1.fio,  the iops is around 31k.  and then I add the following 2 entries:
> [job3]
>
> [job4]
>
> The IOPS dropped to around 1k.
>
> Even I remove these 2 jobs,  the IOPS still be around 1k.
>
> Only if  I removed all the jobn.n.0 files,  and re-run with 2 jobs setting,  the IOPS can be 31k again.

> # bash blkinfo.sh  /dev/sda
> Vendor     : LSI
> Model      : MR9260-8i
> Nr_request : 128
> rotational : 1

It looks like you're testing against a LSI megaraid SAS controller, 
which presumably has magnetic drives attached.  When you add more jobs 
to your config its going to cause the heads on the drives (you don't say 
how many you have) to thrash more as they try and interleave requests 
that are going to land on different portions of the disk.  So its not 
unsurprising that you'll see IOPS drop off.

A lot of how and where the IOPS will drop off is going to depend on the 
raid config of the drives you have attached to the controller however. 
Generally speaking 31k IOPS at 128MB I/O's (which will be split into
something smaller like 1MB typically) is well beyond what you should 
expect 8 HDD's to do unless you're getting lots of hits in the DRAM 
buffer on the raid controller. Enterprise HDD's (even 15k ones) 
generally can only sustain <= 250 random read IOPS, so even with perfect 
interleaving on an 8 drive raid-0, 31k seem suspicious, 1k seems 
perfectly realistic however!
