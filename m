Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr10101.outbound.protection.outlook.com ([40.107.1.101]:44177
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231476AbhHRMC6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Aug 2021 08:02:58 -0400
Subject: Re: Guidance to learn more about fio tool
References: <CAPJkFLYrwOx+fdSLPij8eqF09wZ7nfTS3m-7UCce8_Y0ZRHBXA@mail.gmail.com>
From: Erwan Velu <e.velu@criteo.com>
Message-ID: <a90d805b-29a9-2454-28de-60340a36559a@criteo.com>
Date: Wed, 18 Aug 2021 14:02:20 +0200
In-Reply-To: <CAPJkFLYrwOx+fdSLPij8eqF09wZ7nfTS3m-7UCce8_Y0ZRHBXA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: CED17I048 SJ HARINI <ced17i048@iiitdm.ac.in>, fio@vger.kernel.org


Le 31/07/2021 à 11:39, CED17I048 SJ HARINI a écrit :
> Hi,
> [...]
Good to see new comers.
>
> What have I done so far to understand the tool and the source code better:
> 1) Tried running  fio (installed using : sudo apt-get install fio)
> from command line (ubuntu) with --debug=all.
>      A lot of log information was printed in the terminal.
> 2) Cloned the source code from github fio repository. Installed
> sourcetrail and indexed all the files in fio-master. But there were
> many errors while indexing the files, so the visualization was
> somewhat incomplete. In case anyone has tried using sourcetrail, would
> love to know your experience.
I never used it sorry. I'm using atom or vim directly on the source tree.
> 3) Tried running many test jobs using fio.
> 4) Read up various resources available online about using fio and
> understanding its output.

That's a good start !


>
> Some doubts:
> 1) To understand the underlying logic about how the tool works, what
> concepts should I learn about prior? - From my reading about the fio
> tool, I came across AIO engine, nvme and learned that the hard
> disk/storage device also contains a hardware cache. So sometimes when
> we want to stress the hard disk/spin disk, we are actually stressing
> the cache. How do I disable the hardware cache using the fio tool ?
> Will --validate or --direct parameters take care of this ?

First you need to differentiate if you test the filesystem 
(/mnt/something) or the block device (/dev/sdx).

And yes, --direct bypass the caching.


> 2) I also came across some tools like IOStat, IO Meter, for storage
> device performance. How is FIO superior to these tools?

To me, it's real opensource, it has many backends, it's scriptable.

So barely we can test any kind of configuration with fio and if one is 
missing, let's add it.

> 3) When I run fio for random read and set the file option : example :
> --size = 20M, a file is created, which is not readable (i'm guessing
> it is a binary file). What does this file contain?
> And why is a file getting created even if rw is set to read? How to
> read this test file created by fio? My understanding is that FIO reads
> and writes random data using a random number generator, so shouldn't
> the data be readable.

To read a file, it needs to be created first right ?

I would say, why do you care about the content of it ?

If you want to check the consistency of the file, there is a 
verification mode in fio.

You can read the documentation around it if interested : 
https://fio.readthedocs.io/en/latest/fio_doc.html#verification

> 4) Is there any design diagram or documentation to understand the
> logic of how fio works?
I don't think so
> 5) How do I create a debug version of fio source code ? I was hoping
> that using breakpoints and debugging may help me identify the flow of
> the code.
You can do that, but reading the code is probably easier. With all the 
threads, the debugging will not be really trivial I think.
> 6) How to find the optimal io depth? Is queue depth same as fio iodepth?

The iodepth is usually linked to the device you target. Starts from the 
hardware specs and make your tries ;)

https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-depth

https://www.kernel.org/doc/html/latest/block/blk-mq.html

> 7) For zonemode = strided, does zonesize represent the stride length?
> My understanding of stride length is the gap between each read/write.
I have no experience here.
> 8) I wanted to check if whatever data was written is correct or not,
> so I ran the basic-verify.fio job file. But I didn't get any output
> saying the data written was also read, and that there were no errors.
> How do I know if there were errors ?
I don't know the expected behavior here.
>
> If you could recommend any useful resources to better my
> understanding, that would be highly appreciated.
> Even though I do not have a clear understanding of how the tool works,
> I am eager to learn as much as possible and hope to gain an enriching
> learning experience.
> I hope to gain a good understanding of the tool and want to create a
> documentation with flowchart of how fio works as my first contribution
> (so it's easier for complete beginners like me to understand better)
> Thank you for taking the time and reading this mail, awaiting your response.

That's a great idea to tackle the points that you face when entering a 
project so the following ones will have a better experience.


Erwan,


