Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgLESDU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Dec 2020 13:03:20 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B2BC094261
        for <fio@vger.kernel.org>; Sat,  5 Dec 2020 09:09:29 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id a3so9767310wmb.5
        for <fio@vger.kernel.org>; Sat, 05 Dec 2020 09:09:29 -0800 (PST)
Subject: Re: Fio verify crc32 fault
References: <0de8d04b-bcaa-415a-4587-c5bd7f674079@sabaini.at>
 <CALjAwxipZXaJ9z3WVJoukR=tt8OikcKDHDa5uCxuWQS_Y0Toag@mail.gmail.com>
 <BYAPR04MB5829B2725021733477C61A068FF10@BYAPR04MB5829.namprd04.prod.outlook.com>
From: Peter Sabaini <peter@sabaini.at>
Message-ID: <b97dd618-6641-7462-c9c6-bf96a4f0e76d@sabaini.at>
Date: Sat, 5 Dec 2020 18:09:25 +0100
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5829B2725021733477C61A068FF10@BYAPR04MB5829.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks both of you. I'll try reproducing this with a newer fio (it wasn't easy to repro to begin with though).

However reading the commit[0] and issue for serialize_overlap it seems not unlikely I'm indeed hitting this. 

[0] https://github.com/axboe/fio/commit/997b5680d139ce82c2034ba3a0d602cfd778b89b


On 04.12.20 18:01, Jeff Furlong wrote:
> After you update to the latest fio, also consider adding serialize_overlap=1 as a parameter (HOWTO has background there).  With large random writes, there is some probability (increasing with smaller device size and increasing with higher QD) that two inflight IO's conflict in range/time.  Suppose the first write is acknowledged by the device while the second conflicting write is already sent.  By the time fio reads the first command, the second write will change the data, causing verification errors.
> 
> Regards,
> Jeff
> 
> -----Original Message-----
> From: Sitsofe Wheeler <sitsofe@gmail.com> 
> Sent: Friday, December 4, 2020 6:42 AM
> To: Peter Sabaini <peter@sabaini.at>
> Cc: fio@vger.kernel.org
> Subject: Re: Fio verify crc32 fault
> 
> CAUTION: This email originated from outside of Western Digital. Do not click on links or open attachments unless you recognize the sender and know that the content is safe.
> 
> 
> Hi,
> 
> On Thu, 3 Dec 2020 at 17:27, Peter Sabaini <peter@sabaini.at> wrote:
>>
>> Hey,
>>
>> I've got a fio verify run on an NVMe that gives me a crc32 verification fault, however it's not reproducible -- when rerunning on the same NVMe it comes back fine.
>>
>> Also I'm getting a funny "error=Invalid or incomplete multibyte or wide character" error reported, see below.
>>
>> Any hints for this?
>>
>> Many thanks,
>> peter.
>>
>> Test output
>>
>> Running command: sudo -n fio --randrepeat=1 --ioengine=libaio 
>> --direct=1 --gtod_reduce=1 --name=fio_test_verify --bs=4M --iodepth=64 
>> --size=95% --verify=crc32c-intel --runtime=7200s 
>> --filename=/dev/nvme0n1 --readwrite=randwrite
>>
>> fio_test_verify: (g=0): rw=randwrite, bs=4M-4M/4M-4M/4M-4M, 
>> ioengine=libaio, iodepth=64
>> fio-2.2.10
> 
> ^^^ Your fio is VERY old... Does the same thing happen with a recent fio (see https://github.com/axboe/fio/releases for what we're up to)?
> 
> --
> Sitsofe | http://sucs.org/~sits/
> 


