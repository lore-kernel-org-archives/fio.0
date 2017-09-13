Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53cbc635-d9a3-6ef3-3634-309db0fe03d5@intel.com>
References: <53cbc635-d9a3-6ef3-3634-309db0fe03d5@intel.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 13 Sep 2017 22:10:26 +0100
Message-ID: <CALjAwxg-gPKK2PMJJ32CZvk9T+uv7-zWddagHOhA=t7GSJ9JbQ@mail.gmail.com>
Subject: Re: fio and total latency percentile
Content-Type: text/plain; charset="UTF-8"
To: Vincent Fu <vincent.fu@wdc.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-ID: <fio@vger.kernel.org>

On 7 September 2017 at 20:59, Dave Jiang <dave.jiang@intel.com> wrote:
> Jens,
> fio can display completion latency percentages via the percentile_list
> parameter. I can get p90 and p99 numbers for clat via
> percentile_list=90:99. Is there a way to get the overall latency for
> percentile? I'm interested in the total latency measurements for p90 and
> p99 while doing some measurements on the persistent memory block driver
> and playing around using DMA engines for transfer.

Vincent, do you know if this is already possible?

-- 
Sitsofe | http://sucs.org/~sits/

