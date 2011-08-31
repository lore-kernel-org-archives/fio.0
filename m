Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35372 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1HaT4L (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Aug 2011 15:56:11 -0400
Message-ID: <4E5E91D9.4000702@fusionio.com>
Date: Wed, 31 Aug 2011 13:56:09 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio file test patterns
References: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com> <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Brian Fallik <bfallik@bamboom.com>, fio@vger.kernel.org

On 2011-08-31 12:30, Jeff Moyer wrote:
> Brian Fallik <bfallik@bamboom.com> writes:
> 
>> Hi,
>>
>> Apologies if this is documented somewhere else but I couldn't find it
>> in the fio man page, example job files, or list archives.
>>
>> I'm exploring fio as a testing tool and it seems very well suited for
>> my needs.  I'm currently running experiments with N sequential writers
>> all writing at 200k.  The jobs file is very simple:
>>     [global]
>>     size=10m
>>     directory=.
>>
>>     [foo1]
>>     rw=write
>>     rate=200k
>>
>>     [foo2]
>>     ...
>> fio creates various foo* files as part of its test but they all seem
>> to contain the same content.  I would have expected fio to generate
>> random data in each file to avoid potential optimizations like
>> deduplication.   Am I missing the flag to generate random test
>> patterns or is this behavior intentional?
> 
>        refill_buffers
>               If this option is given, fio will refill the IO buffers on every
>               submit. The default is to only fill it at init  time and reuse
>               that  data.  Only  makes  sense if zero_buffers isn't specified,
>               naturally. If data verification is  enabled, refill_buffers is
>               also automatically enabled.

Yes. Fio does use random data by default, but for to avoid slowing down
too much, it also defaults to reusing the same random data all the time.
If you set the above option, you get fully fresh random data for every
write, thus fully defeating any de-dupe/compression attempts on the
target.

-- 
Jens Axboe

