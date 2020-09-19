Return-Path: <fio-owner@vger.kernel.org>
Received: from co03.mbox.net ([165.212.64.33]:44710 "EHLO co03.mbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgISLwq (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 19 Sep 2020 07:52:46 -0400
Date: Sat, 19 Sep 2020 12:47:24 +0100
From: "Ian S. Worthington" <ianworthington@usa.net>
Subject: Re: Using fio for testing for SMR
Mime-Version: 1.0
Message-ID: <893yisLUy8768Set.1600516044@web06.cms.usa.net>
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
 <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
 <551yiHoBZ0368Set.1599573745@web08.cms.usa.net>
 <CY4PR04MB37513B33E7DFBDC3A4F94A08E7290@CY4PR04MB3751.namprd04.prod.outlook.com>
 <925yiLsTb8736Set.1599934827@web02.cms.usa.net> 
 <CY4PR04MB3751C2D2477B316DE66AC058E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB3751C2D2477B316DE66AC058E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-Id: fio@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Damien --


> > This tells us that the maximum size the device can support is 256KB
> > (max_hw_sectors_kb)
> > and the maximum size that the kernel allows is 256KB (max_sectors_kb). 
> 
> Which highly depends on the HBA since the hard-disk interface will accept
much
> larger commands. This 256KB on your system seems to be very low. What HBA
are
> you using ? These days, most SAS HBAs have at least 128 or 256 segments,
which
> allow up to 512KB/1MB IOs. SATA/AHCI is limited at 169 segments for up to
32MB
> max_hw_sectors_kb (and 1280 KB max_sectors_kb).
> 
> > Additionally, the DMA engine is limited to 2048 segments of IO, 
> > each with a max size of 64KB.
> 
> That's a lot. I wonder why max_hw_sectors_kb end up so small.

I'm trying a Raspberry Pi for this testing so only have a USB3 interface
available.  Seems to be fast enough but maybe that's why it's giving numbers
that seem odd to you?


> The list of WD drives using SMR as drive-managed is published. See:
> 
> https://blog.westerndigital.com/wd-red-nas-drives/
> 
> and
> 
>
https://blog.westerndigital.com/wp-content/uploads/2020/07/WD_SMR_SKUs_vDS.pdf
> 
> Your drive is not on the list :)


I wasn't sure that the list was reliable when it came to white label drives,
but it's good to have it confirmed.

Many thanks!

Ian
...



