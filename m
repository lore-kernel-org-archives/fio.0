Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:49522 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3JDFoc convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 4 Oct 2013 01:44:32 -0400
Date: Fri, 4 Oct 2013 07:44:26 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <410685514.209431.1380865466474.JavaMail.root@thomas-krenn.com>
In-Reply-To: <C8CA972100601A41AE302914E9CE1946C5BC2E64@NTXBOIMBX03.micron.com>
Subject: Re: precondition ssd drives w/ fio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Jeffrey Mcvay (jmcvay)" <jmcvay@micron.com>
Cc: "Brian L." <brianclam@gmail.com>, Juergen Salk <juergen.salk@gmx.de>, fio@vger.kernel.org

---- Original Message -----
> From: "Jeffrey Mcvay (jmcvay)" <jmcvay@micron.com>
> To: "Brian L." <brianclam@gmail.com>, "Juergen Salk" <juergen.salk@gmx.de>, fio@vger.kernel.org
> Sent: Thursday, 3 October, 2013 11:39:32 PM
> Subject: RE: precondition ssd drives w/ fio
> 
> 
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org]
> > On
> > Behalf Of Brian L.
> > Sent: Thursday, October 03, 2013 2:09 PM
> > To: Juergen Salk; fio@vger.kernel.org
> > Subject: Re: precondition ssd drives w/ fio
> > 
> > Thank you all for the response.  I found ssd-steadystate.fio in the
> > tarball.
> > 
> > Brian
> > 
> > Brian L.
> > 
> > 
> > On Thu, Oct 3, 2013 at 1:42 PM, Juergen Salk <juergen.salk@gmx.de>
> > wrote:
> > > * Brian L. <brianclam@gmail.com> [131003 12:31]:
> > >
> > >> For benchmarking SSD drives, I was told that we should
> > >> precondition
> > >> our drives to get more accurate real world reading.
> > >>
> > >> I was wondering if anyone is using fio itself to precondition
> > >> ssd
> > >> drives or use a different script to populate random data on the
> > >> drives?
> > >
> > > Yes I did. The fio source tarball comes with a number of sample
> > > job files including `ssd-steadystate.fio´, which might be
> > > useful for preconditioning of ssd devices.
> > >
> > > Regards,
> > >
> > > Juergen
> > >
> > > --
> > > GPG A997BA7A | 87FC DA31 5F00 C885 0DC3  E28F BD0D 4B33 A997 BA7A
> > --
> > To unsubscribe from this list: send the line "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Brian,
> 
> Check the SNIA standard for how to test SSD performance.
> 
> There are quite likely more elegant solutions, but I use the jobfile
> below.  It is run sequential workloads of 100% write, 100% read,
> 100% write, and finally 100% read. The purpose of the reads is to
> force any existing bad or marginal blocks out of the user pool. This
> will precondition the drive. Please be aware that using numjobs > 1
> is may not be a sequential workload.
> 
> To measure steady state values takes a little more effort. I use the
> write_bw_log feature, run for several hours, and use statistical
>  analysis to find the mean and standard deviation in the target time
> frame.
> 
> Cheers,
> Jeff
> 
> [global]
> thread
> group_reporting=1
> direct=1
> norandommap=1
> randrepeat=0
> refill_buffers
> ioengine=${IOENGINE}
> filename=${FILENAME}
> 
> log_avg_msec=1000
> 
> [128kB_SeqWr_1x8_1stPass]
> write_bw_log=128kB_SeqWr_1x8_1stPass
> bs=128k
> rw=write
> numjobs=1
> iodepth=8
> 
> [128kB_SeqRd_1x8_1ndPass]
> stonewall
> write_bw_log=128kB_SeqRd_1x8_1ndPass
> bs=128k
> rw=read
> numjobs=1
> iodepth=8
> 
> 
> [128kB_SeqWr_1x8_2ndPass]
> stonewall
> write_bw_log=128kB_SeqWr_1x8_2ndPass
> bs=128k
> rw=write
> numjobs=1
> iodepth=8
> 
> [128kB_SeqRd_1x8_2ndPass]
> stonewall
> write_bw_log=128kB_SeqRd_1x8_2ndPass
> bs=128k
> rw=read
> numjobs=1
> iodepth=8

Hi Brian,
I have written a Performance Test Tool using Fio in Python implementing the Solid State Storage Performance Test Specification Enterprise v1.0 (http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.0.pdf).
The tool is Open Source, you can find it at http://git.thomas-krenn.com/TKperf_v1.git/ and some information in our wiki (http://www.thomas-krenn.com/de/wiki/TKperf - currently only in German).

Regards, Georg
--
: Georg Schönberger
: Research & Development Executive
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki


