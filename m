Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49081 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2DFNb5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 Apr 2012 09:31:57 -0400
Message-ID: <4F7EF043.9000305@kernel.dk>
Date: Fri, 06 Apr 2012 07:31:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20120406040004.1BF99484001@kernel.dk> <4F7E713E.7030300@suse.de>
In-Reply-To: <4F7E713E.7030300@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-04-05 22:29, Danny Kukawka wrote:
> Am 06.04.2012 06:00, schrieb Jens Axboe:
>> The following changes since commit 885ac623a4f154007efa49266bb381bcbc60f1e6:
>>
>>   iolog: remove assert in io_u overlap (2012-04-04 14:11:58 -0600)
>>
>> are available in the git repository at:
>>   git://git.kernel.dk/fio.git master
>>
>> Jens Axboe (1):
>>       group reporting: fix bad values of min/max
> 
> Should this fix also the minb/maxb and mint/maxt ? If so, it doesn't
> work for me.
> 
> fio --name=fio1-write-4m-rbd --direct=1 --size=50g --group_reporting
> --bs=4m --rw=write --iodepth=128 --ioengine=libaio --filename=/dev/rbd0
> 
> still prints:
> 
> READ: io=65260MB, aggrb=111334KB/s, minb=114006KB/s, maxb=114006KB/s,
> mint=600232msec, maxt=600232msec

Since that's still off by 1.024, are you absolutely sure you are running
the right version of fio?

-- 
Jens Axboe

