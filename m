Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33568 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbcG0FxE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 27 Jul 2016 01:53:04 -0400
Received: by mail-pf0-f179.google.com with SMTP id y134so7298013pfg.0
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 22:53:03 -0700 (PDT)
Received: from [10.234.19.188] ([166.170.43.24])
        by smtp.gmail.com with ESMTPSA id d2sm5600928pat.6.2016.07.26.22.53.01
        for <fio@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 26 Jul 2016 22:53:02 -0700 (PDT)
From: seth roth <sethrroth@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: fio: client: unable to find matching tag - fio: client.c:1241: handle_eta: Assertion `client->eta_in_flight == eta' failed
Message-Id: <19900593-C0E2-4C4E-9C8F-EDFD8313C727@gmail.com>
Date: Tue, 26 Jul 2016 22:52:58 -0700
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

I will post job files at the bottom, I am committing client / server mode
tests. one launcher to four servers writing IO to RBD Pool using RBD
engine, the tests seem to run normally and then when runtime completes it
seems to be waiting for something and then fails with this console message -

[root@tme-sj-s16 4krd]# /usr/local/bin/fio --client=tme-sj-s27.lab
4kread_s27.job --client=tme-sj-s28.lab 4kread_s28.job
--client=tme-sj-s29.lab 4kread_s29.job --client=tme-sj-s30.lab
4kread_s30.job --output=./4krd_qd6.txt

fio: client: unable to find matching tag (13cca90)s] [0/0/0 iops] [eta
00m:00s]
fio: client.c:1241: handle_eta: Assertion `client->eta_in_flight == eta'
failed.
Aborted


Job files:(4)
4kread_s27.job
[global]
direct=1
rw=randread
randrepeat=0
ioengine=rbd
pool=pool001
clientname=admin
bs=4k
iodepth=6
numjobs=10
runtime=600
group_reporting
write_iops_log=./log/4kreadiops_27_qd6.res
write_bw_log=./log/4kreadbw_27_qd6.res

[IF_4krd_27_qd6]
rbdname=rbdimg001

4kread_s28.job
[global]
direct=1
rw=randread
randrepeat=0
ioengine=rbd
pool=pool001
clientname=admin
bs=4k
iodepth=6
numjobs=10
runtime=600
group_reporting
write_iops_log=./log/4kreadiops_28_qd6.res
write_bw_log=./log/4kreadbw_28_qd6.res

[IF_4krd_28_qd6]
rbdname=rbdimg002

4kread_s29.job
[global]
direct=1
rw=randread
randrepeat=0
ioengine=rbd
pool=pool002
clientname=admin
bs=4k
iodepth=6
numjobs=10
runtime=600
group_reporting
write_iops_log=./log/4kreadiops_29_qd6.res
write_bw_log=./log/4kreadbw_29_qd6.res

[IF_4krd_29_qd6]
rbdname=rbdimg001

4kread_s30.job
[global]
direct=1
rw=randread
randrepeat=0
ioengine=rbd
pool=pool002
clientname=admin
bs=4k
iodepth=6
numjobs=10
runtime=600
group_reporting
write_iops_log=./log/4kreadiops_30_qd6.res
write_bw_log=./log/4kreadbw_30_qd6.res

[IF_4krd_30_qd6]
rbdname=rbdimg002


Thank you Jens!
very much!
