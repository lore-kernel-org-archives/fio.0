Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55509 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2LMNTb (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 13 Dec 2012 08:19:31 -0500
Message-ID: <50C9D5CA.9000904@kernel.dk>
Date: Thu, 13 Dec 2012 14:19:06 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Latency spikes with 'thread' option
References: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com>
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-12-12 21:11, Sam Bradshaw (sbradshaw) wrote:
> Hi All,
> 
> We're running queue depth sweeps with a 4k random read workload (sample config 
> below) against a high performance PCIe SSD - the Micron p320h.  We're seeing
> latency spikes to 1 sec when the 'thread' option is used.  Instrumenting the
> driver, we see max latencies from driver entry point to block layer completion 
> callback of <20 ms at high queue depths.  If 'thread' is not used, the max 
> latencies reported by fio align almost exactly with that seen by the driver.
> There are typically only one or two of these latency outliers during a 40 sec
> run, for example, but they represent a significant enough excursion to pull
> our std. dev. very high.
> 
> Has anyone witnessed this sort of behavior?  We see it with all the versions
> of fio that we have used (2.0.5+) with a variety of kernels.  It's also very
> suspicious that the max latency is either almost exactly 1 sec or aligns with
> our hardware incurred latency for the given queue depth.

I've seen that happen before as well, but I never got to the bottom of
it. I just tried, and I can trigger it fairly easily that dell box. If I
beat on two devices, it doesn't happen easily. Add the third, and it
hits almost immediately after starting up the threads.

For fio, the only difference between a thread and process is how they
are kicked off. So it would seem unlikely to be something in fio.
Perhaps it's a scheduling bug? But then it seems odd that nobody else
has seen this. I see exactly the same latencies you report, very close
to precisely 1s latencies. That is indeed very odd.

I'll try and poke at this a bit.

-- 
Jens Axboe

