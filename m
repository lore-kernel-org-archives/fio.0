Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:34759 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbeCGGBA (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Mar 2018 01:01:00 -0500
Received: by mail-vk0-f45.google.com with SMTP id z190so667895vkg.1
        for <fio@vger.kernel.org>; Tue, 06 Mar 2018 22:00:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com> <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Mar 2018 06:00:28 +0000
Message-ID: <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio <fio@vger.kernel.org>, Rob Scheepens <rob.scheepens@nutanix.com>, David Knierim <knierim@nutanix.com>

Hi Rob, David!

On 6 March 2018 at 20:01, Rebecca Cran <rebecca@bluestop.org> wrote:
> On 3/6/2018 9:35 AM, Sitsofe Wheeler wrote:
>>
>>
>> I tried out the python script but it seemed to be complaining about a
>> whitespace issue. After fixing that up it's unclear exactly what fio
>> command lines it runs. I think for others to dig in we'd need
>> something less fiddly like the raw fio command lines that generate the
>> hang. Is there any chance the mystery user could join the mailing list
>> so they can answer questions directly? Ideally we'd need a job that
>> works on files within a filesystem and ideally nice small files so it
>> could go into an AppVeyor job...
>>
>
> I've CC'd Rob and David.
> You can find the FIO command lines used by running the script in verbose
> mode: it lists them all at the start, then steps through them one by one.
> Unfortunately nobody's had any luck in narrowing down a single run that
> causes the hang.
> I forgot to say that the problem has been seen on FIO 3.1 - I never got
> around to trying it on version 3.5, which is now on https://bluestop.org/fio
> .

Rebecca has been explaining you've generated a reproducible hang on
Windows fio. Just for reference, can you check whether fio 3.5 also
reproduces the problem?

It looks like your python script generates fio lines which are based
off config lines similar to the following:

config: {'bs': 4096, 'filename': '\\\\.\\PhysicalDrive1', 'numjobs':
1, 'runtime': '20', 'iodepth': 1, 'dir': 'randread', 'size': '20G'}
config: {'bs': 16384, 'filename':
'\\\\.\\PhysicalDrive1:\\\\.\\PhysicalDrive2:\\\\.\\PhysicalDrive3:\\\\.\\PhysicalDrive4:\\\\.\\PhysicalDrive5:\\\\.\\PhysicalDrive6:\\\\.\\PhysicalDrive7:\\\\.\\PhysicalDrive8',
'numjobs': 240, 'runtime': '20', 'iodepth': 1, 'dir': 'randread',
'size': '20G'}
config: {'bs': 1048576, 'filename': '\\\\.\\PhysicalDrive1',
'numjobs': 30, 'runtime': '20', 'iodepth': 1, 'dir': 'randread',
'size': '20G'}

Is this correct? I'm afraid I'm not in a position where I can easily
debug this using the Python script on Windows (sadly I have no
interactive access to Windows machines at the moment) but a few things
might help to narrow down the problem:

How frequently is the script able to reproduce the problem?
Can you substitute files for disks and still reproduce the problem?
What are the minimum number of filenames involved when you've seen a
hang? Does it always need more than 1?
What's the smallest size that you can use that still reproduces the problem?
What's the smallest amount of numjobs that reproduce the problem? Does
it always need more than 1?

Ideally if we can get down to the stage where we run say only two fio
lines repeatedly in a bash script and make the problem happen it will
make it easier for others to see the problem too...

-- 
Sitsofe | http://sucs.org/~sits/
