Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f169.google.com ([209.85.221.169]:37159 "EHLO
        mail-vk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeLKW24 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Dec 2018 17:28:56 -0500
Received: by mail-vk1-f169.google.com with SMTP id 197so3776361vkf.4
        for <fio@vger.kernel.org>; Tue, 11 Dec 2018 14:28:55 -0800 (PST)
MIME-Version: 1.0
References: <DM5PR19MB1402A8B7F86B55C8E10D72FADBA60@DM5PR19MB1402.namprd19.prod.outlook.com>
In-Reply-To: <DM5PR19MB1402A8B7F86B55C8E10D72FADBA60@DM5PR19MB1402.namprd19.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 11 Dec 2018 22:28:28 +0000
Message-ID: <CALjAwxgmZBx42sPYdLMiya325BCFKNEPFoCi6_VtAYe37pb5KA@mail.gmail.com>
Subject: Re: err=84/file:io_u.c:2033, func=io_u_sync_complete, error=Invalid
 or incomplete multibyte or wide character
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: mohan@ertino.com
Cc: fio <fio@vger.kernel.org>

On Tue, 11 Dec 2018 at 18:01, Mohan Mohan <mohan@ertino.com> wrote:
>
> Hi,
>
> Is the error below is expected one for the read operation? I am not getting any error for the write operation.
>
> root@ertino-ThinkPad-T431s:/home/ertino--verify crc32c

^^^ It looks like you asked for verifying reads (although this line
looks mangled - it's hard to tell without seeing the full job).

>
> xspp: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
> fio-3.12-17-g0fcbc0
> Starting 1 process
> xspp: Laying out IO file (1 file / 10MiB)
> verify: bad magic header 1950, wanted acca at file xspp.0.0 offset 630784, length 4096 (requested block: offset=630784, length=4096)

^^^ This is saying that the block read lacked the expected fio header.

>
> fio: pid=32055, err=84/file:io_u.c:2033, func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide character
>
> xspp: (groupid=0, jobs=1): err=84 (file:io_u.c:2033, func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide character): pid=32055: Tue Dec 11 23:09:30 2018

I'm guessing you asked fio to do verifying reads (e.g. fio
--name=verifread --rw=read --verify=crc32c --size=1M
--filename=fio.tmp) *before* you wrote data with a verify header.
Unless you have already written all of the file that is being read
back file with appropriate verification headers (i.e. you ran a write
job first) then it's expected fio will complain about not being able
to read the expected headers. A write job won't have this problem
because it writes data (sometimes before trying to read it back). See
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify
for details.

-- 
Sitsofe | http://sucs.org/~sits/

