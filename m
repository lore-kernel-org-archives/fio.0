Return-Path: <jmoyer@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: io_uring engine -- sqthread_poll option can't work as implemented
References: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
	<6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk>
	<x498sr5txag.fsf@segfault.boston.devel.redhat.com>
	<0f8ba952-418c-d63d-6b3e-021cae4cfecc@kernel.dk>
	<0edfb602-184c-f33b-485e-221be543b069@kernel.dk>
	<7a3c83bd-4bbe-72ca-b690-5b247e8b9fd0@kernel.dk>
Date: Thu, 05 Sep 2019 11:11:20 -0400
In-Reply-To: <7a3c83bd-4bbe-72ca-b690-5b247e8b9fd0@kernel.dk> (Jens Axboe's
	message of "Thu, 5 Sep 2019 09:00:48 -0600")
Message-ID: <x49h85qu6av.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens Axboe <axboe@kernel.dk> writes:

> On 9/4/19 2:43 PM, Jens Axboe wrote:
>> On 9/4/19 2:10 PM, Jens Axboe wrote:
>>> On 9/3/19 5:49 AM, Jeff Moyer wrote:
>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>
>>>>> On 8/29/19 10:38 AM, Jeff Moyer wrote:
>>>>>> Hi,
>>>>>>
>>>>>> sqthread_poll requires registered files in order to work.  That's not
>>>>>> implemented in fio, and I don't see how one would go about it (but I'm
>>>>>> not all that familiar with fio's architecture).  We basically need all
>>>>>> files to be opened before we can register them.  It looks to me as
>>>>>> though the files are opened on demand, after the io engine is
>>>>>> initialized.
>>>>>>
>>>>>> Any suggestions?
>>>>>
>>>>> Leftover from previously, when that requirement wasn't there... Using
>>>>> it from fio would require a little bit of footwork, but it's not
>>>>> impossible.
>>>>
>>>> OK, if you can point me in the right direction, I'll take a stab at it.
>>>
>>> I think if we impose the restriction that the total number of files used
>>> must fit in a registered file set, it isn't too hard. Just have the
>>> engine open the files when it starts, and provide a new ->open_file()
>>> (and ->close_file()) in the engine ops.
>>>
>>> I'll take a stab at it.
>> 
>> Here's a quick 10 min hack to get this going, if you want to run with
>> this, that'd be great. What is still needed:
>> 
>> 1) Test it... I just ran a basic test to verify it does what I think it
>>     should, that's all.
>> 2) Keep the standalone option, but make sqthread_poll imply this option
>>     as well.
>> 3) Probably add a check whether o->nr_files fits in a set. Or maybe it's
>>     fine not to, the system call will complain anyway.
>> 4) Ensure it works with things like loops= that restart things.
>> 5) Probably various things I didn't think of yet.
>
> I ran a few more tests and it seems fine, so I fixed up a bit of
> error handling and committed it.

I was going to recommend you do that.  :)  Making sqthread_poll imply
registerfiles is trivial.  I also have a man page update.  I'll send
those along after more testing.

Thanks!
Jeff

