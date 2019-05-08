Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f181.google.com ([209.85.166.181]:37965 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHUNo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 May 2019 16:13:44 -0400
Received: by mail-it1-f181.google.com with SMTP id q19so6060785itk.3
        for <fio@vger.kernel.org>; Wed, 08 May 2019 13:13:43 -0700 (PDT)
MIME-Version: 1.0
From: Shivam Dhir <dhirs1@uci.edu>
Date: Wed, 8 May 2019 13:13:32 -0700
Message-ID: <CAKaVHqeY0zGAewNX8wpK_rqgEJazSt-VfO7MTgbz8E7+3Mq=xw@mail.gmail.com>
Subject: Random RW Error
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi, below are two scripts for doing a random read write with
verification. The goal is to have a mixed io test with 70 percent
being reads after preconditioning the drive with writes.

Script 1
[global]
numjobs=1
ioengine=libaio
filename=/dev/nvme0n1
size=100GB
direct=1
bs=4k
iodepth=128
verify=md5
verify_interval=4096

[write-phase]
rw=write
do_verify=0
stonewall

[randomrw]
rw=randrw
rwmixread=70
norandommap
randrepeat=0
do_verify=1
stonewall

Script 2
[global]
numjobs=1
ioengine=libaio
filename=/dev/nvme0n1
size=100GB
direct=1
bs=4k
iodepth=128
verify=md5
verify_interval=4096

[write-phase]
rw=write
do_verify=1
stonewall

[randomrw]
rw=randrw
rwmixread=70
norandommap
randrepeat=0
do_verify=1
stonewall


The first script gives an error : invalid or incomplete multibyte or
wide character.
The second script passes without any error.

Wondering how does not doing verification in first script during write
phase leads to this error.

Thanks.
-- 
Shivam Dhir
Master of Embedded and Cyber-Physical Systems
University of California
Irvine

