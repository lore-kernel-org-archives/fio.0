Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:32885 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbbDKGK1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 11 Apr 2015 02:10:27 -0400
Received: by layy10 with SMTP id y10so26499660lay.0
        for <fio@vger.kernel.org>; Fri, 10 Apr 2015 23:10:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANt18PyJoE7e-MqafAD=oYZfo5x0r2gwnvMsF7VXTE3=mwCm2A@mail.gmail.com>
References: <CANt18PxHj5p6f9gXsuKCRDNXwgo_nW0MwD0wM6QbYENBtJd1ww@mail.gmail.com>
	<CALjAwxjUF7R=GbynqFgj5-1D6F-133oQDXvqv5nPKQKaQ0k=yw@mail.gmail.com>
	<CANt18PyJoE7e-MqafAD=oYZfo5x0r2gwnvMsF7VXTE3=mwCm2A@mail.gmail.com>
Date: Sat, 11 Apr 2015 07:10:25 +0100
Message-ID: <CALjAwxiEv6jd5GuRC2rQsdaiGWZmku_tzS0-qQbQxe_RvVAT=A@mail.gmail.com>
Subject: Re: during fio scenario with verify=meta some jobs fails
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Samuel Shapiro <samuel.sh79@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 11 April 2015 at 04:04, Samuel Shapiro <samuel.sh79@gmail.com> wrote:
> Well i guess it could be a good test for data integrity, so why not? :)
>
> On Fri, Apr 10, 2015 at 9:29 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> On 8 April 2015 at 11:37, Samuel Shapiro <samuel.sh79@gmail.com> wrote:
>>> Hi All,
>>>
>>> [fsx-file-job1]
>>> directory=/mnt/FIO-some-mountpoint-to-NAS-01
>>> ioengine=libaio
>>> iodepth=256
>>> rw=randrw
>>> size=256k
>>> bs=4k
>>> norandommap
>>
>> ^^^ This allows the same block to be overwritten multiple times. Are
>> you sure this is what you want?

I could be wide of the mark but my concern would be that meta tries to
verify block number (I guess this doesn't need to be saved and can be
calculated by just following a sequence). If I've overwritten a block
how do I verify that the block number of the earlier write was correct
- the block will in fact contain the block number of the last write to
it...

-- 
Sitsofe | http://sucs.org/~sits/
