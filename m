Return-Path: <axboe@kernel.dk>
Message-ID: <5462B6B0.3010003@kernel.dk>
Date: Tue, 11 Nov 2014 18:24:00 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio 2.1.14 released
References: <54627C44.3080909@kernel.dk> <CAF+0mv=H9cauEbP+CMCup0aLUD0qE42Jz9WPzboAv0U757acYw@mail.gmail.com>
In-Reply-To: <CAF+0mv=H9cauEbP+CMCup0aLUD0qE42Jz9WPzboAv0U757acYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-11-11 18:11, Matthew Eaton wrote:
>> - Fio will exit a bit faster now, since the disk util thread and the
>>    helper thread were combined into one, and it'll be immediately torn
>>    down on exit. It had to wait around 250msecs before this change. You
>>    might have noticed this delay when doing ctrl-c on a workload.
>
> I find this update interesting, as I have a script that calls fio
> multiple times, one after the other.
>
> Are there any options that would make fio start or exit faster?  For
> example, if I used disk_util=0, would this help fio exit any faster?

It should all be as fast as it could be before. The issue fixed above is 
when we wanted the disk util thread to exit, we set a done flag and just 
waited for it to wakeup as, which it did a few times per second. Now we 
use regular condvars, so it'll wake and exit immediately. So disk_util=0 
should not change more than a msec or so :-)

That said, if you do find things where it seems to start or stop slower 
than it should, let me know. But as far as I know, it's all properly 
driven now.

-- 
Jens Axboe


