Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:32955 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbbLJS1Y (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Dec 2015 13:27:24 -0500
Received: by mail-wm0-f41.google.com with SMTP id c201so46482950wme.0
        for <fio@vger.kernel.org>; Thu, 10 Dec 2015 10:27:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5669C364.9020100@kernel.dk>
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
 <5669B23C.1020001@kernel.dk> <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
 <CANvN+e=CtQBfUmj6fQPUgaqHUXwzwY1SLuXV76n=AG2kLFpWSQ@mail.gmail.com>
 <20151210181540.GB21415@kernel.dk> <CANvN+e=U5O4LC40uE59iGn1jtkBGygbboXGcKpfXO2uTX3=bVw@mail.gmail.com>
 <5669C364.9020100@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Thu, 10 Dec 2015 21:27:03 +0300
Message-ID: <CANvN+ekovkotiX=EVxrYxmh4DJv0=+Hh4LQD+X5Ut8jDYgTdHg@mail.gmail.com>
Subject: Re: Exit all jobs on error
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Dec 10, 2015 at 9:24 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/10/2015 11:17 AM, Andrey Kuzmin wrote:
>>
>> On Thu, Dec 10, 2015 at 9:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On Thu, Dec 10 2015, Andrey Kuzmin wrote:
>>>>
>>>> I've also encountered a similar issue a number of times where the job
>>>> failed to stop (and refused to terminate in response to C-C) when a
>>>> thread/process fails, e.g. due to an error. My guess is that the loop
>>>> that waits for completions doesn't check for td->terminate being set.
>>>
>>>
>>> Attach with gdb and see what they are doing, could be a missing
>>> terminate check. Or it could already be sitting waiting for completions.
>>
>>
>> It just sits there waiting for completions, as gdb understandably
>> predominantly hits the wait state.
>
>
> Where is it sitting and/or looping?

unix/wait smth ;), as far as I recall.

If you need an exact ref, let me make up an error in the code, run,
and get back to you with the exact gdb frame info.

Regards,
A.

>
> --
> Jens Axboe
>
