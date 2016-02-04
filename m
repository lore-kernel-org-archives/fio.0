Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:37807 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416AbcBDXMD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Feb 2016 18:12:03 -0500
Received: from localhost (enchanter.cs.umn.edu [160.94.22.228])
	by mail.cs.umn.edu (Postfix) with ESMTP id 85E143DB5B5
	for <fio@vger.kernel.org>; Thu,  4 Feb 2016 17:12:01 -0600 (CST)
Received: from mail.cs.umn.edu ([128.101.32.201])
	by localhost (enchanter.cs.umn.edu [160.94.22.228]) (amavisd-new, port 10024)
	with ESMTP id 6U5Lad0aA2_P for <fio@vger.kernel.org>;
	Thu,  4 Feb 2016 17:11:59 -0600 (CST)
Received: from mail-io0-f178.google.com (mail-io0-f178.google.com [209.85.223.178])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id 31C523DB5B3
	for <fio@vger.kernel.org>; Thu,  4 Feb 2016 17:11:59 -0600 (CST)
Received: by mail-io0-f178.google.com with SMTP id g73so110783890ioe.3
        for <fio@vger.kernel.org>; Thu, 04 Feb 2016 15:11:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D2D93BA8.1CCD9%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D2D93BA8.1CCD9%Antonio.Jose.Rodrigues.Neto@netapp.com>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Thu, 4 Feb 2016 17:11:19 -0600
Message-ID: <CAB-428=5_5Hohz0hYfapx9g9y1Wwx_RhX8fF3rex=W3jZ5kVgQ@mail.gmail.com>
Subject: Re: FIO and replay_redirect
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Feb 4, 2016 at 4:32 PM, neto from Brazil
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
> Hi All,
>
> This is neto from Brazil
>
> How are you?
>
> I have captured a blktrace from an Oracle workload. 18 dm devices.
>
> Steps to capture:
>
> blktrace <device 0> <device 1> ... -w 40
> blkparse -i <device 0> -i <device 1> ... -o /dev/null -d oracle_trace.out
>
> Trying to replay with FIO (here I have 2 devices - /dev/sdh and /dev/sdi)
>
> Testing with one device:
>
> [workload]
> ioengine=libaio
> iodepth=1
> size=100g
> numjobs=1
> direct=1
> thread
> read_iolog=/root/traces/oracle-s144/oracle_trace.out
> replay_no_stall=1
> replay_redirect=/dev/sdh
>
> [root@oraperf1 fio]# ./fio oracle-replay.cfg
> workload: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
> fio-2.2.9-26-g669e
> Starting 1 thread
> fio: ioengines.c:422: td_io_open_file: Assertion `!fio_file_open(f)'
> failed.
> Aborted (core dumped)
>
>
>
>
>
> Questions:
>
> 1) The workload that I capture, all DM devices have 200GB size. My devices
> where I want to replay have 100GB. I believe I will need to match the size
> of all disks (where I captured the workload) with the destination where I
> am going to replay. For example: If I capture a workload with 18 LUNs
> 200GB, to replay I need to have 18 LUNs with 200GB minimum.

That is right. Your best bet to create one 100GB partition on each one
of those 200GB DMs. Therefore, physically you have 200GB DM. However,
the workload only goes to the first 100GB. Then capture new trace and
try to replay your new trace.

>
> 2) I need to replay to more than one device. How can I do that with fio?
> Seems to me replay_redirect is for a single specified device.

replay with btreplay or blkreplay instead of fio.

> 3) Any help why I am getting that error? fio: ioengines.c:422:
> td_io_open_file: Assertion `!fio_file_open(f)' failed.
>
> Thank you very much for all help.
>
> All the best
>
> neto
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
