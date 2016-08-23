Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:32898 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbcHWBGS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 Aug 2016 21:06:18 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1bc0A1-0004jO-8q
        for fio@vger.kernel.org; Tue, 23 Aug 2016 03:05:49 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: multiple entries for each second for bw/iop/xlat log files
Date: Mon, 22 Aug 2016 20:05:43 -0500
Message-ID: <npg7h5$g81$1@blaine.gmane.org>
References: <npf9p3$6e3$1@blaine.gmane.org> <caf6faa7-9584-724c-2c5b-a6fb1a2af441@kernel.dk> <npfodt$uqa$1@blaine.gmane.org> <CAJ9yE1AnR2s_c8iheFdMsOCk9D5wD+AqPR5CuyXsTJtZtQribw@mail.gmail.com> <npfq5d$74n$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I tried it again with different block sizes and the iop values in the 
second column don't change.  Am I misinterpreting the point of the IOP 
log file?Was hoping to be able graph the iop data similar to the 
latency and bw logs

479999, 1, 0, 131072
479999, 1, 0, 131072
479999, 1, 0, 8192
479999, 1, 0, 16896
479999, 1, 0, 131072
479999, 1, 0, 4096
479999, 1, 0, 131072
479999, 1, 0, 512
479999, 1, 0, 8192
479999, 1, 0, 131072
479999, 1, 0, 4096
479999, 1, 0, 8192
479999, 1, 0, 131072
479999, 1, 0, 131072
479999, 1, 0, 8192
479999, 1, 0, 4096
479999, 1, 0, 4096
479999, 1, 0, 4096
479999, 1, 0, 131072
479999, 1, 0, 131072
479999, 1, 0, 8192
479999, 1, 0, 8192
479999, 1, 0, 4096
479999, 1, 0, 8192
479999, 1, 0, 4096
479999, 1, 0, 131072
479999, 1, 0, 512
479999, 1, 0, 8192
479999, 1, 0, 131072
479999, 1, 0, 4096
479999, 1, 0, 8192
479999, 1, 0, 8192
479999, 1, 0, 131072
479999, 1, 0, 4096
479999, 1, 0, 512
479999, 1, 0, 8192
479999, 1, 0, 4096
480000, 1, 0, 8192
On 2016-08-22 21:17:35 +0000, Saeed said:

> Why are there duplicate entries for a time interval in the log file and 
> the iop log file shows '1' iop througout
> the entire file.  This doesn't seem right since fio reports up to 100K 
> iops in the summary:
> 
> write: (groupid=0, jobs=1): err= 0: pid=12012: Mon Aug 22 20:25:25 2016
>   write: io=11245MB, bw=95956KB/s, iops=23988, runt=120001msec
>     slat (usec): min=7, max=31939, avg=38.82, stdev=41.96
>     clat (usec): min=0, max=18067, avg= 0.65, stdev=10.68
>      lat (usec): min=7, max=31950, avg=39.86, stdev=43.63



