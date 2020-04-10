Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 10 Apr 2020 21:46:52 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: fix sequential verify with max_open_zones=1
Message-ID: <20200410184652.GA25219@avx2>
References: <20200408221652.GA2592@avx2>
 <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200409171401.GA3220@avx2>
 <BY5PR04MB6900D077D39EEAF4AE35809FE7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB6900D077D39EEAF4AE35809FE7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Apr 09, 2020 at 10:41:01PM +0000, Damien Le Moal wrote:
> On 2020/04/10 2:14, Alexey Dobriyan wrote:
> > On Thu, Apr 09, 2020 at 01:58:13AM +0000, Damien Le Moal wrote:

> >> It would be good to add a test case for this to t/zbd/test-zbd-support. Can you
> >> send something please ?
> > 
> > I'll try. This needs a test with blktrace parsing and eveything.
> 
> That sounds like an overkill.

I disagree. You want to see what is actually issued to the block device
in an independent way, not debug output of the same program.

> Can't we use the debug output (debug=zbd) for
> checking ? If that does not work, let's not add a test that complicates the test
> setup.

