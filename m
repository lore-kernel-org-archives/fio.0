Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3AaLDX (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 31 Jan 2013 06:03:23 -0500
Date: Thu, 31 Jan 2013 12:02:35 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Tune IO stack to get max IOPS out of AIO
Message-ID: <20130131110235.GF8800@kernel.dk>
References: <CAB-428m_-uqpVaeg7yLO=0SosHtVh-QhWMFsrp0KDc4msKjWtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-428m_-uqpVaeg7yLO=0SosHtVh-QhWMFsrp0KDc4msKjWtQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: linux-aio@kvack.org, fio@vger.kernel.org

On Wed, Jan 30 2013, Alireza Haghdoost wrote:
> Hello
> 
> I am trying to tune Linux IO stack to maximize application IOPS. I was
> wondering if there is any other parameter that I am missing to tune up
> ?
> 
> Right now I am using a raw block device to write sequential AIO
> requests with FIO and set :
> 1. max possible value for libaio completion queue,
> 2. max possible value for IO scheduler queue size
> (/sys/block/sda/queue/nr_requests)
> 3. max possible value for generic device driver queue depth
> (/sys/block/sda/device/queue_depth)
> 4. noop IO scheduler
> 6. disable IO merge ( echo 2 > /sys/block/sda/queueu/nomerge )
> 
> Note that the device (/dev/sda) is attached to the server over the
> network. Therefore, generic device driver will send IOs to Fiber
> Channel network driver (Qlogic qla2xxx).
> 
> Please kindly advise how can I push more IO per second ?

It's hard to answer this kind of question, since there are many things
that can be optimized. You really need a good understanding of the full
stack (app to device) and profiles/ideas on where the bottlenecks are.
On the fio side, you can relatively easily set batch parameters for
submitting and completing io - these are the iodepth_batch_submit= and
iodepth_batch_complete= settings. That will make fio submit and complete
multiple IOs at once, thus reducing the system overhead in doing that.
Now, whether that has an actual impact on your performance (or is even a
realistic thing to do, I'm assuming you are using fio to model what your
application would do), that's another question.

Your suggestions should help reduce the overhead too, though increasing
the queue depth beyond the existing 256 will usually not yield much of a
benefit. The basic hash merging is also very cheap, so unless you truly
only have random IO, it might be worth keeping.

You can also experiment with completion locations, that's the
rq_affinity setting in the same queue/ directory. A value of 1 will
migrate completions to/near the group that submitted the IO, a value of
2 will migrate it to the specific CPU. What makes sense depends on the
load of the CPU, and how costly the completion is...

Most good settings will have to be experimentally deduced. But the
better idea you have of where the problems are, the more you can
logically eliminate or prefer some settings.

-- 
Jens Axboe

