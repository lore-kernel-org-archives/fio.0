Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55884 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgAIHlD (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Jan 2020 02:41:03 -0500
Received: by mail-wm1-f45.google.com with SMTP id q9so1683427wmj.5
        for <fio@vger.kernel.org>; Wed, 08 Jan 2020 23:41:02 -0800 (PST)
MIME-Version: 1.0
References: <CA+zhgFSVYMYkDeGEc1Tn3yEy24PgmFRiKABcCQkuEByMuLsnsQ@mail.gmail.com>
In-Reply-To: <CA+zhgFSVYMYkDeGEc1Tn3yEy24PgmFRiKABcCQkuEByMuLsnsQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 9 Jan 2020 07:40:34 +0000
Message-ID: <CALjAwxg+OKr3co5K++St1B=EdztytsDbhWUhNe6Bjz0Vg2uVQw@mail.gmail.com>
Subject: Re: 4KiB + 64 B formatted drive : Invalid or incomplete multibyte or
 wide character: write offset=4096, buflen=4096
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: smitha sunder <sundersmitha@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 8 Jan 2020 at 19:19, smitha sunder <sundersmitha@gmail.com> wrote:
>
> How ever if I format the drive with LBAF type 4 that is supported by
> the drive, then I get the following error :
>
> # nvme format /dev/nvme1 --namespace-id=1 --lbaf=4   --pi=1 --ms=0
> Success formatting namespace:1
> #  nvme list
> Node             SN                   Model
>         Namespace Usage                      Format           FW Rev
> ---------------- --------------------
> ---------------------------------------- ---------
> -------------------------- ---------------- --------
> /dev/nvme0n1     160401RICHC01        PM1733V4TLC
>         1           1.92  TB /   1.92  TB      4 KiB + 64 B   TEMC8881
> /dev/nvme1n1     160401RICHC01        PM1733V4TLC
>         1           1.92  TB /   1.92  TB      4 KiB + 64 B   TEMC8881
>
>
> # fio --filename=/dev/nvme0n1 --size=1M --rw=write --ioengine=libaio
> --direct=1 --verify=crc32 --verify_dump=1 --name=test --bs=4096
> test: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=libaio, iodepth=1
> fio-3.7
> Starting 1 process
> fio: io_u error on file /dev/nvme0n1: Invalid or incomplete multibyte
> or wide character: write offset=4096, buflen=4096
> fio: pid=32709, err=84/file:io_u.c:1747, func=io_u error,
> error=Invalid or incomplete multibyte or wide character

[...]

> Am I missing something?
> Thanks for the help !

All fio is saying is that it didn't get back the data that it wrote
down on the second block but I don't know what using "LBAF type 4"
might do to your disk (you are saying it changes the logical block
size but does it change anything else?).  Do you don't have anything
else that might be writing to that the device too and might have
interfered with the data? What happens if you add --offset=1M?

-- 
Sitsofe | http://sucs.org/~sits/

