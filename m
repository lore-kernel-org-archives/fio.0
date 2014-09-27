Return-Path: <axboe@kernel.dk>
Message-ID: <5426BF5C.9090301@kernel.dk>
Date: Sat, 27 Sep 2014 07:45:00 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: dedupe and replay
References: <CA+BkS8NvVNyj3KDy3UjtD2G0q-B3Ai7sdbqwRu_DafLQmKk37Q@mail.gmail.com>	<5425B9B7.2080003@kernel.dk>	<5425C0C7.8080303@kernel.dk> <CA+BkS8MZ+TC=itWx4DSpRdqewhRNkNqSem08Em2KWBXWJ4DJMg@mail.gmail.com>
In-Reply-To: <CA+BkS8MZ+TC=itWx4DSpRdqewhRNkNqSem08Em2KWBXWJ4DJMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Alket Memushaj <amemushaj@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 09/27/2014 05:19 AM, Alket Memushaj wrote:
> thanks for the quick response - but unfortunately this patch does not
> seem to have changed the result. I managed to get a 1.4:1 dedupe when
> setting dedupe_percentage to 99%. The test rig I have is like this: an
> array w/ inline dedupe @ 4K and I am the only user on it - I have a
> single machine mounting a single lun from the array (the whole space
> in the array is assigned to this lun). The synthetic test at
> dedupe_percentage=80 results in a 4:1 dedupe ratio from the array. The
> replay at 80% comes out as undedupable (ratio = 1.0:1) even with the
> latest patch. The replay generates about 1.7 million I/Os. ~1 million
> are 4K, 80 thousand are 8K, 70 thousand are 32K, etc... there's a
> decent number of I/O that is not a multiple of 4K, but the vast
> majority of the I/O is a multiple of 4K. The offset for each I/O is 4K
> aligned in the vast majority of I/Os.

(please don't top post)

I'll try with a trace replay here. If you can, would be nice to get your
trace.


-- 
Jens Axboe


