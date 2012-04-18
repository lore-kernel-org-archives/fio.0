Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41147 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DRSyL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Apr 2012 14:54:11 -0400
Message-ID: <4F8F0DD0.70200@kernel.dk>
Date: Wed, 18 Apr 2012 20:54:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio memory usage
References: <CAKa9NmtX=2jQGDGaesyLQtrpdHbPExZ6Dq4ikKOSt35NtbrBYw@mail.gmail.com> <4F8F0CD1.7090605@kernel.dk>
In-Reply-To: <4F8F0CD1.7090605@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-18 20:49, Jens Axboe wrote:
> On 2012-04-18 17:41, Vikram Seth wrote:
>> Hi Jens,
>>
>> What's the max memory used per job (per device) for fio? Is there a
>> rule of thumb for min memory needed for fio?
>> Like, if I am running N #threads with numjobs on M #devices in the
>> system, then I'd like to know if I have enough memory before I start
>> the test rather than I wait for it to crashes days later.
>>
>> Also, in case fio finds that it is running out of memory while
>> running, then does it generate an OOM kind of message in the output
>> file that can be used to track the reason for a crashed test.
> 
> Generally, any memory that is being used is allocated before fio starts
> running anything. That's not always strictly true. For verify workloads,
> fio will store meta data for written blocks. So memory foot print could
> grow for that. But that's the only case that isn't limited in that
> sense. Fio will alloc small items while running, but now we are in the
> sub-kb category. Things that should not fail. And they are continually
> freed as well, so not persistent items.
> 
> Usually IO buffers will take the most memory. You can easily calculate
> that, that would be queue_depth * max_buffer_size * number_of_jobs.
> Outside of that, fio sets up a shared memory segment. Default on Linux
> is 32MB. If you use a random workload and don't set norandommap, fio
> will allocate a device/file sized bitmap for tracking which blocks have
> been written or not. That consumes 1 byte per block per not-shared file.
> So for a 500gb drive using 4kb blocks as the minimum IO size, that'd be
> 122070313 blocks or ~116MB of memory for that bitmap. That'd be your
> biggest consumer of persistent memory, but one you can usually
> eliminate.
> 
> Hope that helps...

Oh, and any sort of logging of IO will also continually allocate memory.
That'd be options like write_*_log.

And I forgot to touch on what fio does if memory allocations fail. It
crashes. No attempts are being made at handling memory allocation
failures. That is something that should most likely be improved. In
reality most people run on Linux where allocations just don't fail with
the default settings, so what would happen is that the OOM killer would
terminate fio instead. I'm not sure what other platforms default to
here, but this fact has made making handling allocation failures a
smaller priority. In reality, what should be done, is have fio just exit
and report status in case of allocation failures. It would not be hard
to add.

-- 
Jens Axboe

