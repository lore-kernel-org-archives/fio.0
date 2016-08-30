Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38026 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755596AbcH3P2X (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Aug 2016 11:28:23 -0400
Received: by mail-wm0-f47.google.com with SMTP id o80so42206428wme.1
        for <fio@vger.kernel.org>; Tue, 30 Aug 2016 08:28:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABtFm2UabELu776EVnrwVUgrfeWcjkM=W1irhxF6L_o-QdTDLg@mail.gmail.com>
References: <CABtFm2WPnKVVBVPU0N97ipX=RTAVK7Tz0nJUNtAmS9chLw3nHw@mail.gmail.com>
 <56C4D7D4.4020904@kernel.dk> <CABtFm2UabELu776EVnrwVUgrfeWcjkM=W1irhxF6L_o-QdTDLg@mail.gmail.com>
From: Chris Worley <worleys@gmail.com>
Date: Tue, 30 Aug 2016 05:28:16 -1000
Message-ID: <CANWz5fhXDTu=zKLtHuoecVWcMzvditqs6AqHK-Y-RfsJscJ=GA@mail.gmail.com>
Subject: Re: client/server mode fails with Assertion `client->eta_in_flight =
 eta' failed
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Was there ever a solution?  I'm seeing this a lot on v2.9.

On Wed, Feb 17, 2016 at 6:30 PM, Srinivasa Chamarthy
<chamarthy.raju@gmail.com> wrote:
> Hi Jens,
>
> Job Files:
>
> Client1:
> # cat all_powerpath.fio
> [global]
> ioengine=libaio
> invalidate=1
> ramp_time=10
> direct=1
> refill_buffers=1
> time_based
> runtime=259200
>
> [readwrite-emcpowera-8k-para]
> bs=4k
> iodepth=8
> filename=/dev/emcpowera
> size=10g
> rw=randrw
>
> [readwrite-emcpowerb-8k-para]
> bs=4k
> iodepth=8
> filename=/dev/emcpowerb
> size=10g
> rw=randrw
>
> [readwrite-emcpowerc-8k-para]
> bs=4k
> iodepth=8
> filename=/dev/emcpowerc
> size=10g
> rw=randrw
>
> [readwrite-emcpowerd-8k-para]
> bs=4k
> iodepth=8
> filename=/dev/emcpowerd
> size=10g
> rw=randrw
>
> [readwrite-emcpowere-8k-para]
> bs=4k
> iodepth=8
> filename=/dev/emcpowere
> size=10g
> rw=randrw
>
> [readwrite-emcpowerf-8k-para]
> bs=4k
> iodepth=8
> filename=/dev/emcpowerf
> size=10g
> rw=randrw
>
> ...
> ... [Extends till /dev/emcpowerx -- 24 devices
>
> client2:
> # cat all_multipaths.fio q
>
>                                                   [112/2161]
> [global]
> ioengine=libaio
> invalidate=1
> ramp_time=10
> direct=1
> refill_buffers=1
> time_based
> runtime=259200
> norandommap
>
> [readwrite-mpatha-8k-para]
> bs=8k
> iodepth=8
> filename=/dev/mapper/mpatha
> size=10g
> rw=randrw
>
> [readwrite-mpathb-8k-para]
> bs=8k
> iodepth=8
> filename=/dev/mapper/mpathb
> size=10g
> rw=randrw
>
> [readwrite-mpathc-8k-para]
> bs=8k
> iodepth=8
> filename=/dev/mapper/mpathc
> size=10g
> rw=randrw
>
> [readwrite-mpathd-8k-para]
> bs=8k
> iodepth=8
> filename=/dev/mapper/mpathd
> size=10g
> rw=randrw
>
> [readwrite-mpathe-8k-para]
> bs=8k
> iodepth=8
> filename=/dev/mapper/mpathe
> size=10g
> rw=randrw
>
> [readwrite-mpathf-8k-para]
> bs=8k
> iodepth=8
> filename=/dev/mapper/mpathf
> size=10g
> rw=randrw
>
> [readwrite-mpathg-8k-para]
> bs=8k
> iodepth=8
> filename=/dev/mapper/mpathg
> size=10g
> rw=randrw
> ...
> ... [ Extends till /dev/mapper/mpathx --- 24 devices ]
>
> --
> Srinivasa R Chamarthy
>
>
> On Thu, Feb 18, 2016 at 4:28 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 02/16/2016 01:19 AM, Srinivasa Chamarthy wrote:
>>>
>>> I started FIO in client/server mode with two clients running 24 jobs
>>> each on individual LUNs. After a while, FIO fails with the following
>>> assertion, even though the jobs are still running on both the clients.
>>>
>>> # fio --client=client1 --remote-config=/root/all_powerpath.fio
>>> --client=client2 --remote-config=/root/all_multipaths.fio
>>> hostname=client1, be=0, 64-bit, os=Linux, arch=x86-64,
>>> fio=fio-2.6-13-g8a76, flags=1
>>> hostname=client2, be=0, 64-bit, os=Linux, arch=x86-64,
>>> fio=fio-2.6-13-g8a76, flags=1
>>>
>>> <client2> readwrite-mpatha-8k-para: (g=0): rw=randrw, <client1>
>>> readwrite-emcpowera-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
>>> bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
>>> ioengine=libaio, iodepth=8
>>> <client2> readwrite-mpathb-8k-para: (g=0): rw=randrw, <client1>
>>> readwrite-emcpowerb-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
>>> bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
>>> ioengine=libaio, iodepth=8
>>> <client2> readwrite-mpathc-8k-para: (g=0): rw=randrw, <client1>
>>> readwrite-emcpowerc-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
>>> bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
>>> ioengine=libaio, iodepth=8
>>> <client2> readwrite-mpathd-8k-para: (g=0): rw=randrw, <client1>
>>> readwrite-emcpowerd-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
>>> bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
>>> ioengine=libaio, iodepth=8
>>>
>>> <<< Omit other info >>>
>>>
>>> <client2> Starting 24 processes
>>> <client1> Starting 24 processes
>>>
>>> client <client1>: timeout on SEND_ETA/405.7M/0K /s] [51.2K/50.7K/0
>>> iops] [eta 02d:23h:59m:49s]
>>> fio: client: unable to find matching tag (dbebe0)2M/0K /s]
>>> [60.8K/58.6K/0 iops] [eta 02d:23h:59m:54s]
>>> fio: client.c:1241: handle_eta: Assertion `client->eta_in_flight == eta'
>>> failed.
>>> Aborted
>>>
>>> # fio --version
>>> fio-2.6-13-g8a76
>>>
>>> Also sometimes the job information gets mixed up from both the clients
>>> as above.
>>
>>
>> Can you include the job file(s) that you used?
>>
>> --
>> Jens Axboe
>>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
