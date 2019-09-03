Return-Path: <jmoyer@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: io_uring engine -- sqthread_poll option can't work as implemented
References: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
	<6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk>
Date: Tue, 03 Sep 2019 07:49:11 -0400
In-Reply-To: <6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk> (Jens Axboe's
	message of "Fri, 30 Aug 2019 21:18:39 -0600")
Message-ID: <x498sr5txag.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens Axboe <axboe@kernel.dk> writes:

> On 8/29/19 10:38 AM, Jeff Moyer wrote:
>> Hi,
>> 
>> sqthread_poll requires registered files in order to work.  That's not
>> implemented in fio, and I don't see how one would go about it (but I'm
>> not all that familiar with fio's architecture).  We basically need all
>> files to be opened before we can register them.  It looks to me as
>> though the files are opened on demand, after the io engine is
>> initialized.
>> 
>> Any suggestions?
>
> Leftover from previously, when that requirement wasn't there... Using
> it from fio would require a little bit of footwork, but it's not
> impossible.

OK, if you can point me in the right direction, I'll take a stab at it.

-Jeff

