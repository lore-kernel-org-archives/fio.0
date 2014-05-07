Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:17174 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaEGIah convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 7 May 2014 04:30:37 -0400
Message-ID: <5369E886.1030100@enovance.com>
Date: Wed, 07 May 2014 10:02:14 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: Fio giving iops results that are equal to RAM speeds
References: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl>
In-Reply-To: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kim Holmebakken <kim.holmebakken@hotmail.com>
Cc: fio@vger.kernel.org


Le 07/05/2014 09:45, Kim Holmebakken a =EF=BF=BDcrit :
> Hey,
>
> Im currently working on a bachelor thesis where I need to measure iops=20
> on my storage solution.
>
> I have set up a "frontend" server(ubuntu server 13.10) which has zfs=20
> on linux running, and is connected to an iSCSI RAID(SAN).
>
> When I use this command:
>
> fio --directory=3D/pool  --size=3D128M --direct=3D0 --fallocate=3Dnone=20
> --rw=3Drandrw --refill_buffers --norandommap --randrepeat=3D0=20
> --ioengine=3Dsync --bs=3D4k --rwmixread=3D100 --iodepth=3D16 --numjobs=3D=
16=20
> --runtime=3D60 --group_reporting --name=3D4krandreadtest

[...]
> These values are extremly high and I suspect that these are the RAM=20
> speed being returned to me.
>
> Is there anyway to get a more realistic result?

You do cached IOs (as direct=3D0), only 128M of data and everything into a =

file. As a result, yes everything is getting into the host's cache.

If you want to determine the ISCSI performance byitself, I suggest not=20
using file but the block device and do direct IOs (direct=3D1).

If you want to keep your filesystem you have two options : enabling the=20
direct=3D1 and/or making IOs at twice the size of your host memory.

Hope this helps,
Erwan
