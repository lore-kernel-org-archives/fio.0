Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35866 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932101AbdBGWDb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2017 17:03:31 -0500
Received: by mail-vk0-f52.google.com with SMTP id t8so88141282vke.3
        for <fio@vger.kernel.org>; Tue, 07 Feb 2017 14:03:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxg_So5yM+yOr_=UtoR0229owHzR7-ftKdWhYpdecCWySg@mail.gmail.com>
References: <B0E32160-C38E-4CDF-BBEF-B8259D99016E@ibr.cs.tu-bs.de> <CALjAwxg_So5yM+yOr_=UtoR0229owHzR7-ftKdWhYpdecCWySg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 7 Feb 2017 22:02:59 +0000
Message-ID: <CALjAwxjdUSyBJh7uWcwRLECkjr4UEyamd1cTLaV6YqvJuHiapw@mail.gmail.com>
Subject: Re: Differences in "BW" and "bw" results
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Frank Steinberg <steinberg@ibr.cs.tu-bs.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

The original reply had a few errors:

On 7 February 2017 at 16:37, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 3 February 2017 at 16:57, Frank Steinberg <steinberg@ibr.cs.tu-bs.de> wrote:
>>
>> local-libaio-read-4k: (groupid=0, jobs=1): err= 0: pid=13599: Fri Feb  3 17:26:41 2017
>>    read: IOPS=23.5k, BW=91.5MiB/s (95.9MB/s)(1189MiB/13001msec)
> [...]
>>    bw (  KiB/s): min= 3871, max=2048000, per=0.13%, avg=128690.23, stdev=16014.17
> [...]
>> The bandwidth numbers on the "read: ..." line and close to the bottom claim that I measured a total average bandwidth of 91.5 MiB/s. That seems reasonable.
>>
>> But there is also a "bw" section that claims an avg of 128690.23 KiB/s. What is the difference between these numbers?
>>
>> When I modify iodepth or numjobs parameters, the discrepancy changes, e.g. with iodepth=8 the first number goes up to 278 MiB/s, while the "bw" number goes down to 42921.43 KiB/s.
>
> BW is an average per second. bw is an average of averages...
>
> BW is calculated by summing all the I/O you did (1189MiB) and dividing
> by time in seconds so (1189*1024.0)/(13001/1000.0)/1024 ~ 91.5
>
> bw is calculated by summing all the "values" in the bw log and
> dividing by the number of those values. Each value is itself some sort
> of average but you don't know what period it is over. This can lead to
> a big discrepancy.
>
> Imagine I have a job that run for two seconds. In the first second 10
> MBytes is done over two I/Os. In the second second 100MByte is done
> over two I/Os. BW will be
> 120 / 2 = 60MBytes/s. However imagine the bw values are like this
> 0. 10240, 0, 0
> 0, 10240, 0, 1024
> 1, 102400, 0, 2048
> 1, 102400, 0, 3072

By default write_bw_log logs per each I/O. It's going to be tough to
reach speeds of 100MBytes/s with only a few I/Os so let's ratchet the
numbers down to 1KByte/s and 4KBytes. Also the first column is
milliseconds so we need larger numbers there.

Imagine we do 1KByte/s in the first second and 2KByte/s in the second.
Also imagine we have a fixed block size of 512 bytes.

0. 1100, 0, 512
1, 1100, 0, 512
1000, 1100, 0, 512
1250, 1100, 0, 512
1500, 1100, 0, 512
1990, 1100, 0, 512

The last column gives us the size of each I/O done so 512 * 6 is the
total bytes we did and we were going for two seconds so: 512 * 6  / 2
= 1536 making the BW the job achieved 1.5KByte/s. On the other hand
each individual I/O is reporting a bandwidth of 1100KBytes/s but for
whatever reason in the first second we only managed to do two 512Byte
I/Os and in the second we manage 4 (perhaps there's throttling in
place which means they process fast but have big spaces between them).
1100 * 6 / 6 = 1100 KBytes/s so bw is 1100 KByte/s - radically
different from BW.

With a higher iodepth perhaps each individual I/O finishes slower
making per I/O average bandwidth (bw) go down but so many complete in
parallel that the total bandwidth achieved (BW) goes up.

-- 
Sitsofe | http://sucs.org/~sits/
