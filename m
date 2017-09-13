Return-Path: <axboe@kernel.dk>
Subject: Re: fio and total latency percentile
References: <53cbc635-d9a3-6ef3-3634-309db0fe03d5@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0c340072-33cc-2171-c149-1ef0b8f94fce@kernel.dk>
Date: Wed, 13 Sep 2017 16:59:03 -0600
MIME-Version: 1.0
In-Reply-To: <53cbc635-d9a3-6ef3-3634-309db0fe03d5@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dave Jiang <dave.jiang@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-ID: <fio@vger.kernel.org>

On 09/07/2017 01:59 PM, Dave Jiang wrote:
> Jens,
> fio can display completion latency percentages via the percentile_list
> parameter. I can get p90 and p99 numbers for clat via
> percentile_list=90:99. Is there a way to get the overall latency for
> percentile? I'm interested in the total latency measurements for p90 and
> p99 while doing some measurements on the persistent memory block driver
> and playing around using DMA engines for transfer.

If I understand correctly, you are using an IO engine that is async, and
you want the latency percentiles to reflect total IO time
(submission+completion), not just completion time?

We can't currently do that, but it'd be trivial to do with an option of
some sort. Currently the percentile enable option is clat_percentile,
and it defaults to on. We could have a lat_percentile option that, if
enabled, would change the reporting to being total IO time. IOW:

clat_percentile=1	Latency percentiles are completion latencies
lat_percentile=1	Latency percentiles are total IO time

and have them be mutually exclusive.

-- 
Jens Axboe


