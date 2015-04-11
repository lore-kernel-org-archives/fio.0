Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:32985 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbbDKDFP (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Apr 2015 23:05:15 -0400
Received: by wgin8 with SMTP id n8so33428470wgi.0
        for <fio@vger.kernel.org>; Fri, 10 Apr 2015 20:05:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjUF7R=GbynqFgj5-1D6F-133oQDXvqv5nPKQKaQ0k=yw@mail.gmail.com>
References: <CANt18PxHj5p6f9gXsuKCRDNXwgo_nW0MwD0wM6QbYENBtJd1ww@mail.gmail.com>
 <CALjAwxjUF7R=GbynqFgj5-1D6F-133oQDXvqv5nPKQKaQ0k=yw@mail.gmail.com>
From: Samuel Shapiro <samuel.sh79@gmail.com>
Date: Sat, 11 Apr 2015 06:04:53 +0300
Message-ID: <CANt18PyJoE7e-MqafAD=oYZfo5x0r2gwnvMsF7VXTE3=mwCm2A@mail.gmail.com>
Subject: Re: during fio scenario with verify=meta some jobs fails
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Well i guess it could be a good test for data integrity, so why not? :)

On Fri, Apr 10, 2015 at 9:29 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 8 April 2015 at 11:37, Samuel Shapiro <samuel.sh79@gmail.com> wrote:
>> Hi All,
>>
>> I'd recently started using fio for NAS FS tests, and it's really great
>> tool, as for loading system,
>> so for finding various protocols bugs. Thank You :)
>> One of the scenarios, I'm using is "fsx", that is slightly modified to
>> run with 16 jobs:
>>
>> ; This job file works pretty works similarly to running fsx-linux
>> ; with -r 4096 -w 4096 -Z -N 500000
>> [global]
>> verify=meta
>> verify_dump=1
>>
>> [fsx-file-job1]
>> directory=/mnt/FIO-some-mountpoint-to-NAS-01
>> ioengine=libaio
>> iodepth=256
>> rw=randrw
>> size=256k
>> bs=4k
>> norandommap
>
> ^^^ This allows the same block to be overwritten multiple times. Are
> you sure this is what you want?
>
> --
> Sitsofe | http://sucs.org/~sits/
