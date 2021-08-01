Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20295 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhHAWco (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Aug 2021 18:32:44 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Help on how to specify LBA in Fio
Date: Sun, 1 Aug 2021 22:31:54 +0000
Message-ID: <DM6PR04MB70818C78D2136B70E7A8C09EE7EE9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <ECDC56C0-4386-42E1-A6D5-829D4A4DC7D8@163.com>
 <DM6PR04MB708162B68D43093FCF5EB10BE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
 <304f5d56.15f5.17b01d09484.Coremail.mfpnzwm@163.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: =?iso-2022-jp?B?GyRCUHY8KzhKGyhC?= <mfpnzwm@163.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2021/08/01 22:04, =1B$BPv<+8J=1B(B wrote:=0A=
> Hi Damien,=0A=
> =0A=
> Thanks a lot.=0A=
> =0A=
> Regarding to LBA size, does it differ from HDD sector format=1B$B!)=1B(BT=
hat means=0A=
> 512e&4kn should use 4096 for capacity-LBA conversion while 512 for 512n?=
=0A=
=0A=
A LBA is the minimum access size possible on a block device. So all accesse=
s=0A=
should be aligned to the device LBA size. You can see the LBA size, and the=
=0A=
physical block size in sysfs:=0A=
=0A=
cat /sys/block/sdX/queue/logical_block_size=0A=
cat /sys/block/sdX/queue/physical_block_size=0A=
=0A=
=0A=
> =0A=
> Best regards,=0A=
> Samuel=0A=
> ---- Replied Message ----=0A=
> From	Damien Le Moal<damien.lemoal@wdc.com> <mailto:damien.lemoal@wdc.com>=
=0A=
> Date	05/14/2021 09:52=0A=
> To	=1B$B<~L)=1B(B<mfpnzwm@163.com> <mailto:mfpnzwm@163.com>,=0A=
> fio@vger.kernel.org<fio@vger.kernel.org> <mailto:fio@vger.kernel.org>=0A=
> Subject	Re: Help on how to specify LBA in Fio=0A=
> =0A=
> On 2021/05/14 2:36, =1B$B<~L)=1B(B wrote:=0A=
>> Help on how to specify LBA in Fio=0A=
>>=0A=
>> Samuel=0A=
>>=0A=
> =0A=
> fio uses Byte as the unit for specifying offset, size, IO size, block siz=
e etc.=0A=
> So just multiply your LBA values by your device LBA size and you will hav=
e LBA=0A=
> aligned byte values you can pass to fio.=0A=
> =0A=
> =0A=
> -- =0A=
> Damien Le Moal=0A=
> Western Digital Research=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

