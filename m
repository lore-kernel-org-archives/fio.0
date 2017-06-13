Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34528 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbdFMU6W (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Jun 2017 16:58:22 -0400
Received: by mail-ua0-f174.google.com with SMTP id m31so83232385uam.1
        for <fio@vger.kernel.org>; Tue, 13 Jun 2017 13:58:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A41AF6BF-E759-4C70-BC4B-4BEFEA0FA170@suse.com>
References: <27D739B2-8C23-4785-8A89-D27E91045796@suse.com> <A41AF6BF-E759-4C70-BC4B-4BEFEA0FA170@suse.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 13 Jun 2017 21:57:50 +0100
Message-ID: <CALjAwxgEO0=Wt7XtMLWUzs0AZWFSNX=R6a1SJ2G=TawxTZeKBA@mail.gmail.com>
Subject: Re: iops log is not capturing iops
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Byte <dbyte@suse.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 13 June 2017 at 15:04, David Byte <dbyte@suse.com> wrote:
>
>     I tried this with both 2.13 (the version that is available with SUSE Enterprise Storage and with a freshly built 2.20-53 that I built 12 hours ago.  Neither prints the actual iops value to the iops log.  Any clue as to where the problem lies?
>
>     Raw data follows.
>
>     linux:~/bench # ./fio --filename=/root/test.fil --size=1G --runtime=30 --rw=randwrite --write_iops_log=4kw3 --name=test
>     test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
>     fio-2.20-53-g85c7
>     Starting 1 process
>     Jobs: 1 (f=1): [w(1)][100.0%][r=0KiB/s,w=30.5MiB/s][r=0,w=7802 IOPS][eta 00m:00s]
>     test: (groupid=0, jobs=1): err= 0: pid=4362: Fri Jun  9 19:54:13 2017
>       write: IOPS=8563, BW=33.5MiB/s (35.1MB/s)(1004MiB/30001msec)
[...]

>     linux:~/bench # tail 4kw3_iops.1.log
>     29986, 1, 1, 4096
>     29986, 1, 1, 4096
>     29986, 1, 1, 4096
>     29986, 1, 1, 4096

That looks like it's printing logging information for each individual I/O
rather than averaging them over a given period (so you've gained
precision but you'd have to post process the result to work out the
IOPS). In fact this looks like a similar question to that of another
SUSE engineer (who was looking at Ceph) over on
https://github.com/axboe/fio/issues/337 ...

Just to check, have you seen the log_avg_msec option
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-log-avg-msec
) and are you aware it defaults to 0?

-- 
Sitsofe | http://sucs.org/~sits/
