Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50298 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2HQHYq (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Aug 2012 03:24:46 -0400
Received: by obbuo13 with SMTP id uo13so4897529obb.19
        for <fio@vger.kernel.org>; Fri, 17 Aug 2012 00:24:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502DE322.6040708@kernel.dk>
References: <CAJBj3vfcQYnAEtJkh7FKYGAaePtpGbkgVKDOJeBwQcz8WsgNRQ@mail.gmail.com>
	<502DE322.6040708@kernel.dk>
Date: Fri, 17 Aug 2012 00:24:45 -0700
Message-ID: <CAJBj3vcxeHqpBFhRhVQAsJb6y_LVD6egOXXsgSC=DM7__ses7A@mail.gmail.com>
Subject: Re: log_avg_msec does not work for BW or IOPS logs
From: John Williams <jwilliams4200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

On Thu, Aug 16, 2012 at 11:22 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/15/2012 05:55 AM, John Williams wrote:
>> I'm calling fio v2.0.8 from the command line in linux, and I wanted to
>> set the averaging time for the log data to 200msec. Here is the
>> command line I used:
>>
>> fio --name=SeqWrite --readwrite=write --bs=128K --iodepth=1
>> --ioengine=libaio --direct=1 --invalidate=1 --output=/tmp/fio_output
>> --write_bw_log=bw_seq128K --write_lat_log=lat_seq128K
>> --write_iops_log=iops_seq128K --log_avg_msec=200 --randrepeat=0
>> --norandommap --offset=0 --size=128035676160 --filename=/dev/sdaa
>>
>> But when I examined the logs that fio produced, the BW and the IOPS
>> logs had the default 500msec resolution. But the latency logs had my
>> requested 200msec resolution.
>>
>> Is this an fio bug, or did I misunderstand something?
>
> This is a bit confusing. Basically there are two time settings. One is
> for the statistics averaging, the other is when to make an entry in a
> log (if that is set). The default for IOPS and BW is to average over
> 500msec, regardless of logging times. So you would need to add
> --iopsavgtime=200 --bwavgtime=200 as well to get the desired behaviour.

Okay, thanks, that did the trick.

I suggest adding a sentence about that under the "log_avg_msec" entry
in the documentation. Currently it reads:

       log_avg_msec=int
              By default, fio will log an entry in the iops,  latency,  or  bw
              log  for  every IO that completes. When writing to the disk log,
              that can quickly grow to a very large size. Setting this  option
              makes  fio  average the each log entry over the specified period
              of time, reducing the resolution of the log.  Defaults to 0.


I suggest adding something like:

     In order to log bw and IOPS with other than the default 500msec
averaging time,
     it will also be necessary to set bwavgtime and iopsavgtime.
