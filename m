Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45493 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab2IETue (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Sep 2012 15:50:34 -0400
Received: by obbuo13 with SMTP id uo13so1027995obb.19
        for <fio@vger.kernel.org>; Wed, 05 Sep 2012 12:50:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <843E15216120C047928F6879B0E2D9240D6A24B4@SACEXCMBX02-PRD.hq.netapp.com>
References: <843E15216120C047928F6879B0E2D9240D6A24B4@SACEXCMBX02-PRD.hq.netapp.com>
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Wed, 5 Sep 2012 12:50:12 -0700
Message-ID: <CACiQ3FD_ry8NnzX+=OvpT8s=33+BOv_W=N-UjAthjuPmUBEPSA@mail.gmail.com>
Subject: Re: Using fio to mimicking Oracle workload pattern
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Why are you trying to reproduce the I/O patterns of Oracle? Is it to
test the performance of the back end storage for Oracle? If so what
criteria are you using to judge the performance?

I've been using fio to test the back end storage for Oracle. I've been
interested in the limits of the 3 main axis of Oracle I/O (and less in
the mix of the three)

   1.  8k random read  (index access etc)
   2.  1M sequential read (full table scans etc)
   3. 1-128K sequential write (redo writes)

The other types of I/O are

   *  8k random write which is done by DBWR but users don't typically
wait for these I/Os
   *  direct path write by users but this isn't a typical operation more ET

I put together tests for the main 3 types of I/Os each isolated (ie
not mixed at the same time). The tests are on github at:

https://github.com/khailey/fio_scripts

See the README.md for more info.

The tests are run by a shell script that runs fio in an array of
tests. There is a script to parse the data and summarize it as well as
an R script to graph the data.

I have new set of R scripts to post soon.

- Kyle

On Sun, Sep 2, 2012 at 7:50 AM, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
> Hi All,
>
>
> This is neto from Brazil
>
>
> How are you?
>
>
> I want to simulate some Oracle workload pattern using fio. I would like to
> do the following:
>
>
> Archive LOGS: I would like to create x number of different file sizes. I
> have tried the following, but I am not sure if this is right about filesize
> option.
>
> directory=/archive
> size=10g
> ioengine=libaio
> nrfiles=5
> iodepth=4
> rw=write
> filesize=500m
> direct=1
> threads=4
> numjobs=1
>
> Redo LOGS:  I have tried the following: sync I/O and block split (to
> simulate partial writes) - 60% 512 bytes and 40% 4096.
>
> directory=/redo
> size=1g
> ioengine=libaio
> nrfiles=5
> iodepth=4
> sync=1
> rw=write
> filesize=500m
> bssplit=512/60:4k/40
> direct=1
> numjobs=1
>
> FULL Table Scan: I have tried creating 3 files and read from them
> (randomly). I used ba=4096 to have block aligned and 1MB of block size (to
> simulate db_scattered_read).
>
> [tablescan]
> directory=/u109/oradata/fio
> nrfiles=3
> openfiles=3
> file_service_type=roundrobin
> size=1g
> iodepth=32
> ba=4k
> bs=1M
> rw=randread
> numjobs=2
>
>
> Could you please help to check if the above files are correct? If they
> are, how can I double check if everything is working as expected (on fio
> output)?
>
> Thank you very much
>
> neto--
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
