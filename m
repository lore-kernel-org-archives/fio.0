Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35752 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752536AbdE0IjT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 May 2017 04:39:19 -0400
Received: by mail-vk0-f48.google.com with SMTP id h16so14369454vkd.2
        for <fio@vger.kernel.org>; Sat, 27 May 2017 01:39:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DM5PR12MB1643E902C68ABB37FC033212F1FD0@DM5PR12MB1643.namprd12.prod.outlook.com>
References: <MWHPR12MB16488DDE399E6157B36217EEF1FF0@MWHPR12MB1648.namprd12.prod.outlook.com>
 <CALjAwxj-k_QPWp2ULyVSEScNQNgc-cBZMz38RC5R4HiEKRv0jw@mail.gmail.com> <DM5PR12MB1643E902C68ABB37FC033212F1FD0@DM5PR12MB1643.namprd12.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 27 May 2017 09:38:48 +0100
Message-ID: <CALjAwxgmtdndmdpD4-KO=VYmeJCB1K7g86mBRSL7UXO=A90=2w@mail.gmail.com>
Subject: Re: Running multiple jobs on a raw drive
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ratn, Prasun" <Prasun.Ratn@amd.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 27 May 2017 at 08:06, Ratn, Prasun <Prasun.Ratn@amd.com> wrote:
> Thanks!

You're welcome!

>> fio --rw=randwrite --bs=4k --filename=/dev/nvme0n1 --runtime=10
>> --direct=1 --ioengine=libaio --iodepth=4 --numjobs=2
>> --offset_increment=81920m --name=randomwrites
>>
>> (all the job parameters were global) or
>>
>> fio --rw=randwrite --bs=4k --name=randomwrites --filename=/dev/nvme0n1
>> --runtime=10 --direct=1 --ioengine=libaio --iodepth=4 --numjobs=2
>> --offset_increment=81920m
>>
>> (two parameters were global but achieving an identical effect)
>
> Just to clarify everything that follows '--name' is local, and rw, bs are
> global in the above example?

Correct - in the second example everything that follows --name is
local to the randomwrites job but as rw/bs precede any name they are
considered global.

-- 
Sitsofe | http://sucs.org/~sits/
