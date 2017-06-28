Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:32877 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdF1Gbx (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Jun 2017 02:31:53 -0400
Received: by mail-ua0-f177.google.com with SMTP id w19so10956802uac.0
        for <fio@vger.kernel.org>; Tue, 27 Jun 2017 23:31:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69642c93a0234662a88941156a91bc1f@DLB-XCHPW05.dolby.net>
References: <69642c93a0234662a88941156a91bc1f@DLB-XCHPW05.dolby.net>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 28 Jun 2017 07:31:22 +0100
Message-ID: <CALjAwxiGNwARvzW=9ffe1oBQemZa-uiN6apM7+PurEsubKQeKw@mail.gmail.com>
Subject: Re: Recommended Job File For Stress Testing PCI-E
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Forrest, Jon" <Jon.Forrest@dolby.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 28 June 2017 at 00:41, Forrest, Jon <Jon.Forrest@dolby.com> wrote:
> I have a system running CentOS 7.3 with 512GB of RAM and
> 3 Oracle F80 800GB PCIe Flash Accelerators. We have reason to
> believe that there is a problem with the PCI-E hardware that
> we'd like to trigger by sending lots of data on the PCI-E bus.
>
> We thought that using fio would be a good way of doing this.
> I'm wondering if someone can recommend a job file that would
> access 12 disks simultaneously with as much I/O as possible.
> Since these disks are flash disks, I'm hoping to do way more
> reads than writes.

I'm assuming you're just trying to generate IOPS rather than verify
data integrity. Perhaps something like

[global]
ioengine=libaio
direct=1
iodepth=128
iodepth_batch_submit=16
bs=4k
rw=randrw
rwmixread=80
norandommap=1
gtod_reduce=1

[disk1]
filename=/dev/nvme0n1

[disk2]
filename=/dev/nvme0n2

etc.

You might see a benefit (more load per disk) using threads (thread)
rather than processes. You may also need to use more than one thread
per disk. See http://fio.readthedocs.io/en/latest/fio_doc.html for
more options. Both https://www.spinics.net/lists/fio/msg05451.html and
http://marc.info/?l=linux-kernel&m=140313968523237&w=2 give examples
of people using fio to drive high load so those might be more useful.

-- 
Sitsofe | http://sucs.org/~sits/
