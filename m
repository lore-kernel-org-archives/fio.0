Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:33928 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdBCWpC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2017 17:45:02 -0500
Received: by mail-ua0-f175.google.com with SMTP id 35so24500112uak.1
        for <fio@vger.kernel.org>; Fri, 03 Feb 2017 14:45:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <o72pn8$7ip$1@blaine.gmane.org>
References: <o72kkc$v07$2@blaine.gmane.org> <CALjAwxiuMVc3tMpb6U5Jw=i+szdj+hwY1gsV_5HmcW1mRr=AaA@mail.gmail.com>
 <o72pn8$7ip$1@blaine.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 3 Feb 2017 22:44:31 +0000
Message-ID: <CALjAwxgStfwH=9kP95g+JctZpunRZ_+zWN2kbzLgXBXLD7ytwQ@mail.gmail.com>
Subject: Re: fio exit run on timeout of device?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Slow bucks <frankwhitebe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hmm....

What do you get if you use iodepth_batch_complete_min=0 and
max_latency=1s with libaio?

On 3 February 2017 at 20:38, Slow bucks <frankwhitebe@gmail.com> wrote:
> The engine is libaio.  thoughts anyone?
>
>
> On 2017-02-03 19:39:12 +0000, Sitsofe Wheeler said:
>
>> Hi,
>>
>> Good question. From what I've seen, at the moment it partially depends
>> on the ioengine. If I/Os somehow timeout from below you might be able
>> to use max_latency. If they just hang indefinitely the engine can be
>> become stuck waiting forever..
>>
>> On 3 February 2017 at 19:11, Slow bucks <frankwhitebe@gmail.com> wrote:
>>>
>>> Is there a way to tell FIO to immediately exit if a device times out or
>>> hangs during a run?
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sitsofe | http://sucs.org/~sits/
