Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43964 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2F1SMN convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 28 Jun 2012 14:12:13 -0400
Received: by obbuo13 with SMTP id uo13so3343989obb.19
        for <fio@vger.kernel.org>; Thu, 28 Jun 2012 11:12:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com>
References: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com>
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Thu, 28 Jun 2012 11:11:52 -0700
Message-ID: <CACiQ3FDhdC_yBZ2pSs5HsWD2nyh+FOEW_do24Xu9D4rQROQHRg@mail.gmail.com>
Subject: Re: Single HDD , 700MB/s ??
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Homer Li <01jay.ly@gmail.com>
Cc: fio@vger.kernel.org

This example brings up some interesting questions for me:

    [global]
    rw=3Dwrite
    ioengine=3Dsync
    size=3D100g
    numjobs=3D8
    nrfiles=3D2
    iodepth=3D128
    zero_buffers
    timeout=3D120
    direct=3D1
    [sdb]
    filename=3D/dev/sdb


Why use=EF=BF=BDzero_buffers instead of random when there is a possibility =
of
a layer optimizing the zero writes?

Does Iodepth make any difference with ioengine=3Dsync? Or is iodepth
just there for the other async tests?

In the above list, there is only one file listed (albeit a raw device).
Does it make any difference that that

    nrfiles=3D2

If there is just one file, and there are no offsets and the test is
sequential writes, then will all the jobs write to the same location
roughly at the same time? And in this case even with DIRECT, couldn't
the OS do some thing to optimize these writes?

I've had issues with "Direct=3D1" as well as the mounts in direct mode
where multiple readers still ran at caching speeds. =EF=BF=BDIt was like the
OS sees all these readers reading the same block and even with DIRECT
the OS still gives out the block in memory. Sort of make sense. But
when giving each reader an offset the speeds went down to reasonable.
I've changed all my multi user tests that use one file to use offsets
where the offsets are distributed throughout the file. (would be a
nice automatic option in fio).
I use one 8G file =EF=BF=BDin all my tests so I can just create one file, t=
he
longest step of the test, then reuse it with varying # of jobs. If it
was a file per job then to =EF=BF=BDhave the same effect =EF=BF=BDthe test =
would
create N files at 8G/N size which would cause the files to be be
recreated every time.

Also:

What's the difference between timeout vs runtime
timeout=3DtimeoutLimit run time to=EF=BF=BDtimeout=EF=BF=BDseconds.
runtime=3DintTerminate processing after the specified number of seconds.

- Kyle
dboptimizer.com

