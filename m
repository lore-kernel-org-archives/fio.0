Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:32903 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgDXDPf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Apr 2020 23:15:35 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Don't benchmark with fio
Date: Fri, 24 Apr 2020 03:15:33 +0000
Message-ID: <BY5PR04MB6900531561ED9F8EDB35E9C2E7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <CAK3+OmX5TX9KPw584_BT0u1Jb+roA=6_13pK5Ra8rwrcL5HecQ@mail.gmail.com>
 <BY5PR04MB690094E00580D5D1D90ADD4FE7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Seena Fallah <seenafallah@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/04/24 12:11, Damien Le Moal wrote:=0A=
> On 2020/04/23 23:41, Seena Fallah wrote:=0A=
>> Hi all.=0A=
>>=0A=
>> I'm trying to probe my file system with fio. I don't want to benchmark=
=0A=
>> my file system. The only thing I want do is to for example write 100K=0A=
>> file on a file system and then check how much IO does it take to write=
=0A=
>> and the bandwidth and the runtime.=0A=
>> The main thing I want is to just write that file size and don't bench on=
 that.=0A=
>> Can anyone help me which ioengine or which args should I use to do this =
probe?=0A=
>>=0A=
>> Thanks.=0A=
>>=0A=
> =0A=
> dd if=3D/dev/zero of=3D/path/to/your/file/to/write bs=3D100K count=3Di co=
nv=3Dfsync=0A=
> =0A=
=0A=
Oops... Should be:=0A=
=0A=
dd if=3D/dev/zero of=3D/path/to/your/file/to/write bs=3D100K count=3D1 conv=
=3Dfsync=0A=
=0A=
obviously for 100K :)=0A=
=0A=
You will get the write bandwidth with this. For knowing how many IOs this t=
ake,=0A=
you will need to trace the kernel IO stack (blktrace). No way to know this=
=0A=
exactly from user space, that is, if by "IO" you mean "storage device comma=
nds".=0A=
If by "IO" you mean "system calls", then with the above command, it will be=
=0A=
exactly 1 "write()" call (use strace to see it).=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

