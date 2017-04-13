Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:17046 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753889AbdDMP73 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Apr 2017 11:59:29 -0400
Subject: Fwd: RE: FIo version 2.1.8 with write_iops_log option doesn't work as
 expected
References: <001b01d2b403$1aa072b0$4fe15810$@citigo.com.vn>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <562d58d8-9c5c-3205-e624-df75b155c058@bluestop.org>
Date: Thu, 13 Apr 2017 09:59:27 -0600
MIME-Version: 1.0
In-Reply-To: <001b01d2b403$1aa072b0$4fe15810$@citigo.com.vn>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Son Chu <son.ct@citigo.com.vn>

I'm seeing the same thing on Linux and Windows. Can somebody help Son?

-------- Forwarded Message --------
Subject: 	RE: FIo version 2.1.8 with write_iops_log option doesn't work=20
as expected
Date: 	Thu, 13 Apr 2017 10:07:36 +0700
From: 	Son Chu <son.ct@citigo.com.vn>
To: 	'Rebecca Cran' <rebecca@bluestop.org>



Hi Rebecca,

So to get more detail, I will list what I did on both Linux and Windows=20
to let you see what is my issue:

-Linux Ubuntu 16.04:

oVersion

=EF=BF=BD2.2.10

oCommand

=EF=BF=BDfio --randrepeat=3D1 --ioengine=3Dlibaio --direct=3D1 --name=3Dtes=
t=20
--filename=3Dtest --bs=3D4k --iodepth=3D64 --size=3D100M --readwrite=3Drand=
rw=20
--rwmixread=3D75 --write_iops_log=3Drandrw

oOutput

=EF=BF=BD

-Windows Server 2012 R2:

oVersion

=EF=BF=BD2.1.8

oCommand

=EF=BF=BDfio.exe --randrepeat=3D1 --ioengine=3Dwindowsaio --direct=3D1 --na=
me=3Dtest=20
--filename=3Dtest --bs=3D4k --iodepth=3D64 --size=3D100M --readwrite=3Drand=
rw=20
--rwmixread=3D75 --write_iops_log=3Drandrw

oOutput

33, 1, 0, 4096

34, 1, 1, 4096

35, 1, 1, 4096

44, 1, 0, 4096

46, 1, 0, 4096

53, 1, 0, 4096

54, 1, 1, 4096

58, 1, 0, 4096

63, 1, 0, 4096

64, 1, 1, 4096

64, 1, 1, 4096

73, 1, 0, 4096

81, 1, 0, 4096

89, 1, 0, 4096

98, 1, 0, 4096

 From these result I wonder why the second column from Windows Server is=20
different from Linux???? It should be the IOPS like 844,289 from Linux=20
than 1 from Windows.

Can you help me on this please?

Thanks a lot in advance.

Regards,

Son

*From:*Rebecca Cran [mailto:rebecca@bluestop.org]
*Sent:* Wednesday, April 12, 2017 10:53 PM
*To:* Son Chu <son.ct@citigo.com.vn>
*Subject:* Re: FIo version 2.1.8 with write_iops_log option doesn't work=20
as expected

I'm seeing exactly the same on Linux. What commandline are you using there?

Rebecca

On 4/11/2017 10:28 PM, Son Chu wrote:

    Hi Rebecca,

    I am using FIO version 2.1.8 on Windows Server 2012 R2. When I was
    trying to write iops log with option write_iops_log follow this command:

    fio --directory=3DC\:\fio --ioengine=3Dwindowsaio --direct=3D1
    --name=3Drandwin --filename=3Drandwin --bs=3D4k --iodepth=3D16 --size=
=3D4G
    --readwrite=3Drandrw --rwmixread=3D75 --write_bw_log=3Drandwin
    --write_iops_log=3Drandwin --write_lat_log=3Drandwin --per_job_logs=3D0

    I got a log file with example content below:

    138, 1, 1, 4096

    138, 1, 1, 4096

    138, 1, 0, 4096

    139, 1, 0, 4096

    141, 1, 0, 4096

    143, 1, 0, 4096

    143, 1, 1, 4096

    145, 1, 0, 4096

    147, 1, 0, 4096

    147, 1, 1, 4096

    147, 1, 1, 4096

    149, 1, 0, 4096

    151, 1, 0, 4096

    152, 1, 0, 4096

    155, 1, 0, 4096

    158, 1, 0, 4096

    160, 1, 0, 4096

    162, 1, 0, 4096

    164, 1, 0, 4096

    165, 1, 0, 4096

    166, 1, 1, 4096

    166, 1, 1, 4096

    166, 1, 1, 4096

    167, 1, 1, 4096

    168, 1, 0, 4096

    I have wondered why the second colume was 1 (iops) instead of the expec=
ted iops per second (milisecond). If I used command with option: log_avg_ms=
ec=3D1000 then I got expected iops value. This is not like Linux.

     =20

    Can you please help on this?

     =20

    Sorry if this disturbs you.

     =20

    Thanks a lot in advance.

     =20

    Regards,

    Son

