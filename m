Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] zbd: fix sequential write pattern with verify= and
 max_open_zones=
References: <20200408221652.GA2592@avx2>
 <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200409171401.GA3220@avx2>
 <BY5PR04MB6900D077D39EEAF4AE35809FE7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <b6b09ff8-1149-c662-9838-35e61a7ce295@kernel.dk> <20200413185155.GA2347@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1b6d9d70-857a-b35b-5111-97818b6edb21@kernel.dk>
Date: Mon, 13 Apr 2020 17:18:50 -0600
MIME-Version: 1.0
In-Reply-To: <20200413185155.GA2347@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 4/13/20 12:51 PM, Alexey Dobriyan wrote:
> Sequential write with max_open_zones=1 has interesting (read: buggy)
> interaction with verify=.
> 
> If verify is off, then job runs correctly and IO is sequential,
> and restarted from offset 0 and remains sequential.
> 
> If verify is on, then 1 full run is done and verified correctly.
> At this point there is exactly 1 open zone which is the last zone.
> 
> Now IO restarts from offset 0 and pick_random_zone() picks opened zone
> #0 which is the last zone because offset is 0. All IO is redirected
> to the last zone, which is rewritten once triggering verify again.
> 
> IO pattern becomes: 1 full sequential rewrite followed by constant
> sequential rewrites of the last zone.
> 
> 
> 	[global]
> 	filename=/dev/loop0
> 	direct=1
> 	zonemode=zbd
> 	zonesize=1M
> 	bs=512K
> 	rw=write
> 	verify=xxhash
> 	[j]
> 	max_open_zones=1
> 	io_size=3G
> 
> Fix is to close every zone given that verification acts as a barrier
> between jobs.
> 
> max_open_zones=2 can restart from half of the device, etc.

Applied, thanks.

-- 
Jens Axboe


