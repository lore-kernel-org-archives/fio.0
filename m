Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f47.google.com ([209.85.222.47]:37782 "EHLO
        mail-ua1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbeIUTmX (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Sep 2018 15:42:23 -0400
Received: by mail-ua1-f47.google.com with SMTP id y10-v6so5857150uao.4
        for <fio@vger.kernel.org>; Fri, 21 Sep 2018 06:53:24 -0700 (PDT)
MIME-Version: 1.0
From: RomanS <execooler@gmail.com>
Date: Fri, 21 Sep 2018 16:51:50 +0300
Message-ID: <CALBCzHevkYj3PvAUQQr03O9dGy42pgnFJ8s8ugkDmidSLKW4Pg@mail.gmail.com>
Subject: How to emulate a VM workload?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello.

Could someone help to write a config to emulate a VM workload?
The goal is to test a storage for VM. Each file on the VM is a disk of a VM.

I tried to test the case by the following config:

ioengine=posixaio
randrepeat=1
norandommap=1
runtime=86400
group_reporting
bs=32k
time_based=1
iodepth=16
numjobs=1
rw=randrw
rwmixread=50
rwmixwrite=50
size=2g
[workload]
filename=/storage/vm_disk

But it seems the above config is not a VM workload.

For the second test I created a FS on the file and mounted it. The
config was almost the same, except:
numjobs=20
size=85m

I think the second config is more like a VM workload, than the first.
Is it possible to do the same only by FIO?

