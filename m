Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk1-f170.google.com ([209.85.222.170]:40828 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLQQb (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Feb 2020 11:16:31 -0500
Received: by mail-qk1-f170.google.com with SMTP id b7so2572923qkl.7
        for <fio@vger.kernel.org>; Wed, 12 Feb 2020 08:16:31 -0800 (PST)
MIME-Version: 1.0
From: "Fadhil I. Kurnia" <fadhilimamk@gmail.com>
Date: Wed, 12 Feb 2020 23:16:18 +0700
Message-ID: <CACqE_ei3XOOYokDPmHTDub2A9NPPmGSOSQw5+AmzOVp9n2UEvw@mail.gmail.com>
Subject: Undeterministic Results in RAID0 with rate_iops
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I just run an experiment in SSD RAID0, I am running a read I/O with
write noise in the background for 30 seconds.

I use numjobs=64 to simulate intense write noise. But I want to cap
the write noise to certain IOPS using `rate_iops` parameter. I know
that the rate_iops parameter capped the iops per job not the
cumulative iops from all the jobs.

But I found something unusual here,
when I set the write rate_iops=100k (a very large iops) the actual
iops reach 1066k, so I can assume that each job's iops is around
1066k/64 = 16657. The P99 read latency from this experiment is
162530us.

However, when I set the rate_iops=16657 with the same numjobs, the
cumulative iops is close to the previous measurement (1046k). But, the
P99 read latency is 68682us, way smaller than the previous
measurement.

I am expecting similar large read latencies from both measurements
since the cumulative write iops is the same, around 1050k. But the
results show the opposite.

Here is the jobfile for the first exp:
https://raw.githubusercontent.com/fadhilkurnia/research/master/v1-false/raid_test_100kwps.fio
here is the result from the first exp:
https://raw.githubusercontent.com/fadhilkurnia/research/master/v1-false/raid_test_100kwps.output
and here is the jobfile for the last exp:
https://raw.githubusercontent.com/fadhilkurnia/research/master/v2/raid_test_1066kwps.fio
result from the last exp:
https://raw.githubusercontent.com/fadhilkurnia/research/master/v2/raid_test_1066kwps.output

I don't fully understand how rate_iops works, so is this problem
related to it? or it is because I  set the rate too big?
and is there any explanation of why this happened?

