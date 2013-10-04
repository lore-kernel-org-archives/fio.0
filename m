Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34583 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3JDRfo convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 4 Oct 2013 13:35:44 -0400
Received: by mail-lb0-f173.google.com with SMTP id o14so3553379lbi.18
        for <fio@vger.kernel.org>; Fri, 04 Oct 2013 10:35:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <410685514.209431.1380865466474.JavaMail.root@thomas-krenn.com>
References: <C8CA972100601A41AE302914E9CE1946C5BC2E64@NTXBOIMBX03.micron.com> <410685514.209431.1380865466474.JavaMail.root@thomas-krenn.com>
From: "Brian L." <brianclam@gmail.com>
Date: Fri, 4 Oct 2013 10:35:22 -0700
Message-ID: <CAAAK+WVLnC2ZRA=m+KzuRi_ygX6e7sNd2F6w+guN6_=jowbfAQ@mail.gmail.com>
Subject: Re: precondition ssd drives w/ fio
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-1?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: "Jeffrey Mcvay (jmcvay)" <jmcvay@micron.com>, Juergen Salk <juergen.salk@gmx.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks Georg.  Just cloned your git repo.  I might play around with it
when I have some time.

Brian L.


On Thu, Oct 3, 2013 at 10:44 PM, Georg Sch=EF=BF=BDnberger
<gschoenberger@thomas-krenn.com> wrote:
> ---- Original Message -----
>> From: "Jeffrey Mcvay (jmcvay)" <jmcvay@micron.com>
>> To: "Brian L." <brianclam@gmail.com>, "Juergen Salk" <juergen.salk@gmx.d=
e>, fio@vger.kernel.org
>> Sent: Thursday, 3 October, 2013 11:39:32 PM
>> Subject: RE: precondition ssd drives w/ fio
>>
>>
>> > -----Original Message-----
>> > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org]
>> > On
>> > Behalf Of Brian L.
>> > Sent: Thursday, October 03, 2013 2:09 PM
>> > To: Juergen Salk; fio@vger.kernel.org
>> > Subject: Re: precondition ssd drives w/ fio
>> >
>> > Thank you all for the response.  I found ssd-steadystate.fio in the
>> > tarball.
>> >
>> > Brian
>> >
>> > Brian L.
>> >
>> >
>> > On Thu, Oct 3, 2013 at 1:42 PM, Juergen Salk <juergen.salk@gmx.de>
>> > wrote:
>> > > * Brian L. <brianclam@gmail.com> [131003 12:31]:
>> > >
>> > >> For benchmarking SSD drives, I was told that we should
>> > >> precondition
>> > >> our drives to get more accurate real world reading.
>> > >>
>> > >> I was wondering if anyone is using fio itself to precondition
>> > >> ssd
>> > >> drives or use a different script to populate random data on the
>> > >> drives?
>> > >
>> > > Yes I did. The fio source tarball comes with a number of sample
>> > > job files including `ssd-steadystate.fio=EF=BF=BD, which might be
>> > > useful for preconditioning of ssd devices.
>> > >
>> > > Regards,
>> > >
>> > > Juergen
>> > >
>> > > --
>> > > GPG A997BA7A | 87FC DA31 5F00 C885 0DC3  E28F BD0D 4B33 A997 BA7A
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe fio" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Brian,
>>
>> Check the SNIA standard for how to test SSD performance.
>>
>> There are quite likely more elegant solutions, but I use the jobfile
>> below.  It is run sequential workloads of 100% write, 100% read,
>> 100% write, and finally 100% read. The purpose of the reads is to
>> force any existing bad or marginal blocks out of the user pool. This
>> will precondition the drive. Please be aware that using numjobs > 1
>> is may not be a sequential workload.
>>
>> To measure steady state values takes a little more effort. I use the
>> write_bw_log feature, run for several hours, and use statistical
>>  analysis to find the mean and standard deviation in the target time
>> frame.
>>
>> Cheers,
>> Jeff
>>
>> [global]
>> thread
>> group_reporting=3D1
>> direct=3D1
>> norandommap=3D1
>> randrepeat=3D0
>> refill_buffers
>> ioengine=3D${IOENGINE}
>> filename=3D${FILENAME}
>>
>> log_avg_msec=3D1000
>>
>> [128kB_SeqWr_1x8_1stPass]
>> write_bw_log=3D128kB_SeqWr_1x8_1stPass
>> bs=3D128k
>> rw=3Dwrite
>> numjobs=3D1
>> iodepth=3D8
>>
>> [128kB_SeqRd_1x8_1ndPass]
>> stonewall
>> write_bw_log=3D128kB_SeqRd_1x8_1ndPass
>> bs=3D128k
>> rw=3Dread
>> numjobs=3D1
>> iodepth=3D8
>>
>>
>> [128kB_SeqWr_1x8_2ndPass]
>> stonewall
>> write_bw_log=3D128kB_SeqWr_1x8_2ndPass
>> bs=3D128k
>> rw=3Dwrite
>> numjobs=3D1
>> iodepth=3D8
>>
>> [128kB_SeqRd_1x8_2ndPass]
>> stonewall
>> write_bw_log=3D128kB_SeqRd_1x8_2ndPass
>> bs=3D128k
>> rw=3Dread
>> numjobs=3D1
>> iodepth=3D8
>
> Hi Brian,
> I have written a Performance Test Tool using Fio in Python implementing t=
he Solid State Storage Performance Test Specification Enterprise v1.0 (http=
://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.0.pdf).
> The tool is Open Source, you can find it at http://git.thomas-krenn.com/T=
Kperf_v1.git/ and some information in our wiki (http://www.thomas-krenn.com=
/de/wiki/TKperf - currently only in German).
>
> Regards, Georg
> --
> : Georg Sch=EF=BF=BDnberger
> : Research & Development Executive
> : Thomas-Krenn.AG | The server-experts
> : http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki
>
>
