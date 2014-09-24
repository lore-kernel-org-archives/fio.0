Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46327 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXJ6d (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Sep 2014 05:58:33 -0400
Received: by mail-pd0-f169.google.com with SMTP id fp1so4195222pdb.28
        for <fio@vger.kernel.org>; Wed, 24 Sep 2014 02:58:32 -0700 (PDT)
Message-ID: <542295C4.9080606@gmail.com>
Date: Wed, 24 Sep 2014 18:58:28 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
MIME-Version: 1.0
Subject: Re: [Question] How to perform stride access?
References: <542179FA.5040106@gmail.com>	<CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>	<54228237.5000805@gmail.com> <CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com>
In-Reply-To: <CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: sitsofe@gmail.com
Cc: andrey.v.kuzmin@gmail.com, fio@vger.kernel.org

Hi Sistofe,

I am using fio-2.1.12-11-g8fc4

>> Note that the device is smaller than 32M (it is only 508B).
> 
> 508 bytes? But your block size is 512 bytes! Am I misunderstanding
> what you're doing?
Sorry, I should have written as 512kB. It was a mistake.

- Akira

On 9/24/14 6:52 PM, Sitsofe Wheeler wrote:
> On 24 September 2014 09:35, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
>>
>> However, I [...] think I still have a problem.
>>
>> I modified the command
>>
>> From:
>>>> fio --name=test --filename=#{dev.path} --rw=write --ioengine=libaio --direct=1 --io_limit=32M --size=100% --ba=4k --bs=512
>> To:
>> fio --name=test --filename=#{dev.path} --rw=write:4k --ioengine=libaio --direct=1 --io_limit=32M --bs=512
>>
>> The result is the runtime is too short.
> 
> This looks like a bug. I can reproduce it with 2.1.11-11-gb7f5 too:
> 
> dd if=/dev/zero of=/dev/shm/1M bs=1M count=1
> fio --bs=4k --rw=write:4k --filename=/dev/shm/1M --stonewall --name=1M
> --io_limit=1M  --name=2M --io_limit=2M
> [...]
> 
> Run status group 0 (all jobs):
>   WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
> mint=2msec, maxt=2msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
> mint=2msec, maxt=2msec
> 
> Why isn't io 1024KB for group 0? Additionally, shouldn't the total io
> written each group be different? Jens?
> 
>> I guess fio stops as soon as it reaches the end of the device.
>> However, I want it to repeat over and over again until io_limit is fully consumed.
>>
>> Note that the device is smaller than 32M (it is only 508B).
> 
> 508 bytes? But your block size is 512 bytes! Am I misunderstanding
> what you're doing?
> 
>> So, it should repeat more than 60 times.
>>
>> How can I repeat the workload?
> 
> number_ios fails too and using zonesize/zoneskip also doesn't help.
> The only thing left that springs to mind is to use loops or fix this
> bug :-)
> 
> 
>> Or,
>>
>> Building hand-made random map would suffice, I guess.
> 
> I'm not sure I follow. The workload you gave above is sequential with
> holes (--rw=write:4k) - why would we need a random map?
> 

