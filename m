Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51235 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729519AbfEWFrx (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 May 2019 01:47:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id c77so4380560wmd.1
        for <fio@vger.kernel.org>; Wed, 22 May 2019 22:47:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAJQBtgk=RDMWMM1=RAR=rYXHOLsJgvMsqaYLT8HPRy7YK-Oouw@mail.gmail.com>
In-Reply-To: <CAJQBtgk=RDMWMM1=RAR=rYXHOLsJgvMsqaYLT8HPRy7YK-Oouw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 23 May 2019 06:47:43 +0100
Message-ID: <CALjAwxiviiDHzpqURaTQ-O+UwqoU-WCo3OeV8+zpJHE=ako2xw@mail.gmail.com>
Subject: Re: How does FIO know size of a partition?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Left Right <olegsivokon@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Thu, 23 May 2019 at 05:44, Left Right <olegsivokon@gmail.com> wrote:
>
> Hello list!
>
> We are working on testing pmem library backed up by a partition on a
> device, and there seems to be a discrepancy between how we / pmem /
> FIO understand the size of the of partitions.
>
> Could anyone, please, shed a light on how this is done?
>
> Thank you!
>
> Oleg

This depends on the ioengine. If you mean the pmemblk ioengine, the
code to do it is done by the ioengine's get_file_size callback
"fio_pmemblk_get_file_size()"
(https://github.com/axboe/fio/blob/de5ed0e4d398bc9d4576f9b2b82d7686989c27e1/engines/pmemblk.c#L319
). If you mean a traditional file based ioengine (e.g. psync, libaio)
then it's handled by calls done from get_file_size() in filesetup.c
(https://github.com/axboe/fio/blob/afc22c98609ee80a99fbed24231181bdab2bc659/filesetup.c#L423
) e.g. for block device there's an eventual call down into the
platform specific blockdev_size() (here's a link to where
blockdev_size is defined for Linux
https://github.com/axboe/fio/blob/de5ed0e4d398bc9d4576f9b2b82d7686989c27e1/os/os-linux.h#L153
).

-- 
Sitsofe | http://sucs.org/~sits/

