Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:45198 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab1ACOIj (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Jan 2011 09:08:39 -0500
Message-ID: <4D21D8BE.1000403@fusionio.com>
Date: Mon, 3 Jan 2011 15:10:06 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Again on IOPS higher than expected in randwrite 4k
References: <4D1FFB1B.1010000@shiftmail.org> <4D21AD7D.7090707@fusionio.com> <4D21B281.8040501@shiftmail.org>
In-Reply-To: <4D21B281.8040501@shiftmail.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Cc: fio@vger.kernel.org

On 2011-01-03 12:26, Spelic wrote:
> On 01/03/2011 12:05 PM, Jens Axboe wrote:
>> On 2011-01-02 05:12, Spelic wrote:
>>   
>>> Hello, I just subscribed, I noticed that some 20 days ago there was a
>>> thread on "IOPS higher than expected on randwrite, direct=1 tests" on
>>> this ML.  It's curious because I subscribed to report basically the
>>> same thing.
>>>
>>> With Hitachi 7k1000 HDS721010KLA330 (maybe the same drives as
>>> Sebastian) I am seeing the same problem of IOPS too high with FIO, up
>>> to 300 IOPS per disk (up to 500 per disk with storsave=performance on
>>> my 3ware but that's probably cheating). I am doing 4k random writes.
>>>
>>> I followed the discussion, I don't really agree with the point at the
>>> end of the discussion, so I'd like to bump this thread again.
>>>
>>> My impression is that these drives do not honor the flush or FUA.
>>> (Directio uses flush or FUA right? you can be sure that data is on the
>>> platters after directio right? Anyway I also set fsync=1 and nothing
>>> changed)
>>>      
>> O_DIRECT does not imply flush of FUA, I'm afraid. It arguably should use
>> FUA, but currently it does not.
>>    
> 
> Oh I see.
> But if I add fsync=1 I still get 300 IOPS per disk, or even 500 on
> very short seeks, so again I'd say these disks are cheating.  Do you
> agree?

Did you verify that the fsync gets turned into a flush with eg blktrace?
If it indeed is, then yes your number seems too high for that disk. With
a SYNC_CACHE after each write, not even NCQ should be helping you (since
each request will effectively be sync).

-- 
Jens Axboe

