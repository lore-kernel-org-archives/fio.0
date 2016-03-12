Return-Path: <vst@vlnb.net>
Message-ID: <56E379CC.1010000@vlnb.net>
Date: Fri, 11 Mar 2016 18:07:08 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Specify range and distribution of accesses
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com> <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com> <20160303161828.GC22164@kernel.dk> <20160303200446.GA2234@kernel.dk>
In-Reply-To: <20160303200446.GA2234@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe wrote on 03/03/2016 12:04 PM:
> Here's a patch that attempts to provide that. Basically it's a new
> setting for random_distribution, zoned. With zoned, you can give
> percentages like your original example. So to do the zone layout that
> you provided:
> 
> 1) 50% of accesses to first 5% of user LBA space (LBA group a)
> 2) 30% of accesses to next 15% of user LBA space (LBA group b)
> 3) 20% of accesses to remainder of user LBA space (LBA group c)
> 
> you would do:
> 
> random_distribution=zoned:50/5:30/15:20/

What is random distribution inside each zone? "Random"?

Wouldn't it be better to make zoning distribution a separate parameter and keep
random_distribution to specify random distribution inside zones?

For instance, Gauss distribution inside zones would be more realistic approximation to
real life cases, where usually there are both spacial and temporal locality.

Thanks,
Vlad


