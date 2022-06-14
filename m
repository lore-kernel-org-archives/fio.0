Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC53AC43334
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 21:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiFNVUp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 17:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiFNVUn (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 17:20:43 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6196B4ECC9
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 14:20:41 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w20so15883666lfa.11
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 14:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=CZdBa6jbgzRChd8Hg8Rnlci3TxOndejMT9LaBW1jvHw=;
        b=iszlaMZlvg7CRLotao2evnvuDrWRvLOGM8MZe102FX+0xrS0z+9Z3LDwXQ1ftM/XnO
         D3cSgurCfCVhCINIaWvI09OY+uhDeoz2mVp+CdNOcuA/pEPDWA660aA1Rws1cE9lGkoP
         tEsXRK+Rm9zcDEAiLIzORapczReQP7dzJs0M9TlbppGx9cjUBrBi/umGSo+r9hsThSnE
         b+0VanLNPTxJZDff0Sj68EoaY+DRz98c2Ew68MPY9wilSXrEKtg/f9sJZLCIkhhOYlGI
         6acA+RfsErEy65txuCyp6P0zJqRP9AtesWhVRbXRIHJHlr1BnckQEZ/6zRlEhZeIIskY
         6ShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CZdBa6jbgzRChd8Hg8Rnlci3TxOndejMT9LaBW1jvHw=;
        b=nAq/poYeQYEfuFApFR0PxkfPgsfYjFdGxyEVD8bCXCYVEeoji0IyM/q82WCsRufYc9
         N2k3c/r6p3iWe2AnoZstoRd8e9J7ypuE5j/sk8IrmuponplCLkVOPSbZWJ+R0nqbQrsr
         DpvhakOu6lG8yueCx+sdKkG358JQ/K6rYnJO2tWG/D+AwPs+buBLw9TsPKG7YzK8oUyv
         cTliLddgTx17TrzmuhV+h9mGJ0zYjE+olwq1ZelmlZn1SGXLlCN8Jv4Gd/EFCCwyXutn
         jRbDfpcLG+3auYEhp8dqpOUcVBW6TZQQ8ZKVMD9A7NxeqqkziigXfNqPESWeWCPezXYV
         JF3Q==
X-Gm-Message-State: AJIora+kHbTuFY3iBMZthhRaMIpK4aa4Uz+gAWN+QFL9O9WdakmAlPxr
        LOGjj1FDiU5UO3RNi/Q3B/pERjGZh3tSaA0Q+LooTu+GmDdpP9jwlSgfbQ==
X-Google-Smtp-Source: AGRyM1sJxem0g0kZuaAhr+miAf5tKoldkdVKEKLOtrfFd/KUzVenWxR7UzI1d5HUjcE+a+1PfGQmwjsYcINmpe54aTs=
X-Received: by 2002:a05:6512:230d:b0:47d:de8e:29a with SMTP id
 o13-20020a056512230d00b0047dde8e029amr2656540lfu.340.1655241639430; Tue, 14
 Jun 2022 14:20:39 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Weber <cwplaintext@gmail.com>
Date:   Tue, 14 Jun 2022 16:20:26 -0500
Message-ID: <CAEKEyK25zDJEst0CRd=X0uX81DkCzzgov0JC0YtF9JGnS+qqMQ@mail.gmail.com>
Subject: FIO single file questions and potential issue
To:     fio@vger.kernel.org, weberc@netapp.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm looking into some issues when running fio and have noticed some
unusual behavior.  The intent is to write a very large file using a
large number of jobs in parallel.  For this reason, I'm using
create_serialize=0.  However, this results in setup_files() getting
called in parallel as well.  This in turn calls extend_file() which
does unlink and open/create operations to attempt to resize the file.
When run in parallel, it's deleting and creating the file repeatedly,
so you're not guaranteed to get a file of the appropriate size.

Original FIO command of interest:
fio --output-format=normal --rw=write --fallocate=none
--group_reporting=1 --disable_lat=1 --disable_clat=1 --disable_slat=1
--startdelay=5 --ramp_time=3 --time_based=0 --invalidate=0
--create_serialize=0 --size=4G --nrfiles=1
--filename=/home/user/fio_testdir/cw1 --offset_increment=4G
--blocksize=128K --name=socket0 --numjobs=80

Command I'm using to recreate:
./fio --output-format=normal  --name=global --rw=write --create_only=0
--fallocate=none --group_reporting=1 --disable_lat=1 --disable_clat=1
--disable_slat=1 --startdelay=5 --ramp_time=3 --time_based=0
--invalidate=0 --create_serialize=0 --size=1M --nrfiles=1
--filename=/home/user/fio_testdir/cw1 --offset_increment=1M
--blocksize=128K --name=socket0 --numjobs=64

In my example below, I'm expecting a file of 64MB -- I ended up with a
file of 60MB in size.

Starting 64 processes
file     1933568 setup files
file     1933565 setup files
file     1933571 setup files
file     1933566 setup files
file     1933569 setup files
file     1933568 get file size for 0x7f59e73c0890/0//home/user/fio_testdir/cw1
file     1933571 get file size for 0x7f59e73c0e30/0//home/user/fio_testdir/cw1
file     1933565 get file size for 0x7f59e73c02f0/0//home/user/fio_testdir/cw1
file     1933567 setup files
file     1933570 setup files
socket0: Laying out IO file (1 file / 59MiB)
socket0: Laying out IO file (1 file / 62MiB)
file     1933566 get file size for 0x7f59e73c04d0/0//home/user/fio_testdir/cw1
file     1933569 get file size for 0x7f59e73c0a70/0//home/user/fio_testdir/cw1
socket0: Laying out IO file (1 file / 1MiB)
file     1933571 layout unlink /home/user/fio_testdir/cw1
file     1933568 layout unlink /home/user/fio_testdir/cw1
file     1933565 layout unlink /home/user/fio_testdir/cw1
file     1933568 open file /home/user/fio_testdir/cw1, flags 41
file     1933571 open file /home/user/fio_testdir/cw1, flags 41
file     1933565 open file /home/user/fio_testdir/cw1, flags 41
file     1933567 get file size for 0x7f59e73c06b0/0//home/user/fio_testdir/cw1
file     1933570 get file size for 0x7f59e73c0c50/0//home/user/fio_testdir/cw1
socket0: Laying out IO file (1 file / 64MiB)
socket0: Laying out IO file (1 file / 61MiB)
file     1933566 layout unlink /home/user/fio_testdir/cw1
file     1933569 layout unlink /home/user/fio_testdir/cw1
socket0: Laying out IO file (1 file / 63MiB)
file     1933567 layout unlink /home/user/fio_testdir/cw1
socket0: Laying out IO file (1 file / 60MiB)
file     1933569 open file /home/user/fio_testdir/cw1, flags 41
file     1933567 open file /home/user/fio_testdir/cw1, flags 41
file     1933566 open file /home/user/fio_testdir/cw1, flags 41
file     1933603 setup files
file     1933603 get file size for 0x7f59e73c4a30/0//home/user/fio_testdir/cw1
socket0: Laying out IO file (1 file / 27MiB)
file     1933603 layout unlink /home/user/fio_testdir/cw1
file     1933603 open file /home/user/fio_testdir/cw1, flags 41
file     1933574 setup files
file     1933600 setup files
file     1933574 get file size for 0x7f59e73c13d0/0//home/user/fio_testdir/cw1
file     1933572 setup files
socket0: Laying out IO file (1 file / 56MiB)
file     1933600 get file size for 0x7f59e73c4490/0//home/user/fio_testdir/cw1
file     1933574 layout unlink /home/user/fio_testdir/cw1
file     1933591 setup files
file     1933572 get file size for 0x7f59e73c1010/0//home/user/fio_testdir/cw1
file     1933574 open file /home/user/fio_testdir/cw1, flags 41
socket0: Laying out IO file (1 file / 30MiB)



Tracing the ext4 events shows new files getting created:

             fio-1933566 [013] .... 697440.451620: ext4_unlink_enter:
dev 253,0 ino 6564397 size 0 parent 6554882
             fio-1933566 [013] .... 697440.451664: ext4_unlink_exit:
dev 253,0 ino 6564397 ret 0
             fio-1933569 [013] .... 697440.451719: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933569 [013] .... 697440.451739:
ext4_allocate_inode: dev 253,0 ino 6564521 dir 6554882 mode 0100644
             fio-1933567 [013] .... 697440.451768: ext4_unlink_enter:
dev 253,0 ino 6564521 size 0 parent 6554882
             fio-1933567 [013] .... 697440.451776: ext4_unlink_exit:
dev 253,0 ino 6564521 ret 0
             fio-1933567 [013] .... 697440.451802: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933567 [013] .... 697440.451813:
ext4_allocate_inode: dev 253,0 ino 6565365 dir 6554882 mode 0100644
             fio-1933603 [001] .... 697440.452112: ext4_unlink_enter:
dev 253,0 ino 6565365 size 0 parent 6554882
             fio-1933603 [001] .... 697440.452146: ext4_unlink_exit:
dev 253,0 ino 6565365 ret 0
             fio-1933603 [001] .... 697440.452166: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933603 [001] .... 697440.452185:
ext4_allocate_inode: dev 253,0 ino 6565366 dir 6554882 mode 0100644
             fio-1933574 [007] .... 697440.452290: ext4_unlink_enter:
dev 253,0 ino 6565366 size 0 parent 6554882
             fio-1933574 [007] .... 697440.452308: ext4_unlink_exit:
dev 253,0 ino 6565366 ret 0
             fio-1933574 [007] .... 697440.452327: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933574 [007] .... 697440.452340:
ext4_allocate_inode: dev 253,0 ino 6565367 dir 6554882 mode 0100644
             fio-1933600 [015] .... 697440.452349: ext4_unlink_enter:
dev 253,0 ino 6565367 size 0 parent 6554882
             fio-1933600 [015] .... 697440.452363: ext4_unlink_exit:
dev 253,0 ino 6565367 ret 0
             fio-1933600 [015] .... 697440.452377: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933600 [015] .... 697440.452387:
ext4_allocate_inode: dev 253,0 ino 6565368 dir 6554882 mode 0100644
             fio-1933591 [006] .... 697440.452398: ext4_unlink_enter:
dev 253,0 ino 6565368 size 0 parent 6554882
             fio-1933591 [006] .... 697440.452423: ext4_unlink_exit:
dev 253,0 ino 6565368 ret 0
             fio-1933572 [005] .... 697440.452431: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933572 [005] .... 697440.452445:
ext4_allocate_inode: dev 253,0 ino 6565369 dir 6554882 mode 0100644
           <...>-1933627 [013] .... 697440.452556: ext4_unlink_enter:
dev 253,0 ino 6565369 size 0 parent 6554882
           <...>-1933627 [013] .... 697440.452568: ext4_unlink_exit:
dev 253,0 ino 6565369 ret 0
           <...>-1933627 [013] .... 697440.452583: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
           <...>-1933627 [013] .... 697440.452593:
ext4_allocate_inode: dev 253,0 ino 6565370 dir 6554882 mode 0100644
             fio-1933598 [010] .... 697440.452676: ext4_unlink_enter:
dev 253,0 ino 6565370 size 0 parent 6554882
             fio-1933598 [010] .... 697440.452711: ext4_unlink_exit:
dev 253,0 ino 6565370 ret 0
             fio-1933598 [010] .... 697440.452731: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933598 [010] .... 697440.452748:
ext4_allocate_inode: dev 253,0 ino 6565371 dir 6554882 mode 0100644
             fio-1933577 [014] .... 697440.452797: ext4_unlink_enter:
dev 253,0 ino 6565371 size 0 parent 6554882
             fio-1933577 [014] .... 697440.452819: ext4_unlink_exit:
dev 253,0 ino 6565371 ret 0
             fio-1933577 [014] .... 697440.452841: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933577 [014] .... 697440.452857:
ext4_allocate_inode: dev 253,0 ino 6565372 dir 6554882 mode 0100644
             fio-1933587 [001] .... 697440.452910: ext4_unlink_enter:
dev 253,0 ino 6565372 size 0 parent 6554882
             fio-1933587 [001] .... 697440.452927: ext4_unlink_exit:
dev 253,0 ino 6565372 ret 0
             fio-1933587 [001] .... 697440.452947: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933587 [001] .... 697440.452960:
ext4_allocate_inode: dev 253,0 ino 6565373 dir 6554882 mode 0100644
           <...>-1933575 [007] .... 697440.453008: ext4_unlink_enter:
dev 253,0 ino 6565373 size 0 parent 6554882
           <...>-1933575 [007] .... 697440.453023: ext4_unlink_exit:
dev 253,0 ino 6565373 ret 0
           <...>-1933575 [007] .... 697440.453041: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
           <...>-1933575 [007] .... 697440.453050:
ext4_allocate_inode: dev 253,0 ino 6565374 dir 6554882 mode 0100644
             fio-1933612 [015] .... 697440.453059: ext4_unlink_enter:
dev 253,0 ino 6565374 size 0 parent 6554882
             fio-1933612 [015] .... 697440.453070: ext4_unlink_exit:
dev 253,0 ino 6565374 ret 0
             fio-1933582 [000] .... 697440.453081: ext4_request_inode:
dev 253,0 dir 6554882 mode 0100644
             fio-1933582 [000] .... 697440.453102:
ext4_allocate_inode: dev 253,0 ino 6565375 dir 6554882 mode 0100644


Ultimately, one of the inodes "wins" and becomes the output file.

             fio-1933613 [004] .... 697440.520251:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 17408000 len 4096 flags
0
             fio-1933613 [004] .... 697440.520253:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 17412096 len 4096 flags
0
             fio-1933613 [004] .... 697440.520256:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 17416192 len 4096 flags
0
             fio-1933613 [004] .... 697440.520257:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 17420288 len 4096 flags
0
             fio-1933613 [004] .... 697440.520259:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 17424384 len 4096 flags
0
             fio-1933613 [004] .... 697440.520261:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 17428480 len 4096 flags
0
             fio-1933594 [013] .... 697440.520265:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 37355520 len 4096 flags
0
             fio-1933594 [013] .... 697440.520271:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 37359616 len 4096 flags
0
             fio-1933594 [013] .... 697440.520274:
ext4_da_write_begin: dev 253,0 ino 6565365 pos 37363712 len 4096 flags
0


Other inodes are written to, but are ultimately discarded from the file system.

Using create_serialize=1 results in correct behavior for file
creation, but then the write jobs appear to be serialized as well.

I believe there is a bug in this FIO behavior. The file really only
needs to be extended once for the largest subjob size when
create_serialize=0.

Do you agree with my assessment? If so, I can open a bug report. If
not, I am probably missing something (and don't want to open a false
bug report if I'm doing something incorrectly).

Other relevant info:
# ./fio --version
fio-3.30-7-gd684b
# uname -a
Linux ictad23h02 5.4.0-107-generic #121-Ubuntu SMP Thu Mar 24 16:04:27
UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
# lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.3 LTS
Release:        20.04
Codename:       focal

To recreate, I run:
rm /home/user/fio_testdir/cw1
./fio --output-format=normal  --name=global --rw=write --create_only=0
--fallocate=none --group_reporting=1 --disable_lat=1 --disable_clat=1
--disable_slat=1 --startdelay=5 --ramp_time=3 --time_based=0
--invalidate=0 --create_serialize=0 --size=1M --nrfiles=1
--filename=/home/user/fio_testdir/cw1 --offset_increment=1M
--blocksize=128K --name=socket0 --numjobs=64

It may take a few attempts to recreate the issue, but the larger
--numjobs is, the more likely the issue is to happen.  It happens
frequently with 64 jobs on this system.

Thanks,
--Chris Weber
