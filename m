Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36486 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdILVXD (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Sep 2017 17:23:03 -0400
Received: by mail-vk0-f48.google.com with SMTP id v203so14248774vkv.3
        for <fio@vger.kernel.org>; Tue, 12 Sep 2017 14:23:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhRfQwri6n5GdfVxKpoeAo6Q5fPUX3iSzWq4yAD2M6tkA@mail.gmail.com>
References: <CADAGN7X+kH82jxchxxZmim05rd7FcLS35uU2Kzf=5WaqdY5zyw@mail.gmail.com>
 <CALjAwxh_yt=D0ctXnp85hZsRFTiYZeM3Xeq5=xzPwDSByAP4PQ@mail.gmail.com>
 <CADAGN7UciXp+z=9nHvONKXExy-QhwV=V8StyEEwdy4YFWE55QQ@mail.gmail.com>
 <CALjAwxg=95o1ruvkt=uuc3RSMCrOdVDf8YpwArsQMBTr9_9-WA@mail.gmail.com>
 <CADAGN7WpmJFSZ9_00S=3mqwhCFjwSWGJb=RasNobjJNXL==w5g@mail.gmail.com> <CALjAwxhRfQwri6n5GdfVxKpoeAo6Q5fPUX3iSzWq4yAD2M6tkA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 12 Sep 2017 22:22:31 +0100
Message-ID: <CALjAwxjxO1V1oGYGXy3=Ja9fe6k370y1Zdc95FuJAOAjeN4Bdg@mail.gmail.com>
Subject: Re: 'No I/O performed by libaio' error
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brandon Schwartz <schwartz.xn@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 12 September 2017 at 00:04, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 10 September 2017 at 03:32, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
>> On Thu, Sep 7, 2017 at 11:22 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> On 8 September 2017 at 06:10, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
>>>> On Thu, Sep 7, 2017 at 10:46 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>>>
>>>>> On 8 September 2017 at 01:13, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
>>>>>>
>>>>>> Running the following job file with --io_submit_mode=offload set will
>>>>>> occasionally give a 'No I/O performed by libaio' error
[...]
>>> OK this seems to reproduce the problem:
>>>
>>> ./fio --debug=io --name=zerolenread --size=1M --rw=randread
>>> --bs=128k,64k --ioengine=libaio --io_submit_mode=offload
>>> --filename=/tmp/zerolenread
>>
>> I tried digging into the code to see what's going on, but I'm not
>> having much luck.  Adding --norandommap to the job file will
>> at least get around the error/zero length transfer.
>
> I'd file this as an issue on github so it doesn't completely slip
> through the net.

Looks like this has been solved by
https://github.com/axboe/fio/commit/956e60eade2bddb8aadfb54b58030e0b88fd03b2
...

-- 
Sitsofe | http://sucs.org/~sits/
