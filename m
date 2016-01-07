Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34955 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbcAGGDx (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 Jan 2016 01:03:53 -0500
Received: by mail-io0-f177.google.com with SMTP id 77so211061101ioc.2
        for <fio@vger.kernel.org>; Wed, 06 Jan 2016 22:03:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145733E19D0EC0B19F88C9D1F7F40@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB145733E19D0EC0B19F88C9D1F7F40@BN3PR0401MB1457.namprd04.prod.outlook.com>
Date: Thu, 7 Jan 2016 06:03:52 +0000
Message-ID: <CALjAwxjV8Qb2op2Og5RoZtGQ781vn5VCSRsWgrXZm8Fo8j7UNg@mail.gmail.com>
Subject: Re: time_based option broken
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 6 January 2016 at 18:45, Jeff Furlong <jeff.furlong@hgst.com> wrote:
>
> Here is 2.3 with a --runtime of 60s, and a runt of only 16s, and an error:
>
> # fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=1% --runtime=60s --time_based --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme0n1
> SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.3-11-g5f3b
> Starting 1 process
> fio: io_u error on file /dev/nvme0n1: Invalid argument: write offset=153764, buflen=1048576
> fio: io_u error on file /dev/nvme0n1: Invalid argument: write offset=1202340, buflen=1048576
> fio: pid=68391, err=22/file:io_u.c:1596, func=io_u error, error=Invalid argument
>
> SW_1MB_QD32: (groupid=0, jobs=1): err=22 (file:io_u.c:1596, func=io_u error, error=Invalid argument): pid=68391: Wed Jan  6 08:48:18 2016

Can say how big /dev/nvme0n1 is and can you repeat your test but with
size set in bytes? I'm wondering if your 1MByte blocksize doesn't
divide evenly in the 1% space the job has to work with...

-- 
Sitsofe | http://sucs.org/~sits/
