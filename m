Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Thu, 9 Apr 2020 20:14:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: fix sequential verify with max_open_zones=1
Message-ID: <20200409171401.GA3220@avx2>
References: <20200408221652.GA2592@avx2>
 <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Apr 09, 2020 at 01:58:13AM +0000, Damien Le Moal wrote:
> On 2020/04/09 7:16, Alexey Dobriyan wrote:
> > Sequential write with max_open_zones=1 has interesting (read: buggy)
> > interaction with verify=.

> > +				if (f->zbd_info->open_zones[i] == nz) {
> > +					zbd_close_zone(td, f, i);
> > +				}
> 
> nit: you do not need the {} brackets for the if here.

I started to use {} everywhere, it is less thinking that way.

> With the nits above fixed, this looks OK to me.
> 
> It would be good to add a test case for this to t/zbd/test-zbd-support. Can you
> send something please ?

I'll try. This needs a test with blktrace parsing and eveything.

