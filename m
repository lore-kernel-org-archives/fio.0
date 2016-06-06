Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34717 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcFFMpS convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 6 Jun 2016 08:45:18 -0400
Received: by mail-oi0-f46.google.com with SMTP id e72so223598503oib.1
        for <fio@vger.kernel.org>; Mon, 06 Jun 2016 05:45:18 -0700 (PDT)
MIME-Version: 1.0
From: Jinpu Wang <jinpu.wang@profitbricks.com>
Date: Mon, 6 Jun 2016 14:44:58 +0200
Message-ID: <CAMGffEkGs5imFNH6T7uU07fDp_UX+RdbY-n2c8FrdzqmipLi3w@mail.gmail.com>
Subject: fio hang (sleep forever) after first job with ramp_time?
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

We run into fio hang (sleep forever) all the time with latest fio (fio --version
fio-2.11-12-g82e6)

Kernel 4.4.5 on Debian Jessie
Configuration:
cat test.ini
[global]
ioengine=libaio
direct=1
time_based=1

# runtime options
runtime=5
ramp_time=5
filename=/dev/ram0
[job1]
blocksize=32k

[job2]
blocksize=128k
stonewall

Fio process is sleep in:
cat /proc/9891/stack
[<ffffffff810ba469>] hrtimer_nanosleep+0xc9/0x1b0
[<ffffffff810ba5a7>] SyS_nanosleep+0x57/0x70
[<ffffffff81810757>] entry_SYSCALL_64_fastpath+0x12/0x6a
[<ffffffffffffffff>] 0xffffffffffffffff


If I remove the ramp_time, problem is gone.
I've also created a issue in github:
https://github.com/axboe/fio/issues/188

-- 
Mit freundlichen Grüßen,
Best Regards,

Jack Wang
