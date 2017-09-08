Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:44249 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdIHANz (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Sep 2017 20:13:55 -0400
Received: by mail-it0-f48.google.com with SMTP id f199so1350108ita.1
        for <fio@vger.kernel.org>; Thu, 07 Sep 2017 17:13:55 -0700 (PDT)
MIME-Version: 1.0
From: Brandon Schwartz <schwartz.xn@gmail.com>
Date: Thu, 7 Sep 2017 18:13:24 -0600
Message-ID: <CADAGN7X+kH82jxchxxZmim05rd7FcLS35uU2Kzf=5WaqdY5zyw@mail.gmail.com>
Subject: 'No I/O performed by libaio' error
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Running the following job file with --io_submit_mode=offload set will
occasionally give a 'No I/O performed by libaio' error

Using the latest FIO version (fio-3.0-48-g83a9)

[128k-RR-64k-RW-q1]
filename=/dev/sdb
direct=1
iodepth=1
rw=randrw
bs=128k,64k
rwmixread=50
ioengine=libaio
io_submit_mode=offload
runtime=15m

After a few minutes of running FIO will exit with the following
message:  "No I/O performed by libaio, perhaps try --debug=io option
for details"

With debug set, I see this near the end of the trace:

io       7720  io complete: io_u 0x55e10ee4abc0:
off=1304219746304/len=65536/ddir=1io       7720  //dev/sdbio
7720
io       7720  fill_io_u: io_u 0x55e10ee4abc0:
off=233107357696/len=0/ddir=0io       7720  //dev/sdbio       7720
io       7720  get_io_u: zero buflen on 0x55e10ee4abc0
io       7720  get_io_u failed
io       7720  io_u 0x55e10ee4abc0, setting file failed
io       7720  get_io_u failed
io       7720  close ioengine libaio
io       7720  free ioengine libaio
io       7720  close ioengine libaio
io       7720  free ioengine libaio

Any ideas?

Regards,
Brandon
