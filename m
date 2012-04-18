Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DRSty (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Apr 2012 14:49:54 -0400
Message-ID: <4F8F0CD1.7090605@kernel.dk>
Date: Wed, 18 Apr 2012 20:49:53 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio memory usage
References: <CAKa9NmtX=2jQGDGaesyLQtrpdHbPExZ6Dq4ikKOSt35NtbrBYw@mail.gmail.com>
In-Reply-To: <CAKa9NmtX=2jQGDGaesyLQtrpdHbPExZ6Dq4ikKOSt35NtbrBYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-18 17:41, Vikram Seth wrote:
> Hi Jens,
> 
> What's the max memory used per job (per device) for fio? Is there a
> rule of thumb for min memory needed for fio?
> Like, if I am running N #threads with numjobs on M #devices in the
> system, then I'd like to know if I have enough memory before I start
> the test rather than I wait for it to crashes days later.
> 
> Also, in case fio finds that it is running out of memory while
> running, then does it generate an OOM kind of message in the output
> file that can be used to track the reason for a crashed test.

Generally, any memory that is being used is allocated before fio starts
running anything. That's not always strictly true. For verify workloads,
fio will store meta data for written blocks. So memory foot print could
grow for that. But that's the only case that isn't limited in that
sense. Fio will alloc small items while running, but now we are in the
sub-kb category. Things that should not fail. And they are continually
freed as well, so not persistent items.

Usually IO buffers will take the most memory. You can easily calculate
that, that would be queue_depth * max_buffer_size * number_of_jobs.
Outside of that, fio sets up a shared memory segment. Default on Linux
is 32MB. If you use a random workload and don't set norandommap, fio
will allocate a device/file sized bitmap for tracking which blocks have
been written or not. That consumes 1 byte per block per not-shared file.
So for a 500gb drive using 4kb blocks as the minimum IO size, that'd be
122070313 blocks or ~116MB of memory for that bitmap. That'd be your
biggest consumer of persistent memory, but one you can usually
eliminate.

Hope that helps...

-- 
Jens Axboe

