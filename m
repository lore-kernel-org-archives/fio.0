Return-Path: <axboe@kernel.dk>
Subject: Re: random_generator=lfsr overhead with more disks?
References: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
 <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <512d2421-2399-07db-9ddf-b6776614bae4@kernel.dk>
Date: Wed, 21 Mar 2018 08:34:56 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, Michael Green <mishagreen@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/16/18 12:45 PM, Jeff Furlong wrote:
> A few comments:
> 
> -How does the cpu utilization look compared between the lfsr and
> default tausworthe generators?  Is the cpu util actually higher on
> lfsr?  If it is near saturated on 16 devices, then naturally
> throughput would decrease.

The LFSR generator is constant overhead, and it should not degrade as
more jobs are using it. There's no shared state at all.

If I were to guess, then the identical offsets of the jobs is probably a
likely clue, since that is the only real difference between the two
random generators. Are these 16 volumes all completely separate?

Finally, you are having 8 jobs all accessing the same 16 devices. You'll
likely get more consistent performance if you split things up a bit by
having 4 jobs, each doing IO to just two of the disks. This shouldn't
really be impacted by the random generator, but your current setup is
prone to performance fluctuations.

-- 
Jens Axboe


