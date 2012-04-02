Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57060 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2DBEl2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 2 Apr 2012 00:41:28 -0400
Message-ID: <4F792DED.3070004@kernel.dk>
Date: Sun, 01 Apr 2012 21:41:17 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Sequential write problems
References: <4F78AD0A.7070904@gmail.com>
In-Reply-To: <4F78AD0A.7070904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hoppetauet <hoppetauet@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-01 12:31, Hoppetauet wrote:
> Hello
> 
> I'm running some benchmarks on virtual machines
> I made a script that runs fio N times, with the following job file
> 
> [seqwrite]
> rw=write
> size=${SIZE}
> directory=${DIRECTORY}
> bs=${BS}
> overwrite=1
> refill_buffers
> 
> The first run gives about 30MB/s, which is what dd tells me is correct 
> for the disk at hand
> however, from the second to last runs, I get about double that, which 
> suggests some sort of caching effect
> 
> Is the data that's written to the file not random? I thought 
> refill-buffers and overwrite would ensure that

It is completely random data, and it's reseeded for every run. So with
the above job, there shouldn't be any chance to de-dupe or compress
anything. Maybe it's the layout? Fio defaults to using the same sequence
of random offsets everytime, to make a given run repeatable. You can set
randrepeat=0 to turn that off. That'll cause fio to random seedly the IO
offset generator as well, making the written patterns different from run
to run as well.

-- 
Jens Axboe

