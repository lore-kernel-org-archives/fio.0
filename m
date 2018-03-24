Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:33738 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbeCXGRR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Mar 2018 02:17:17 -0400
Received: by mail-ua0-f179.google.com with SMTP id f6so9125206ual.0
        for <fio@vger.kernel.org>; Fri, 23 Mar 2018 23:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <36675d390f3348432593d72af3abdbe8@mail.gmail.com>
References: <36675d390f3348432593d72af3abdbe8@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 24 Mar 2018 06:16:46 +0000
Message-ID: <CALjAwxgkyE3WqAEjCDAdUB7AddFDNQVACZPA+6cN3GypwFmp2g@mail.gmail.com>
Subject: Re: Can I send UNMAP commands with FIO?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jason Sirichoke <jason.sirichoke@broadcom.com>
Cc: fio <fio@vger.kernel.org>

On 24 March 2018 at 00:19, Jason Sirichoke <jason.sirichoke@broadcom.com> wrote:
>
> I am trying to run a test to a device that only supports UNMAP commands
> but not TRIM. So I am able to use sg_unmap successfully but it looks like
> the trim commands sent by FIO fail as unsupported
>
> Is there a way to easily configure or modify FIO to send UNMAP instead of
> TRIM? These commands should be functionally very close to each other so
> was hoping this might be possible.

In short not unless you were to add the code to perform this to the sg
ioengine (where sending raw SCSI commands makes sense). Many ioengines
can cope with the generic block layer but at that layer you don't know
the disk below is truly a SCSI one (it might be SATA, NVMe etc). The
UNMAP command is specific to SCSI and even then only certain SCSI
disks - some SCSI disks implement unmapping via the WRITE SAME
command...

It's a pity your "SCSI disk" doesn't expose what's required for Linux
to enable discard (which is what regular fio engines are using to do
trim) and it might be worth your while quickly checking why. The last
time I ran into that situation was with old ESXi which didn't
advertise enough feature (see
https://stackoverflow.com/a/40817859/9109338 ).

-- 
Sitsofe | http://sucs.org/~sits/
