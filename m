Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34738 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbcAOBu3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jan 2016 20:50:29 -0500
Received: by mail-qg0-f52.google.com with SMTP id 6so419536192qgy.1
        for <fio@vger.kernel.org>; Thu, 14 Jan 2016 17:50:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
References: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
Date: Thu, 14 Jan 2016 17:50:28 -0800
Message-ID: <CAF+0mvm1sr7AxL1=kFu5dofmOXb4kac=NX03deJ13gbkQrfSYA@mail.gmail.com>
Subject: Re: inflated bandwidth numbers with buffered I/O
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Jan 14, 2016 at 3:28 PM, Dallas Clement
<dallas.a.clement@gmail.com> wrote:
> Hi, I hope it's ok to ask usage questions on this mailing list.
>
> I have been using fio version 2.2.4 on a Fedora 22 server host to test
> throughput on a 10 GigE LIO iSCSI block device.  Up until this point I
> have been testing with Direct I/O (direct=1) and writing directly to
> the block device with filename=/dev/blah (no filesystem).  I am seeing
> bandwidth measurements that look reasonable.  I next tried to repeat
> this test with Buffered I/O (direct=0) and the bandwidth numbers are
> way too large.  Here is a comparison of the sequential write results
> for various block sizes:
>
> bs=4k => direct=95.945 MB/s, buffered=1475.4 MB/s
> bs=512 => direct=495.328 MB/s, buffered=2637.333 MB/s
> bs=2048 => direct=502.093 MB/s, buffered=2663.772 MB/s
>
> As you can see the buffered bandwidth measurements are much larger and
> don't make sense given that not more than 1200 MB/s can be transmitted
> over a 10 Gbps network connection.
>
> Now it's very likely I am doing something stupid and lack
> understanding about how fio works.  Someone please enlighten me!
>
> Here is the script I have been using to collect my results for buffered I/O
>
> #!/bin/bash
>
> JOB_FILE=job.fio
>
> cat << EOF > ${JOB_FILE}
> [job]
> ioengine=libaio
> iodepth=\${DEPTH}
> prio=0
> rw=\${RW}
> bs=\${BS}
> filename=/dev/sdc
> numjobs=1
> size=10g
> direct=0
> invalidate=0
> ramp_time=15
> runtime=120
> time_based
> write_bw_log=\${RW}-bs-\${BS}-depth-\${DEPTH}
> write_lat_log=\${RW}-bs-\${BS}-depth-\${DEPTH}
> write_iops_log=\${RW}-bs-\${BS}-depth-\${DEPTH}
> EOF
>
> for RW in read write randread randwrite
> do
>   for BS in 4k 512k 2048k
>   do
>     for DEPTH in 4 32 256
>     do
>       RW=${RW} BS=${BS} DEPTH=${DEPTH} fio ${JOB_FILE}
>     done
>   done
> done
>
> I have also tried running this script without the filename=blah
> setting on an XFS formatted block device.  I am still seeing inflated
> numbers for this also.
>
> Thanks,
>
> Dallas
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I don't have much experience in testing devices over the network but
you could try increasing size= or leave it out completely to use the
full device size and see how that affects your throughput.
