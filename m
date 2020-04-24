Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:52505 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgDXDK7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Apr 2020 23:10:59 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Don't benchmark with fio
Date: Fri, 24 Apr 2020 03:10:45 +0000
Message-ID: <BY5PR04MB690094E00580D5D1D90ADD4FE7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <CAK3+OmX5TX9KPw584_BT0u1Jb+roA=6_13pK5Ra8rwrcL5HecQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Seena Fallah <seenafallah@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/04/23 23:41, Seena Fallah wrote:=0A=
> Hi all.=0A=
> =0A=
> I'm trying to probe my file system with fio. I don't want to benchmark=0A=
> my file system. The only thing I want do is to for example write 100K=0A=
> file on a file system and then check how much IO does it take to write=0A=
> and the bandwidth and the runtime.=0A=
> The main thing I want is to just write that file size and don't bench on =
that.=0A=
> Can anyone help me which ioengine or which args should I use to do this p=
robe?=0A=
> =0A=
> Thanks.=0A=
> =0A=
=0A=
dd if=3D/dev/zero of=3D/path/to/your/file/to/write bs=3D100K count=3Di conv=
=3Dfsync=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