On Tue, Jun 26, 2012 at 7:56 PM, Homer Li <01jay.ly@gmail.com> wrote:
>
> Hello ,All;
>
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDWhen I used fio benchmark single H=
DD, =EF=BF=BDthe write speed could
> reached 700~800MB/s
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDThe HDD model is WD2002FYPS-18U1B0=
 , 7200rpm, 2TB
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDIn my raid config, there is only o=
ne HDD =EF=BF=BDin every Raid0
> group. like jbod.
>
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDAnd then, I modify numjobs=3D8 to =
numjobs=3D1. the benchmark
> result is ok , it 's about 100MB/s.
>
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDDoes any wrong in my fio config ?
>
>
> Raid controller: PERC 6/E (LSI SAS1068E)
> OS : CentOS 5.5 upgrade to 2.6.18-308.8.2.el5 x86_64
>
> # fio -v
> fio 2.0.7
>
>
> # cat /tmp/fio2.cfg
> [global]
> rw=3Dwrite
> ioengine=3Dsync
> size=3D100g
> numjobs=3D8
> bssplit=3D128k/20:256k/20:512k/20:1024k/40
> nrfiles=3D2
> iodepth=3D128
> lockmem=3D1g
> zero_buffers
> timeout=3D120
> direct=3D1
> thread
>
> [sdb]
> filename=3D/dev/sdb
>
> run
> #fio /tmp/fio2.cfg
>
>
> Run status group 0 (all jobs):
> =EF=BF=BDWRITE: io=3D68235MB, aggrb=3D582254KB/s, minb=3D72636KB/s, maxb=
=3D73052KB/s,
> mint=3D120001msec, maxt=3D120003msec
>
>
> #iostat -x 2
>
> Device: =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD rrqm/s =EF=BF=BD wrqm/s =
=EF=BF=BD r/s =EF=BF=BD w/s =EF=BF=BD =EF=BF=BDrMB/s =EF=BF=BD =EF=BF=BDwMB=
/s avgrq-sz
> avgqu-sz =EF=BF=BD await =EF=BF=BDsvctm =EF=BF=BD%util
> sdb =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 0.00 =EF=BF=BD =EF=BF=BD 0.00 =EF=BF=BD0.00 2399.50 =EF=BF=BD =EF=BF=BD 0.=
00 =EF=BF=BD 571.38
> 487.67 =EF=BF=BD =EF=BF=BD18.23 =EF=BF=BD =EF=BF=BD7.60 =EF=BF=BD 0.42 10=
0.05
>
> avg-cpu: =EF=BF=BD%user =EF=BF=BD %nice %system %iowait =EF=BF=BD%steal =
=EF=BF=BD %idle
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD 2.38 =EF=BF=BD =EF=BF=
=BD0.00 =EF=BF=BD =EF=BF=BD1.12 =EF=BF=BD 19.00 =EF=BF=BD =EF=BF=BD0.00 =EF=
=BF=BD 77.50
>
> Device: =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD rrqm/s =EF=BF=BD wrqm/s =
=EF=BF=BD r/s =EF=BF=BD w/s =EF=BF=BD =EF=BF=BDrMB/s =EF=BF=BD =EF=BF=BDwMB=
/s avgrq-sz
> avgqu-sz =EF=BF=BD await =EF=BF=BDsvctm =EF=BF=BD%util
> sdb =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 0.00 =EF=BF=BD =EF=BF=BD 0.00 =EF=BF=BD0.00 3231.00 =EF=BF=BD =EF=BF=BD 0.=
00 =EF=BF=BD 771.19
> 488.82 =EF=BF=BD =EF=BF=BD18.29 =EF=BF=BD =EF=BF=BD5.66 =EF=BF=BD 0.31 10=
0.05
>
> avg-cpu: =EF=BF=BD%user =EF=BF=BD %nice %system %iowait =EF=BF=BD%steal =
=EF=BF=BD %idle
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD 2.19 =EF=BF=BD =EF=BF=
=BD0.00 =EF=BF=BD =EF=BF=BD1.06 =EF=BF=BD 19.36 =EF=BF=BD =EF=BF=BD0.00 =EF=
=BF=BD 77.39
>
> Device: =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD rrqm/s =EF=BF=BD wrqm/s =
=EF=BF=BD r/s =EF=BF=BD w/s =EF=BF=BD =EF=BF=BDrMB/s =EF=BF=BD =EF=BF=BDwMB=
/s avgrq-sz
> avgqu-sz =EF=BF=BD await =EF=BF=BDsvctm =EF=BF=BD%util
> sdb =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 0.00 =EF=BF=BD =EF=BF=BD 0.00 =EF=BF=BD0.00 3212.00 =EF=BF=BD =EF=BF=BD 0.=
00 =EF=BF=BD 769.94
> 490.92 =EF=BF=BD =EF=BF=BD18.69 =EF=BF=BD =EF=BF=BD5.82 =EF=BF=BD 0.31 10=
0.05
>
> avg-cpu: =EF=BF=BD%user =EF=BF=BD %nice %system %iowait =EF=BF=BD%steal =
=EF=BF=BD %idle
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD 1.50 =EF=BF=BD =EF=BF=
=BD0.00 =EF=BF=BD =EF=BF=BD0.69 =EF=BF=BD 20.06 =EF=BF=BD =EF=BF=BD0.00 =EF=
=BF=BD 77.75
>
> Device: =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD rrqm/s =EF=BF=BD wrqm/s =
=EF=BF=BD r/s =EF=BF=BD w/s =EF=BF=BD =EF=BF=BDrMB/s =EF=BF=BD =EF=BF=BDwMB=
/s avgrq-sz
> avgqu-sz =EF=BF=BD await =EF=BF=BDsvctm =EF=BF=BD%util
> sdb =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 0.00 =EF=BF=BD =EF=BF=BD 0.00 =EF=BF=BD0.00 1937.50 =EF=BF=BD =EF=BF=BD 0.=
00 =EF=BF=BD 466.06
> 492.64 =EF=BF=BD =EF=BF=BD19.18 =EF=BF=BD =EF=BF=BD9.91 =EF=BF=BD 0.52 10=
0.05
>
> avg-cpu: =EF=BF=BD%user =EF=BF=BD %nice %system %iowait =EF=BF=BD%steal =
=EF=BF=BD %idle
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD 2.06 =EF=BF=BD =EF=BF=
=BD0.00 =EF=BF=BD =EF=BF=BD0.94 =EF=BF=BD 19.94 =EF=BF=BD =EF=BF=BD0.00 =EF=
=BF=BD 77.06
>
> Device: =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD rrqm/s =EF=BF=BD wrqm/s =
=EF=BF=BD r/s =EF=BF=BD w/s =EF=BF=BD =EF=BF=BDrMB/s =EF=BF=BD =EF=BF=BDwMB=
/s avgrq-sz
> avgqu-sz =EF=BF=BD await =EF=BF=BDsvctm =EF=BF=BD%util
> sdb =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 0.00 =EF=BF=BD =EF=BF=BD 0.00 =EF=BF=BD0.00 2789.00 =EF=BF=BD =EF=BF=BD 0.=
00 =EF=BF=BD 668.50
> 490.89 =EF=BF=BD =EF=BF=BD18.72 =EF=BF=BD =EF=BF=BD6.71 =EF=BF=BD 0.36 10=
0.05
>
>
>
>
> Here is my Raid controller config:
>
> this is sdb:
>
> DISK GROUP: 0
> Number of Spans: 1
> SPAN: 0
> Span Reference: 0x00
> Number of PDs: 1
> Number of VDs: 1
> Number of dedicated Hotspares: 0
> Virtual Drive Information:
> Virtual Drive: 0 (Target Id: 0)
> Name =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD:
> RAID Level =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD: Primary-0, =
Secondary-0, RAID Level Qualifier-0
> Size =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD: 1.818 TB
> State =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD : Optimal
> Stripe Size =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD : 64 KB
> Number Of Drives =EF=BF=BD =EF=BF=BD: 1
> Span Depth =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD: 1
> Default Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
> if Bad BBU
> Current Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
> if Bad BBU
> Access Policy =EF=BF=BD =EF=BF=BD =EF=BF=BD : Read/Write
> Disk Cache Policy =EF=BF=BD : Disk's Default
> Encryption Type =EF=BF=BD =EF=BF=BD : None
> Physical Disk Information:
> Physical Disk: 0
> Enclosure Device ID: 16
> Slot Number: 0
> Device Id: 31
> Sequence Number: 4
> Media Error Count: 0
> Other Error Count: 0
> Predictive Failure Count: 0
> Last Predictive Failure Event Seq Number: 0
> PD Type: SATA
> Raw Size: 1.819 TB [0xe8e088b0 Sectors]
> Non Coerced Size: 1.818 TB [0xe8d088b0 Sectors]
> Coerced Size: 1.818 TB [0xe8d00000 Sectors]
> Firmware state: Online, Spun Up
> SAS Address(0): 0x5a4badb20bf57f88
> Connected Port Number: 4(path0)
> Inquiry Data: =EF=BF=BD =EF=BF=BD =EF=BF=BDWD-WCAVY1070166WDC WD2002FYPS-=
18U1B0
> =EF=BF=BD 05.05G07
> FDE Capable: Not Capable
> FDE Enable: Disable
> Secured: Unsecured
> Locked: Unlocked
> Needs EKM Attention: No
> Foreign State: None
> Device Speed: Unknown
> Link Speed: Unknown
> Media Type: Hard Disk Device
>
> this is sdc :
>
> DISK GROUP: 1
> Number of Spans: 1
> SPAN: 0
> Span Reference: 0x01
> Number of PDs: 1
> Number of VDs: 1
> Number of dedicated Hotspares: 0
> Virtual Drive Information:
> Virtual Drive: 0 (Target Id: 1)
> Name =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD:
> RAID Level =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD: Primary-0, =
Secondary-0, RAID Level Qualifier-0
> Size =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD: 1.818 TB
> State =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD : Optimal
> Stripe Size =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD : 64 KB
> Number Of Drives =EF=BF=BD =EF=BF=BD: 1
> Span Depth =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD: 1
> Default Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
> if Bad BBU
> Current Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
> if Bad BBU
> Access Policy =EF=BF=BD =EF=BF=BD =EF=BF=BD : Read/Write
> Disk Cache Policy =EF=BF=BD : Disk's Default
> Encryption Type =EF=BF=BD =EF=BF=BD : None
> Physical Disk Information:
> Physical Disk: 0
> Enclosure Device ID: 16
> Slot Number: 1
> Device Id: 28
> Sequence Number: 4
> Media Error Count: 0
> Other Error Count: 0
> Predictive Failure Count: 0
> Last Predictive Failure Event Seq Number: 0
> PD Type: SATA
> Raw Size: 1.819 TB [0xe8e088b0 Sectors]
> Non Coerced Size: 1.818 TB [0xe8d088b0 Sectors]
> Coerced Size: 1.818 TB [0xe8d00000 Sectors]
> Firmware state: Online, Spun Up
> SAS Address(0): 0x5a4badb20bf57f87
> Connected Port Number: 4(path0)
> Inquiry Data: =EF=BF=BD =EF=BF=BD =EF=BF=BDWD-WCAVY1090906WDC WD2002FYPS-=
18U1B0
> =EF=BF=BD 05.05G07
> FDE Capable: Not Capable
> FDE Enable: Disable
> Secured: Unsecured
> Locked: Unlocked
> Needs EKM Attention: No
> Foreign State: None
> Device Speed: Unknown
> Link Speed: Unknown
> Media Type: Hard Disk Device
>
> .......................................................
>
>
>
>
> Best Regards
> HOmer Li
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html




--
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
