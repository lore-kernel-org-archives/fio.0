Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35968 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0KJG5G convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Nov 2010 01:57:06 -0500
Received: by wwd20 with SMTP id 20so236170wwd.1
        for <fio@vger.kernel.org>; Tue, 09 Nov 2010 22:57:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101109182801.GP15588@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de>
Date: Tue, 9 Nov 2010 23:57:04 -0700
Message-ID: <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
From: John Cagle <jcagle@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

Hi Sebastian,

Is your iSCSI target also in a virtual machine?  If so, maybe the
hypervisor (vmware? kvm?) is caching the 10GB volume that is being
used by the iSCSI target?

John

On Tue, Nov 9, 2010 at 11:28 AM, Sebastian Kayser <sebastian@skayser.de> wr=
ote:
> Greetings,
>
> running fio 1.41 randwrite, direct=3D1 tests on Ubuntu against an
> iSCSI-connected disk reports IOPS figures higher than I would expect, so
> now I am trying to understand what's going on. Any pointers or
> enlightenment appreciated, e.g. where's a caching effect that I am
> currently missing (and if there's one, how can I deactivate it)?
>
> Setup:
> * iSCSI storage exports a 10GB LUN which sits on a single 7.2K SATA disk =
[1]
> =EF=BF=BDStorage system write-cache is disabled (write-through)
> * Client: Ubuntu 8.04 (kernel 2.6.24-28) w/ open-iscsi, 512MB RAM
> * LUN mkfs.ext3'd and mounted on /mnt
> * fio is configured to operate in O_DIRECT, O_SYNC mode
> * Random write IOPS expected: <80
> * Random write IOPS observed: ~300 (confirmed in multiple runs)
>
> root@ubuntu-804-x64:~# df -h /mnt
> Filesystem =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDSiz=
e =EF=BF=BDUsed Avail Use% Mounted on
> /dev/sdb1 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD 9.7=
G =EF=BF=BD151M =EF=BF=BD9.1G =EF=BF=BD 2% /mnt
>
> root@ubuntu-804-x64:~# cat patterns.fio
> [global]
> size=3D9g
> runtime=3D120
> direct=3D1
> sync=3D1
>
> [mnt-randwrite]
> directory=3D/mnt
> rw=3Drandwrite
>
> root@ubuntu-804-x64:~# ./fio --section=3Dmnt-randwrite patterns.fio
> mnt-randwrite: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync=
, iodepth=3D1
> Starting 1 process
> mnt-randwrite: Laying out IO file(s) (1 file(s) / 9216MB)
> Jobs: 1 (f=3D1): [w] [100.0% done] [0K/1243K /s] [0/303 iops] [eta 00m:00=
s]
> mnt-randwrite: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D9398
> =EF=BF=BDwrite: io=3D126796KB, bw=3D1057KB/s, iops=3D264, runt=3D120010ms=
ec
> =EF=BF=BD =EF=BF=BDclat (usec): min=3D486, max=3D332821, avg=3D3782.24, s=
tdev=3D5744.57
> =EF=BF=BD =EF=BF=BDbw (KB/s) : min=3D =EF=BF=BD187, max=3D 1641, per=3D10=
0.27%, avg=3D1058.85, stdev=3D260.24
> =EF=BF=BDcpu =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD: usr=3D0.0=
2%, sys=3D0.19%, ctx=3D33866, majf=3D0, minf=3D241
> =EF=BF=BDIO depths =EF=BF=BD =EF=BF=BD: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD submit =EF=BF=BD =EF=BF=BD: 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD complete =EF=BF=BD: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD issued r/w: total=3D0/31699, short=3D0/0
> =EF=BF=BD =EF=BF=BD lat (usec): 500=3D0.35%, 750=3D11.91%, 1000=3D1.97%
> =EF=BF=BD =EF=BF=BD lat (msec): 2=3D4.43%, 4=3D66.01%, 10=3D9.15%, 20=3D4=
.74%, 50=3D1.36%
> =EF=BF=BD =EF=BF=BD lat (msec): 100=3D0.06%, 250=3D0.02%, 500=3D0.01%
>
> Run status group 0 (all jobs):
> =EF=BF=BDWRITE: io=3D126796KB, aggrb=3D1056KB/s, minb=3D1081KB/s, maxb=3D=
1081KB/s, mint=3D120010msec, maxt=3D120010msec
>
> Disk stats (read/write):
> =EF=BF=BDsdb: ios=3D2091/31879, merge=3D0/33, ticks=3D30360/118040, in_qu=
eue=3D143320, util=3D99.30%
>
>
> Unfortunately, this system as well as all the other Ubuntu systems which
> I currently have access to are virtual machines, so I can't simply
> compare the findings to a simple local disk.
>
> Sebastian
>
> [1] http://www.hitachigst.com/internal-drives/desktop/deskstar/deskstar-7=
k2000
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
>
