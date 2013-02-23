Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:38121 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3BWCYY (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Feb 2013 21:24:24 -0500
Received: by mail-da0-f42.google.com with SMTP id z17so631288dal.1
        for <fio@vger.kernel.org>; Fri, 22 Feb 2013 18:24:24 -0800 (PST)
Message-ID: <51282848.2060806@gmail.com>
Date: Sat, 23 Feb 2013 10:24:08 +0800
From: Peter Xu <xzpeter@gmail.com>
MIME-Version: 1.0
Subject: Re: Looping jobs from within the jobfile
References: <CANUChTyH7CxuKJMevxQpVu6d4M9bn17XUpshyjGEfsoHo6LQ9w@mail.gmail.com>
In-Reply-To: <CANUChTyH7CxuKJMevxQpVu6d4M9bn17XUpshyjGEfsoHo6LQ9w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

于 2013年02月22日 19:46, Gavin Martin 写道:
> Hi,
>
> I'm trying to understand the "loops" feature.
>
> I have jobfile that I would like to loop round a number of times:-
>
> {jobfile.fio}
> [global]
> ioengine=libaio
> direct=1
>
> [job1]
> rw=randrw
> rwmixread=70
> bsrange=4k-128k
> iodepth=4
> runtime=3m
> filename=/dev/sdm
> size=4G
> time_based
> offset=0
>
> [job2]
> stonewall
> rw=write
> bs=512K
> size=12G
> filename=/dev/sdm
> iodepth=1
> timeout=5m
> offset=20G
> {/jobfile.fio}
>
> So above I have a random read/write section followed by a sequential
> write section.  I would like to loop round this for x number of times,
> for example randrw, seqw, randrw, seqw, randrw, etc.  I've tried using
> the "loops=x" option in the global section, but all this does is loop
> each job before moving onto the next, at the moment it does randrw,
> randrw, seqw, seqw.
>
> Along with the above I was hoping that with the run status group
> report at the end of the run, it would give the average of each of
> those runs with the received min and max values:-
>
> Run status group 1 (all jobs):
>    WRITE: io=8192.0MB, aggrb=56333KB/s, minb=56333KB/s, maxb=56333KB/s,
> mint=148909msec, maxt=148909msec
>
> but at the moment the "minb" and "maxb" have the same values.  Ideally
> it would give the max and min values for each of those loops of that
> particular job, along with the average.
>
> Is this possible from within the jobfile?
>
> Thanks,
> Gavin
>
Hi, Martin,

I met the same problem with you, when I wanted to test performance for 
one 15K SAS drive. I wrote one tool myself, called it 'fiox', which is a 
simple fio wrapper that can support variables in normal fio 
configurations. I didn't plan to publish is since it's playtoy and only 
used by myself for once currently, but it might help in some way 
(hopefully).

https://github.com/xzpeter/fiox

I am also writting scripts to collect all the results into one .csv 
file, and plot it using Gnuplot in some user-friendly way.

Yours,
Peter
