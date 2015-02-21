Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39832 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbBUJVA convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 21 Feb 2015 04:21:00 -0500
Received: by lbvn10 with SMTP id n10so10577230lbv.6
        for <fio@vger.kernel.org>; Sat, 21 Feb 2015 01:20:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
References: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
Date: Sat, 21 Feb 2015 09:20:59 +0000
Message-ID: <CALjAwxgWEZFHZNgpZvHgak4-bfQQqE9A9Gtu_e2JGcQ_xaovQA@mail.gmail.com>
Subject: Re: REPORT: High CPU utilization since 2.2.5
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 20 February 2015 at 23:10, Kudryavtsev, Andrey O
<andrey.o.kudryavtsev@intel.com> wrote:
> I’m running NVMe SSD benchmarks which are using multi-job configurations in the most common scenarios.
> I have noticed that since 2.2.5 release FIO has 3-4 times higher CPU utilization on the same workload, same system, same kernel 3.18.
> In fact I’m not able to achieve 450k IOPS on latest Core-i7 CPU due to 100% utilization.
> I tracked down the changes back, 2.1.14 is the most stable for me. Release had 2.2.0 the reporting issues, which were fixed in 2.2.5 but introduced high CPU utilization instead.
> Did anyone notice that too?

Where is the CPU usage going - userspace, device interrupts etc? If
it's vanishing into userspace does gtod_reduce=1 make any difference?
Does iostat confirm that you were getting more IOPs with the older
fio? What's the maximum number of requests reported by
/sys/block/<blockdevice>/queue/nr_requests ?

(PS buffered=0 and direct=1 are synonyms of each other and why runtime=0?)

-- 
Sitsofe | http://sucs.org/~sits/
