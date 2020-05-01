Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 1 May 2020 17:47:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] zbd: bump ZBD_MAX_OPEN_ZONES
Message-ID: <20200501144702.GA15160@avx2>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <BY5PR04MB690069FD2724EB40CA9AC828E7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB690069FD2724EB40CA9AC828E7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, May 01, 2020 at 01:19:10AM +0000, Damien Le Moal wrote:
> On 2020/04/30 21:41, Alexey Dobriyan wrote:

> > -#define ZBD_MAX_OPEN_ZONES	128
> > +#define ZBD_MAX_OPEN_ZONES	4096
> >  
> >  /*
> >   * Zoned block device models.
> > 
> 
> Makes sense. ZNS will will need this.

Oh yeah :^) 128 opened zones doesn't cut it.

> Note: You did not send a cover letter for the series. Please add it for the next
> round.

There is no cover letter, fixes are really independent.

