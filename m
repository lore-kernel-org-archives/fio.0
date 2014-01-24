Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140124200732.GI7483@kernel.dk>
References: <1379451974-16100-1-git-send-email-jcasse@chromium.org>
	<CANEJEGt0OQCGi_7u68+m-7Rth2ykbaYJt+K17krd_YQCf=f96Q@mail.gmail.com>
	<20140124185855.GF7483@kernel.dk>
	<CANEJEGtcapSorcgMYRXiPBpA8sxK+u3VSL8ySyywfJQ29_KABw@mail.gmail.com>
	<20140124200732.GI7483@kernel.dk>
Date: Fri, 24 Jan 2014 12:48:44 -0800
Message-ID: <CANEJEGu5w_Lvcbnw0t_mdzqeqVugOX_bFuu521hOK9fw4r+QUA@mail.gmail.com>
Subject: Re: [PATCH] Adds check for numberio during verify phase.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Jan 24, 2014 at 12:07 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Jan 24 2014, Grant Grundler wrote:
>> [dropping jcasse since this account was deleted after his internship ended]
>>
>> On Fri, Jan 24, 2014 at 10:58 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> > On Fri, Jan 24 2014, Grant Grundler wrote:
>> >> Jens, Ping?
>> >> You think you can still integrate the three patches from Juan?
>> >
>> > I think that would be manageable. But really a new feature (or feature
>> > modification) like this should be accompanies by a job file example for
>> > it. Care to provide one?
>>
>> Yes. Do you mind cloning a git repo?
>
> It was big :-)

Sorry...but I don't know how to check out a partial repo /o\

upside is you can take a look at all the fio job and autotest control
files we are using. :)

Gwendal is cleaning up our autotest so we only use fio-2.1.2 with
verify/integrity patches applied.
CL is pending for that:
    https://chromium-review.googlesource.com/#/c/183364/

We are trying to make it easier for vendors to pick up these tests and run them.
In particular the "control.hwqual" autotest file.

...
>> BTW, Verification is failing on the 1m_stress control file...working
>> on that now:
>>     https://code.google.com/p/chromium/issues/detail?id=337651
>>
>> I suspect it's a problem of the control file though since we are
>> getting this warning:
>>     "Multiple writers may overwrite blocks that belong to other jobs.
>> This can cause verification failures."
>
> Yes, with 8 jobs going, they are going to be stomping on each others
> blocks potentially.

Yeah - that was my guess too - which means the warning is helpful.

Just to confirm: with numjobs=1, verify completes successfully.

> I queued up the 3 patches,

Awesome - thanks! :)

> but I killed the --verify-only command line
> switch. Seems unneeded, might as well just use the job option for that.

Please reconsider. We currently use --verify.  See hardware_StorageFio.py:

hardware_StorageFio/hardware_StorageFio.py:
('8k_async_randwrite', ['--verifyonly'])

I want to re-use the same job file to describe the workload but
override the "write" stage to not be executed.  Just perform verify. I
don't care what the option is called as long as I can reuse the fio
job file.

Having to clone a job file and make sure both files specify the same
things is possible but provides the opportunity for simple, stupid
mistakes. Adding --verify option eliminates that opportunity and means
we have one less fio job file to maintain....note we have quite a few
already.

thanks!
grant

