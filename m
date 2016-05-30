Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33972 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161626AbcE3QwT convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 30 May 2016 12:52:19 -0400
Received: by mail-vk0-f44.google.com with SMTP id c189so228340201vkb.1
        for <fio@vger.kernel.org>; Mon, 30 May 2016 09:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANvN+en4j2JVHH3dBrJO4JXkbYKi=ZkiGFzPJGDEvN-QN7ow+w@mail.gmail.com>
References: <CAMy1HkEAccd5FwvUKpJMuaKtcGa_T18GXdivR06S8Ne7m0Qq=w@mail.gmail.com>
	<CANvN+en4j2JVHH3dBrJO4JXkbYKi=ZkiGFzPJGDEvN-QN7ow+w@mail.gmail.com>
Date: Mon, 30 May 2016 17:52:18 +0100
Message-ID: <CALjAwxh6mvd-Dvvo2sBnEaiWZZ9i3Yr3BOaMs15KyH+7EdV2vQ@mail.gmail.com>
Subject: Re: fio error when using direct=1
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nitin Mathur <nitinmathur@gmail.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 30 May 2016 at 17:36, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
> On Mon, May 30, 2016 at 6:34 PM, Nitin Mathur <nitinmathur@gmail.com> wrote:
>>
>>> ./fio --name=test_workld --ioengine=libaio --direct=1 --rw=randrw --norandommap --randrepeat=0 --rwmixread=40 --rwmixwrite=60 --iodepth=256 --size=100% --numjobs=4 --bssplit=512/4:64k/96 --random_distribution=zoned:50/5:50/95 --overwrite=1 --output=test_op --filename=/dev/nvme0n1 --group_reporting --runtime=1m --time_based
>>
>> This means, I'm using libaio, with a queue depth of 256, and fio is
>> utilizing asynchronous IO engines. But when i run this command, it
>> results into an error "Invalid argument". If i change the parameter
>> --direct=0, I'm able to issue the command successfully.
>>
>> Can you help me to understand, why with direct=1, the fio command
>> results in an error  ?
>
> Running your exact command, with a regular file substituted for your
> nvme device, works as expected (Ubuntu 15.10), see the below output.
> I'd suggest to double-check for issues with your hardware;  notice
> also that, by switching the direct mode off, you're enabling the I/O
> buffering in the kernel that might shadow a hardware issue.

Nitin - do you get a similar error if you use
./fio --name=test_workld --ioengine=libaio --direct=1
--filename=/dev/nvme0n1 --bs=512 --rw=read
and if so does the error go away with
./fio --name=test_workld --ioengine=libaio --direct=1
--filename=/dev/nvme0n1 --bs=4k --rw=read
? If so I would take a look at
/sys/block/nvme0n1/queue/logical_block_size as that represents the
smallest addressable size you can access the device with.

-- 
Sitsofe | http://sucs.org/~sits/
