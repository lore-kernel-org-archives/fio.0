Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36358 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbcF3Uni (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 Jun 2016 16:43:38 -0400
Received: by mail-vk0-f52.google.com with SMTP id m127so67257713vkb.3
        for <fio@vger.kernel.org>; Thu, 30 Jun 2016 13:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOkRmknpr96En3_NHYABKbkpnSGAmZ-4n4HfOC0DyWUVmapGfg@mail.gmail.com>
References: <CAOkRmkmnoHqBoKP2VYiY9LLJYfADK6moZdK_t1VOedDd670Aeg@mail.gmail.com>
 <CALjAwxhCyuRf-JO8P3Cm+Emk7E_VXBqN1f+4+QhqHpgd6LHHVA@mail.gmail.com>
 <CAOkRmkkeB8b7338VtNCeOAuKmaHfdFi7tFD0Czox3T1nDRu4Gw@mail.gmail.com> <CAOkRmknpr96En3_NHYABKbkpnSGAmZ-4n4HfOC0DyWUVmapGfg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 30 Jun 2016 21:43:37 +0100
Message-ID: <CALjAwxh+rnpX0TsXvCnPA_A_dPGAbS=FBAD-fSB=Gds_szzeQQ@mail.gmail.com>
Subject: Re: Compression options in fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Srinath Krishna Ananthakrishnan <ska@datera.io>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Could you bottom post replies? It makes things a bit easier here...

> On Thu, Jun 30, 2016 at 10:58 AM, Srinath Krishna Ananthakrishnan
> <ska@datera.io> wrote:
>> I don't want fio to vary the data and need it to be more deterministic.

Don't forget you can use can also use randseed to generate the same
random data between invocations.

>> After playing with it for quite some time, I have the following
>> (inconclusive) theory.
>>
>> 1. If no verify options are set, fio generates
>> buffer_compress_percentage worth of compressible data per block size.
>> Compressible data is always zeroed out.
>> 2. With verify options, fio generates buffer_compress_percentage worth
>> of compressible data (zeroes) for some blocks but there are these
>> bunch of blocks from time to time that contain purely random data.

You can inspect the source code directly (e.g.
https://github.com/axboe/fio/blob/8c07860de982fabaaf41d44c22aa86aba2539b58/io_u.c#L2031
) to find out what's happening.

>> From the manual, verify options add additional meta data to the header
>> of every block for verification but I'm not sure why some blocks turn
>> out to be completely random with this setting on. I tried multiple
>> verify hashes with the same result.
>>
>> With either of the cases, I don't seem to get the buffer_pattern
>> setting working.

I don't quite see the behaviour you describe. I used the following
with the latest git fio on x86_64:
[global]
randrepeat=1
ioengine=sync
iodepth=64
iodepth_batch=16
direct=1
numjobs=1
verify_fatal=1
verify_dump=1
filename=./my_file

[small_write]
rw=write
blocksize=4k
size=100M
verify=crc32c-intel
buffer_compress_percentage=50
buffer_pattern=0xdeadbeef

Using hexdump showed an initial header followed by random data up to
0x800 and from 0x801 to 0xfff was the pattern deadbeef (in binary). So
50% of the block was the header + random and the other 50% was the
buffer_pattern I specified. Bear in mind that if something were to
compress these blocks it would likely get better than 50% compression
because the repeating deadbeef pattern is itself highly
compressible...

On 30 June 2016 at 19:35, Srinath Krishna Ananthakrishnan <ska@datera.io> wrote:
> Another idiosyncrasy that I observed was,
>
> With rw=write, compression options are not heeded. They seem to work only rw=rw.
> Thanks,
> Srinath

See the above job file where I used rw=write. Are you using a git
version of fio?

-- 
Sitsofe | http://sucs.org/~sits/
