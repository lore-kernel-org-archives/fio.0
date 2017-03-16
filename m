Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34713 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdCPH0h (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Mar 2017 03:26:37 -0400
Received: by mail-ua0-f174.google.com with SMTP id f54so21277578uaa.1
        for <fio@vger.kernel.org>; Thu, 16 Mar 2017 00:26:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBZXzR59VacRo0g+VjVasfE_aqKk8J8vCDOYOLasHG9sVA@mail.gmail.com>
References: <CAKV1nBZEgd=r9fjn9xG57c08y-xH44sJiK2r==hGcdCHo0x+zw@mail.gmail.com>
 <CALjAwxiwYOz7a_Yh5QA77xDG6pc6nZvXU2roMH75L96KmGOtuA@mail.gmail.com> <CAKV1nBZXzR59VacRo0g+VjVasfE_aqKk8J8vCDOYOLasHG9sVA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 16 Mar 2017 07:26:05 +0000
Message-ID: <CALjAwxiLj9JcrJDiwBerGnJC+qin-B2VLFaNNT__VJ-HcQ402w@mail.gmail.com>
Subject: Re: FIO data integrity - description for different fields
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Saju,

Apologies for the slowness of the reply. One tip though: use reply to
all otherwise the mailing list won't get followup mails and no one
else will see your questions...

Because you're particular example is using a sequential write and an
explicit verify_pattern there's actually no randomness in your job so
in this particular case randseed will have no impact. Additionally
refill_buffers is automatically turned on when you use verify
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-refill-buffers
). In fact you don't have to set ranseed at all because if the header
is intact fio is able to regenerate the expected non-header data
because the header contains the randseed.

> crc32c: verify failed at file /dev/XXXX0n1 offset 53248, length 4096
>        Expected CRC: 203fd2f2
>        Received CRC: dadd3940

In this case the "CRC" means whichever checksum method you set (e.g.
crc32c, md5 etc) and it's referring to the data after the header.
Given you have expected and received data for those components it
should be possible to work out which area went bad. Here's a worked
example:

[writes and verify the file /tmp/verifytest]
fio --filename /tmp/verifytest --verify=crc32c --bs=512 --size=512
--rw=write --name=verifytest
[corrupt the last eight bytes of the 512 byte file by setting them to zero]
dd if=/dev/zero of=/tmp/verifytest seek=504 bs=1 count=8
[just verify the file]
fio --filename /tmp/verifytest --verify=crc32c --bs=512 --size=512
--rw=read --name=verifytest --verify_dump=1

The last fio outputs something like this:
verifytest: (g=0): rw=read, bs=512B-512B,512B-512B,512B-512B,
ioengine=psync, iodepth=1
fio-2.17-50-gdccef-dirty
Starting 1 process
crc32c: verify failed at file /tmp/verifytest offset 0, length 512
       Expected CRC: a516bb52
       Received CRC: fe59c5ad
       received data dumped as verifytest.0.received
       expected data dumped as verifytest.0.expected
fio: pid=14550, err=84/file:io_u.c:1940, func=io_u_sync_complete,
error=Invalid or incomplete multibyte or wide character
[...]

OK, let's try our best to work out the difference:
diff -u0 <(hexdump verifytest.0.expected) <(hexdump verifytest.0.received)

@@ -2,2 +2,2 @@
-0000010 0000 0000 0000 0000 846b 002b d379 0003
-0000020 0001 0000 4810 184e 16a5 52bb 8517 1d19
+0000010 0000 0000 0000 0000 0000 0000 0000 0000
+0000020 0001 0000 5f86 2509 16a5 52bb 8517 1d19

Well this difference is still within the header that I previously
mentioned cannot be regenerated perfectly and at any rate fio's
complaint was about the non-header data.

@@ -32 +32 @@
-00001f0 13d2 f7a5 b87d 11cd a27a 350b bb3d 0438
+00001f0 13d2 f7a5 b87d 11cd 0000 0000 0000 0000

Aha - we see the last eight bytes were expected to be values other
than zero so that's where the problem lies.

On 9 March 2017 at 03:59, Saju Nair <saju.mad.nair@gmail.com> wrote:
>
> 1. System details - it is a Linux CentOS host:
> 2.6.32-573.22.1.el6.centos.plus.si201609211134.x86_64 #1 SMP Wed Sep
> 21 12:37:19 PDT 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> 2. Verification method - we tried with -verify=crc32c, and also md5.
>
> 3. FIO version : 2.12
>
> 4. FIO config file used - pls find snippet below:
> [write-phase]
> group_reporting
> rw=write
> bs=4k
> direct=1
> ioengine=libaio
> iodepth=32
> numjobs=1
> size=128G
> randseed=40964096
> verify=crc32c
> verify_pattern=0x88888888
> verify_dump=1
> refill_buffers
> filename=/dev/XXXX0n1
>
> We tried the 'randseed' to get a predictable set of sequence in the
> LBAs generated.
>
> 5. FIO output:
> [user@abc data_integrity]# FIO Invocation
> write-phase: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> fio-2.12
> Starting 1 process
> Jobs: 1 (f=1): [W(1)] [11.7% done] [0KB/nnn.nMB/0KB /s] [0/mmmK/0
> iops] [eta 01m:31s]
> Jobs: 1 (f=1): [W(1)] [21.4% done] [0KB/nnn.nMB/0KB /s] [0/mmmK/0
> iops] [eta 01m:21s]
> Jobs: 1 (f=1): [W(1)] [31.1% done] [0KB/nnn.nMB/0KB /s] [0/mmmK/0
> iops] [eta 01m:11s]
> Jobs: 1 (f=1): [W(1)] [40.4% done] [0KB/nnn.nMB/0KB /s] [0/mmmK/0
> iops] [eta 01m:02s]
> crc32c: verify failed at file /dev/XXXX0n1 offset 53248, length 4096
>        Expected CRC: 203fd2f2
>        Received CRC: dadd3940
>        received data dumped as XXXX0n1.53248.received
>        expected data dumped as XXXX0n1.53248.expected
> fio: pid=3808, err=84/file:io_u.c:1968, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character

-- 
Sitsofe | http://sucs.org/~sits/
