Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:23843 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgIWBAz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Sep 2020 21:00:55 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Using fio for testing for SMR
Date: Wed, 23 Sep 2020 01:00:53 +0000
Message-ID: <CY4PR04MB37518ED1EB922E73588D33BAE7380@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
 <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
 <551yiHoBZ0368Set.1599573745@web08.cms.usa.net>
 <CY4PR04MB37513B33E7DFBDC3A4F94A08E7290@CY4PR04MB3751.namprd04.prod.outlook.com>
 <925yiLsTb8736Set.1599934827@web02.cms.usa.net>
 <CY4PR04MB3751C2D2477B316DE66AC058E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
 <893yisLUy8768Set.1600516044@web06.cms.usa.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "Ian S. Worthington" <ianworthington@usa.net>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/09/19 20:47, Ian S. Worthington wrote:=0A=
> Hi Damien --=0A=
> =0A=
> =0A=
>>> This tells us that the maximum size the device can support is 256KB=0A=
>>> (max_hw_sectors_kb)=0A=
>>> and the maximum size that the kernel allows is 256KB (max_sectors_kb). =
=0A=
>>=0A=
>> Which highly depends on the HBA since the hard-disk interface will accep=
t=0A=
> much=0A=
>> larger commands. This 256KB on your system seems to be very low. What HB=
A=0A=
> are=0A=
>> you using ? These days, most SAS HBAs have at least 128 or 256 segments,=
=0A=
> which=0A=
>> allow up to 512KB/1MB IOs. SATA/AHCI is limited at 169 segments for up t=
o=0A=
> 32MB=0A=
>> max_hw_sectors_kb (and 1280 KB max_sectors_kb).=0A=
>>=0A=
>>> Additionally, the DMA engine is limited to 2048 segments of IO, =0A=
>>> each with a max size of 64KB.=0A=
>>=0A=
>> That's a lot. I wonder why max_hw_sectors_kb end up so small.=0A=
> =0A=
> I'm trying a Raspberry Pi for this testing so only have a USB3 interface=
=0A=
> available.  Seems to be fast enough but maybe that's why it's giving numb=
ers=0A=
> that seem odd to you?=0A=
=0A=
Ah. OK. That explains it. USB is introducing the limitation on the number o=
f=0A=
segments here. That will result in a lot of command splits for large reads =
and=0A=
writes, but I do not think it matters much for the workloads you ran.=0A=
=0A=
Cheers.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

