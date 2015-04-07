Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:34071 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbbDGQmT (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Apr 2015 12:42:19 -0400
Received: by qcyk17 with SMTP id k17so23651516qcy.1
        for <fio@vger.kernel.org>; Tue, 07 Apr 2015 09:42:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGGT8x6z5vU+K=oQ3=R4s2N2xcq=aS5L+x42znaKzqxGjyE0=A@mail.gmail.com>
References: <CAGGT8x6z5vU+K=oQ3=R4s2N2xcq=aS5L+x42znaKzqxGjyE0=A@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 7 Apr 2015 11:41:38 -0500
Message-ID: <CAB-428mry6pAffQXn89ZdsTyMVZ0y4n-hgYzLnvgsNKCNvEzJg@mail.gmail.com>
Subject: Re: Latencies around 10 seconds for I/Os in a trace!!!
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Sounds like your wait statements are not correct. Referring to HOWTO.txt :

wait       Wait for 'offset' microseconds. Everything below 100 is discarded.


What kind of storage device do you have under /dev/sdb ?

On Tue, Apr 7, 2015 at 10:41 AM, Mansour Shafaei Moghaddam
<mansoor.shafaei@gmail.com> wrote:
> Hi all,
>
> I have made an I/O trace which includes "read", "write" and "wait" "
> commands. When I replay the trace with high I/O depths (for example
> 32) I see around 10s (!!!!) of latency for completion of 99% of reads
> and 6.5s latency for the writes. Does anyone know what exactly it
> means and what is wrong here?
> It is also notable that the average wait time between I/Os is around
> 14ms and its median is 8ms.
>
> Here is my job file:
>
> [global]
> ioengine=libaio
> direct=1
> iodepth=32
> log_offset=1
> read_iolog=temp
> write_bw_log=replay
> write_lat_log=replay
> write_iops_log=replay
> [job]
>
>
>
> and here is a part of my trace:
>
> fio version 2 iolog
> /dev/sdb add
> /dev/sdb open
> /dev/sdb wait 0 512
> /dev/sdb read 52321808896 36352
> /dev/sdb wait 89 512
> /dev/sdb read 52478476288 131072
> /dev/sdb wait 192 512
> /dev/sdb read 52499185664 131072
> /dev/sdb wait 208 512
>
> Thanks in advance
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
