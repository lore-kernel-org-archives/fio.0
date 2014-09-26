Return-Path: <axboe@kernel.dk>
Message-ID: <5425B9B7.2080003@kernel.dk>
Date: Fri, 26 Sep 2014 13:08:39 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: dedupe and replay
References: <CA+BkS8NvVNyj3KDy3UjtD2G0q-B3Ai7sdbqwRu_DafLQmKk37Q@mail.gmail.com>
In-Reply-To: <CA+BkS8NvVNyj3KDy3UjtD2G0q-B3Ai7sdbqwRu_DafLQmKk37Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Alket Memushaj <amemushaj@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 09/26/2014 12:30 PM, Alket Memushaj wrote:
> Hi,
> 
> I am playing with the dedupe option and while it works well under
> synthetic tests, it doesn't seem to work when replaying a trace.
> 
> My test jobs are simple:
> 
> fio --name=replay --ioengine=libaio --direct=1 --iodepth=32
> --read_iolog=/path/to/trace --dedupe_percentage=80

That should work, as far as I can tell, since we do the buffer fill
after the iolog retrieval has filled out an IO unit for us. Can you say
more about what doesn't appear to work?

> I understand that block sizes would be variable during a trace replay,
> but is it possible to specify a base block size and calculate dedupe
> based on that for blocks that are multiples of the base size?

Ah, that might be the key element here. Yes, the dedupe part might not
really work well for multiple write sizes. Nothing that inherently
prevents that from working, just didn't add that bit yet. Will do that.


-- 
Jens Axboe


