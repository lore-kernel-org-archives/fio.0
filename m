Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:33273 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752836AbdBGQiI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2017 11:38:08 -0500
Received: by mail-vk0-f53.google.com with SMTP id k127so81507169vke.0
        for <fio@vger.kernel.org>; Tue, 07 Feb 2017 08:38:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B0E32160-C38E-4CDF-BBEF-B8259D99016E@ibr.cs.tu-bs.de>
References: <B0E32160-C38E-4CDF-BBEF-B8259D99016E@ibr.cs.tu-bs.de>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 7 Feb 2017 16:37:37 +0000
Message-ID: <CALjAwxg_So5yM+yOr_=UtoR0229owHzR7-ftKdWhYpdecCWySg@mail.gmail.com>
Subject: Re: Differences in "BW" and "bw" results
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Frank Steinberg <steinberg@ibr.cs.tu-bs.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 3 February 2017 at 16:57, Frank Steinberg <steinberg@ibr.cs.tu-bs.de> wrote:
>
> local-libaio-read-4k: (groupid=0, jobs=1): err= 0: pid=13599: Fri Feb  3 17:26:41 2017
>    read: IOPS=23.5k, BW=91.5MiB/s (95.9MB/s)(1189MiB/13001msec)
[...]
>    bw (  KiB/s): min= 3871, max=2048000, per=0.13%, avg=128690.23, stdev=16014.17
[...]
> The bandwidth numbers on the "read: ..." line and close to the bottom claim that I measured a total average bandwidth of 91.5 MiB/s. That seems reasonable.
>
> But there is also a "bw" section that claims an avg of 128690.23 KiB/s. What is the difference between these numbers?
>
> When I modify iodepth or numjobs parameters, the discrepancy changes, e.g. with iodepth=8 the first number goes up to 278 MiB/s, while the "bw" number goes down to 42921.43 KiB/s.

BW is an average per second. bw is an average of averages...

BW is calculated by summing all the I/O you did (1189MiB) and dividing
by time in seconds so (1189*1024.0)/(13001/1000.0)/1024 ~ 91.5

bw is calculated by summing all the "values" in the bw log and
dividing by the number of those values. Each value is itself some sort
of average but you don't know what period it is over. This can lead to
a big discrepancy.

Imagine I have a job that run for two seconds. In the first second 10
MBytes is done over two I/Os. In the second second 100MByte is done
over two I/Os. BW will be
120 / 2 = 60MBytes/s. However imagine the bw values are like this
0. 10240, 0, 0
0, 10240, 0, 1024
1, 102400, 0, 2048
1, 102400, 0, 3072

(10240 * 2 + 102400 * 2)/4.0/1024.0 = 55.0

The period that each bw entry is being averaged over is not
necessarily known and if an entry is being averaged over time other
than a second the "average of averages" won't be per second either. I
wonder if that (  KiB/s) is actually misleading...

-- 
Sitsofe | http://sucs.org/~sits/
