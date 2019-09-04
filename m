Return-Path: <axboe@kernel.dk>
Subject: Re: io_uring engine -- sqthread_poll option can't work as implemented
References: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
 <6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk>
 <x498sr5txag.fsf@segfault.boston.devel.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0f8ba952-418c-d63d-6b3e-021cae4cfecc@kernel.dk>
Date: Wed, 4 Sep 2019 14:10:22 -0600
MIME-Version: 1.0
In-Reply-To: <x498sr5txag.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/3/19 5:49 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 8/29/19 10:38 AM, Jeff Moyer wrote:
>>> Hi,
>>>
>>> sqthread_poll requires registered files in order to work.  That's not
>>> implemented in fio, and I don't see how one would go about it (but I'm
>>> not all that familiar with fio's architecture).  We basically need all
>>> files to be opened before we can register them.  It looks to me as
>>> though the files are opened on demand, after the io engine is
>>> initialized.
>>>
>>> Any suggestions?
>>
>> Leftover from previously, when that requirement wasn't there... Using
>> it from fio would require a little bit of footwork, but it's not
>> impossible.
> 
> OK, if you can point me in the right direction, I'll take a stab at it.

I think if we impose the restriction that the total number of files used
must fit in a registered file set, it isn't too hard. Just have the
engine open the files when it starts, and provide a new ->open_file()
(and ->close_file()) in the engine ops.

I'll take a stab at it.

-- 
Jens Axboe


