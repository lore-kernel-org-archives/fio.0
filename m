Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:32994 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3JDSXS convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 4 Oct 2013 14:23:18 -0400
Received: by mail-lb0-f175.google.com with SMTP id y6so3540626lbh.6
        for <fio@vger.kernel.org>; Fri, 04 Oct 2013 11:23:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C8CA972100601A41AE302914E9CE1946C5BC2E64@NTXBOIMBX03.micron.com>
References: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
 <20131003204206.GA28048@highx.de> <CAAAK+WXf8okat6b91cxMZfYfSA5hEtH6et9pV_Eb=NPddOLVpA@mail.gmail.com>
 <C8CA972100601A41AE302914E9CE1946C5BC2E64@NTXBOIMBX03.micron.com>
From: "Brian L." <brianclam@gmail.com>
Date: Fri, 4 Oct 2013 11:22:56 -0700
Message-ID: <CAAAK+WWaEisodD-b0pFegk=1mw6LYVf3pSLyo31Qe9wCOkjssw@mail.gmail.com>
Subject: Re: precondition ssd drives w/ fio
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Jeffrey Mcvay (jmcvay)" <jmcvay@micron.com>
Cc: Juergen Salk <juergen.salk@gmx.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Oct 3, 2013 at 2:39 PM, Jeffrey Mcvay (jmcvay)
<jmcvay@micron.com> wrote:
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Brian L.
>> Sent: Thursday, October 03, 2013 2:09 PM
>> To: Juergen Salk; fio@vger.kernel.org
>> Subject: Re: precondition ssd drives w/ fio
>>
>> Thank you all for the response.  I found ssd-steadystate.fio in the
>> tarball.
>>
>> Brian
>>
>> Brian L.
>>
>>
>> On Thu, Oct 3, 2013 at 1:42 PM, Juergen Salk <juergen.salk@gmx.de>
>> wrote:
>> > * Brian L. <brianclam@gmail.com> [131003 12:31]:
>> >
>> >> For benchmarking SSD drives, I was told that we should precondition
>> >> our drives to get more accurate real world reading.
>> >>
>> >> I was wondering if anyone is using fio itself to precondition ssd
>> >> drives or use a different script to populate random data on the
>> >> drives?
>> >
>> > Yes I did. The fio source tarball comes with a number of sample
>> > job files including `ssd-steadystate.fio=EF=BF=BD, which might be
>> > useful for preconditioning of ssd devices.
>> >
>> > Regards,
>> >
>> > Juergen
>> >
>> > --
>> > GPG A997BA7A | 87FC DA31 5F00 C885 0DC3  E28F BD0D 4B33 A997 BA7A
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Brian,
>
> Check the SNIA standard for how to test SSD performance.
>
> There are quite likely more elegant solutions, but I use the jobfile belo=
w.  It is run sequential workloads of 100% write, 100% read, 100% write, an=
d finally 100% read. The purpose of the reads is to force any existing bad =
or marginal blocks out of the user pool. This will precondition the drive. =
Please be aware that using numjobs > 1 is may not be a sequential workload.
>
> To measure steady state values takes a little more effort. I use the writ=
e_bw_log feature, run for several hours, and use statistical  analysis to f=
ind the mean and standard deviation in the target time frame.
>
> Cheers,
> Jeff
>
> [global]
> thread
> group_reporting=3D1
> direct=3D1
> norandommap=3D1
> randrepeat=3D0
> refill_buffers
> ioengine=3D${IOENGINE}
> filename=3D${FILENAME}
>
> log_avg_msec=3D1000
>
> [128kB_SeqWr_1x8_1stPass]
> write_bw_log=3D128kB_SeqWr_1x8_1stPass
> bs=3D128k
> rw=3Dwrite
> numjobs=3D1
> iodepth=3D8
>
> [128kB_SeqRd_1x8_1ndPass]
> stonewall
> write_bw_log=3D128kB_SeqRd_1x8_1ndPass
> bs=3D128k
> rw=3Dread
> numjobs=3D1
> iodepth=3D8
>
>
> [128kB_SeqWr_1x8_2ndPass]
> stonewall
> write_bw_log=3D128kB_SeqWr_1x8_2ndPass
> bs=3D128k
> rw=3Dwrite
> numjobs=3D1
> iodepth=3D8
>
> [128kB_SeqRd_1x8_2ndPass]
> stonewall
> write_bw_log=3D128kB_SeqRd_1x8_2ndPass
> bs=3D128k
> rw=3Dread
> numjobs=3D1
> iodepth=3D8


thanks Jeffrey,

I think I am going to use your FIO template since the example
ssd-steadystate.fio (in the tarball) takes about 24 hr to run for each
drive because section [random-write-steady] runs over the entire
drive.   The drives I am testing range from 200GB up to 800GB.

That is way too long for me as I have 16 drives!  I have been testing
the drives at different rw profiles (also different blocksize and diff
iodepth at times).

I usually limit my run to size=3D10GB since I have so many drives that I
need to run against different profiles, blocksize, etc...  What is the
size (in GB) / time limit that that you guys generally run against
each drive for good results?



=3D=3D=3D
ssd-steadystate.fio template below
=3D=3D=3D

[global]
ioengine=3Dlibaio
direct=3D1
group_reporting=3D1
#filename=3D/dev/fioa
filename=3D${mydisk}

[sequential-fill]
description=3DSequential fill phase
rw=3Dwrite
iodepth=3D16
bs=3D1M

[random-write-steady]
stonewall
description=3DRandom write steady state phase
rw=3Drandwrite
bs=3D4K
iodepth=3D32
numjobs=3D4
#
# might need to fix var below
#
write_bw_log=3D${mydisk}-steady-state
