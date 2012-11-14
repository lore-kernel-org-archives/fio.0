Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423259Ab2KNVcH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Nov 2012 16:32:07 -0500
Message-ID: <50A40DCD.7010903@kernel.dk>
Date: Wed, 14 Nov 2012 14:31:57 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: All clients impatient
References: <201211142130.qAELUrtO29392794@zion.americas.sgi.com>
In-Reply-To: <201211142130.qAELUrtO29392794@zion.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: emery@sgi.com
Cc: fio@vger.kernel.org

On 2012-11-14 14:30, emery@sgi.com wrote:
> emery@sgi.com:  Jens Axboe <axboe@kernel.dk>
> In message <50A405C4.50100@kernel.dk>, Jens Axboe writes:
>> On 2012-11-14 12:58, Jens Axboe wrote:
>>> Should work without group_reporting as well with the below patch. Can
>>> you confirm?
>>
>> Committed the patch, with a few modifications. So fio git should work
>> for you now, regardless of whether group_reporting=1 is used or not. I
>> suspect you want it on in any case, as you are only interested in the
>> aggregate results for the clients.
>>
>> -- 
>> Jens Axboe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 	I will probably run w/o group_reporting=1. I'm interested
> in both the aggregate performance of the cluster filesystem(s), and
> the deviation of the individual threads.
> 
> 	Aggregate performance helps me quickly see whether I'm getting
> the performance I expect from the filesystem or filesystems. W/o that
> feature I might have to whip out a calculator. :-)
> 
> 	Individual thread performance lets me know whether one or
> more tape drives would be bandwidth starved, which can lead to 
> excessive tape wear.

Ah I see, so you do care about individual thread numbers. Which is fine!
And at least everything should work now, regardless of whether
group_reporting is set or not.

-- 
Jens Axboe

