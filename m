Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab2JCIbV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Oct 2012 04:31:21 -0400
Message-ID: <506BEF3D.9020508@kernel.dk>
Date: Wed, 03 Oct 2012 09:54:37 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: IO depth reported by Fio/blktrace/iowatcher
References: <865760996.213912.1349247724514.JavaMail.root@thomas-krenn.com> <506BED4F.2010802@kernel.dk>
In-Reply-To: <506BED4F.2010802@kernel.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 2012-10-03 09:46, Jens Axboe wrote:
> On 2012-10-03 09:02, Georg Schönberger wrote:
>> Good Morning,
>>
>> I have a short question about the used io depth reported by Fio/blktrace/iowatcher:
>> If I am starting a test:
>> # blktrace -d /dev/sde -o hdd &
>> # fio --rw=read --name=wd --bs=1024k --direct=1 --filename=/dev/sde --offset=0 --runtime=300 --ioengine=libaio --iodepth=4
>> [...]
>>   IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>> [...]
>> As seen above Fio is reporting 100% io depth 4. In contrast to that blktrace and iowatcher (cf. attached figure) revealing the following io depths (9 and 7):
>> # blkparse hdd.blktrace.8
>> [...]
>> CPU8 (hdd):
>>  Reads Queued:        9072,     4644MiB	 Writes Queued:           0,        0KiB
>>  Read Dispatches:     9070,     4643MiB	 Write Dispatches:        0,        0KiB
>>  Reads Requeued:         0		 Writes Requeued:         0
>>  Reads Completed:     9072,     4644MiB	 Writes Completed:        0,        0KiB
>>  Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
>>  Read depth:             9
>> [...]
>> # iowatcher -t hdd.blktrace.8 -o wd.svg
>> (showing an io depth of 7)
>>
>> Where is this divergence concerning the io depths coming from? A short explanation would be great =)
> 
> You are using a relatively large block size (1024k) and that is why.
> That will be broken into 512kb chunks usually, effectively almost
> doubling the queue depth seen on the device side.
> 
> Fio reports the queue depth the way it sees it, on the submitting
> application side. That may or may not be identical to what the device
> sees. It could be higher, if the scheduler is throttling fio. Or it
> could be lower, as in this case.

BTW, this is also visible if you look at the blkparse output:

Reads Queued:        9072,     4644MiB

which gives you an average read IO size of ~524KB.

-- 
Jens Axboe

