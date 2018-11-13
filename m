Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f178.google.com ([209.85.167.178]:44970 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbeKMS5a (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Nov 2018 13:57:30 -0500
Received: by mail-oi1-f178.google.com with SMTP id p82-v6so9622600oih.11
        for <fio@vger.kernel.org>; Tue, 13 Nov 2018 01:00:22 -0800 (PST)
MIME-Version: 1.0
From: Taylor Yang <taylor4869@gmail.com>
Date: Tue, 13 Nov 2018 01:00:10 -0800
Message-ID: <CAKiK_mAyMPdR9JamSee8XLQJoBehdGFY1a92NEgH+DmjpnKBow@mail.gmail.com>
Subject: Question about data verification using verify_state_save and verify_state_load
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I want to do some writes and reads to a device for a period of time
and then verify the writes. So I have the following job files.

write.fio job file:
[global]
direct=1
ioengine=libaio
numjobs=1
verify=crc32c

[/dev/sdf]
filename=/dev/sdf
time_based
runtime=500
bwavgtime=1000
iopsavgtime=1000
rw=randrw
rwmixwrite=50
verify_state_save=1
iodepth=4
bs=4k


verify.fio file
[global]
direct=1
ioengine=libaio
group_reporting
numjobs=1
verify=crc32c

[/dev/sdf]
rw=read
do_verify=1
filename=/dev/sdf
verify_state_load=1

I saw some bad magic header errors while doing this but when I added
all the related flags I have in the write.fio file to the verify.fio
file. Everything seems to work.

[global]
direct=1
ioengine=libaio
numjobs=1
verify=crc32c

[/dev/sdf]
rw=randrw
rwmixwrite=50
do_verify=1
filename=/dev/sdf
verify_state_load=1
iodepth=4
bs=4k

For example, if I change the verify job file to below, everything
looks fine but the verification might take some time.

I have a few questions regarding this.
1. Does the write phase `rw` option have to match the verify phase?
For example if I have `randomwrite` for write phase, do I need to put
'randomread' for verify phase but not 'read'? And if I have 'randomrw'
in write phase, is it true that I have to use it in verify phase?
2. Do I need to put all the flags in write phase to verify phase? So
in my case, do I have to add iodepth and bs to the verify phase as
well?
3. Are there other ways to achieve what I want? I mainly want to have
some kinda of complicated IO workload (mix writes and reads) with the
time_based option and if the verification could complete during this
timed phase, I could save the progress and then have a separate verify
phase later to fully verify the writes. I know I could use
verify_backlog but I intend to verify the writes separately.

Thank you so much in advance.
Best wishes,
Taylor

