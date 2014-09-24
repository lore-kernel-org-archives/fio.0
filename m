Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57588 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaIXIfI (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Sep 2014 04:35:08 -0400
Received: by mail-pa0-f48.google.com with SMTP id bj1so957653pad.35
        for <fio@vger.kernel.org>; Wed, 24 Sep 2014 01:35:08 -0700 (PDT)
Message-ID: <54228237.5000805@gmail.com>
Date: Wed, 24 Sep 2014 17:35:03 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
MIME-Version: 1.0
Subject: Re: [Question] How to perform stride access?
References: <542179FA.5040106@gmail.com> <CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>
In-Reply-To: <CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: andrey.v.kuzmin@gmail.com
Cc: fio@vger.kernel.org

Thanks Andrey,

However, I don't think I still have a problem.

I modified the command

From:
>> fio --name=test --filename=#{dev.path} --rw=write --ioengine=libaio --direct=1 --io_limit=32M --size=100% --ba=4k --bs=512
To:
fio --name=test --filename=#{dev.path} --rw=write:4k --ioengine=libaio --direct=1 --io_limit=32M --bs=512

The result is the runtime is too short.
I guess fio stops as soon as it reaches the end of the device.
However, I want it to repeat over and over again until io_limit is fully consumed.

Note that the device is smaller than 32M (it is only 508B).
So, it should repeat more than 60 times.

How can I repeat the workload?

Or,

Building hand-made random map would suffice, I guess.

- Akira


On 9/23/14 11:05 PM, Andrey Kuzmin wrote:
> Offset modifier under rw= should do the trick, consult
> https://github.com/axboe/fio/blob/master/HOWTO for details.
> 
> Best regards,
> Andrey
> Regards,
> Andrey
> 
> 
> On Tue, Sep 23, 2014 at 5:47 PM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
>> Hi,
>>
>> I want to perform stride write access to a block device but
>> I don't have a clue how I can do that.
>>
>> What I want to do is to perform a stride access that
>> each write size is 1 sector and 7 sectors are apart between each writes.
>> (i.e. Only the first sector of each 4KB block)
>>
>> For example,
>> 0, 8, 16, 24, 32, ...
>>
>> And, it repeat over the device until certain amount of writes are accomplished.
>> In my case, amount of 32MB to 508KB device.
>>
>> I consider the command below works like as I want but it doesn't actually.
>> Instead, it looks performing ordinary 512KB seq write.
>> fio --name=test --filename=#{dev.path} --rw=write --ioengine=libaio --direct=1 --io_limit=32M --size=100% --ba=4k --bs=512
>>
>> My questions are:
>> 1) How to perform stride write access in fio?
>> 2) If fio is not a appropriate tool for this purpose, easy to fix?
>>    Or do you recommend other tool?
>>
>> - Akira
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

