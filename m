Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39742 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2HQGXF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Aug 2012 02:23:05 -0400
Message-ID: <502DE322.6040708@kernel.dk>
Date: Fri, 17 Aug 2012 08:22:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: log_avg_msec does not work for BW or IOPS logs
References: <CAJBj3vfcQYnAEtJkh7FKYGAaePtpGbkgVKDOJeBwQcz8WsgNRQ@mail.gmail.com>
In-Reply-To: <CAJBj3vfcQYnAEtJkh7FKYGAaePtpGbkgVKDOJeBwQcz8WsgNRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Williams <jwilliams4200@gmail.com>
Cc: fio@vger.kernel.org

On 08/15/2012 05:55 AM, John Williams wrote:
> I'm calling fio v2.0.8 from the command line in linux, and I wanted to
> set the averaging time for the log data to 200msec. Here is the
> command line I used:
> 
> fio --name=SeqWrite --readwrite=write --bs=128K --iodepth=1
> --ioengine=libaio --direct=1 --invalidate=1 --output=/tmp/fio_output
> --write_bw_log=bw_seq128K --write_lat_log=lat_seq128K
> --write_iops_log=iops_seq128K --log_avg_msec=200 --randrepeat=0
> --norandommap --offset=0 --size=128035676160 --filename=/dev/sdaa
> 
> But when I examined the logs that fio produced, the BW and the IOPS
> logs had the default 500msec resolution. But the latency logs had my
> requested 200msec resolution.
> 
> Is this an fio bug, or did I misunderstand something?

This is a bit confusing. Basically there are two time settings. One is
for the statistics averaging, the other is when to make an entry in a
log (if that is set). The default for IOPS and BW is to average over
500msec, regardless of logging times. So you would need to add
--iopsavgtime=200 --bwavgtime=200 as well to get the desired behaviour.

-- 
Jens Axboe

