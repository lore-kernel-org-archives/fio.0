Return-Path: <fio-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:21653 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0AKGYG (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Jan 2010 01:24:06 -0500
Message-ID: <4B4AC214.5020207@oracle.com>
Date: Mon, 11 Jan 2010 11:45:48 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
MIME-Version: 1.0
Subject: Re: io scheduler merges control
References: <31699.35262.qm@web55002.mail.re4.yahoo.com>
In-Reply-To: <31699.35262.qm@web55002.mail.re4.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john smith <whalajam@yahoo.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, fio@vger.kernel.org


> 3) The third question is why the number of fio reported "merge"(s) is greater than the number of the "ios"?
These merges are since disk is online. not during the current fio run. 
Restart the machine/disk and run fio test , then fio should report 
accurate merge stats.

Thanks,
-Guru

> 
> --- On Mon, 1/4/10, Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:
> 
>> From: Alan D. Brunelle <Alan.Brunelle@hp.com>
>> Subject: Re: io scheduler merges control
>> To: "john smith" <whalajam@yahoo.com>
>> Cc: fio@vger.kernel.org
>> Date: Monday, January 4, 2010, 6:34 AM
>> On Thu, 2009-12-24 at 11:12 -0800,
> 
>> john smith wrote:
>>> IOPS-reported numbers for a test vary (more than 30%
>> in my case) from one run to another depending on kernel io
>> scheduler merges (reported in "Disk
>> stats/merges=reads/writes") making it hard to
>> measure/compare performance of block drivers, for instance.
>>> I don't see any way to turn off kernel io scheduler
>> merges (cfq or others)
>>> and I'd ask if you would consider adding support for
>> it, disabling the merges per individual device, using sys-fs
>> maybe?
>>> If you do, adding an option to fio for controlling the
>> merges would be useful too,
>>> thanks,
>>> John
>> Hi John - 
>>
>> FYI: there is /sys/block/*/queue/nomerges - when set to one
>> ('echo 1
>>> /sys/block/<dsf>/queue/nomerges) - a lot of the
>> merging attempts are
>> not performed. [Note, _some_ simple merge attempts _are_
>> still attempted
>> regardless of its setting...]
>>
>> Regards,
>> Alan
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
