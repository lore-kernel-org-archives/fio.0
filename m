Return-Path: <ehrhardt@linux.vnet.ibm.com>
Message-ID: <53060195.1020807@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:22:29 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [patch 0/9] Collection of various fio fixes and extensions
References: <5304C9D3.4070301@linux.vnet.ibm.com> <20140219184636.GJ25515@kernel.dk>
In-Reply-To: <20140219184636.GJ25515@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, oberpar@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

On 19/02/14 19:46, Jens Axboe wrote:
> On Wed, Feb 19 2014, Christian Ehrhardt wrote:
>> As it is usually we needed a few little extensions to support the old use
>> cases we wanted to migrate to the new benchmark. Also we found a few issues
>> in the fio code that we had to fix.
>>
>> All that happened a long time back and we always wanted to cotribute our
>> changes to the project which after a loooong legal process now is finally
>> possible. To make things worse the code was affected by some bit rot due
>> to that legal waiting time which in turn stalled me making it ready for
>> submission again.
>
> Curious, what was the legal holdup? Fio being a new project to
> contribute to, or just getting it out in general. If there's anything I
> can do to make this easier in the future, let me know.
>

Essentially it is an open source project we never contributed to before 
with an offical "ok", so the amount of checks are high.
Also processes tend to go more slowly if you are not blocking GA for a 
product or so.
Unfortunately you can't improve it :-/

>> I'm happy that I finally found some time to update the patches to match to
>> the current fio git. It passed my 18 test cases which are based on the
>> examples delivered with fio new for the new functionality added.
>>
>> Looking forward to your review,
>> Christian
>>
>> The patch series includes:
>> [patch 1/9] fio: fix job clone mem leak
>> [patch 2/9] fio: allow general repeatability
>> [patch 3/9] fio: allow milliseconds on all time specifiers
>> [patch 4/9] fio: provide an option for a startdelay range
>> [patch 5/9] fio: add multi directory support
>> [patch 6/9] fio: allow combined output (default and terse)
>> [patch 7/9] fio: flush log files on test end
>> [patch 8/9] fio: fix last block never being touched by random offsets
>> [patch 9/9] fio: allow 0 as compress percentage
>
> Most of these can be applied directly. I need to double check 8/9, but
> apart from that, all looks like they can be directly applied.
>
> They seem to be mangled a bit, however, there's line wrapping going on.
> Would it be possible to resend with that fixed?
>

I have to apologize not only for line breaking, but also for a double 
submission of the mail. All this was caused by my fail to send with 
quilt mail directly and the try to import the created mbox file for 
submission via Thunderbird.
I'll give another try to configure the correct smtp to let quilt mail 
send it directly.
I hope that works without mangling and double send this time ...


