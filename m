Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30121 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhENBxv (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 May 2021 21:53:51 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Help on how to specify LBA in Fio
Date: Fri, 14 May 2021 01:52:38 +0000
Message-ID: <DM6PR04MB708162B68D43093FCF5EB10BE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <ECDC56C0-4386-42E1-A6D5-829D4A4DC7D8@163.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: =?iso-2022-jp?B?GyRCPH5MKRsoQg==?= <mfpnzwm@163.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2021/05/14 2:36, =1B$B<~L)=1B(B wrote:=0A=
> Help on how to specify LBA in Fio=0A=
> =0A=
> Samuel=0A=
> =0A=
=0A=
fio uses Byte as the unit for specifying offset, size, IO size, block size =
etc.=0A=
So just multiply your LBA values by your device LBA size and you will have =
LBA=0A=
aligned byte values you can pass to fio.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

