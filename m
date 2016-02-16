Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34892 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbcBPIT6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Feb 2016 03:19:58 -0500
Received: by mail-io0-f179.google.com with SMTP id g203so157723988iof.2
        for <fio@vger.kernel.org>; Tue, 16 Feb 2016 00:19:57 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 16 Feb 2016 16:19:57 +0800
Message-ID: <CABtFm2WPnKVVBVPU0N97ipX=RTAVK7Tz0nJUNtAmS9chLw3nHw@mail.gmail.com>
Subject: client/server mode fails with Assertion `client->eta_in_flight = eta' failed
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>

I started FIO in client/server mode with two clients running 24 jobs
each on individual LUNs. After a while, FIO fails with the following
assertion, even though the jobs are still running on both the clients.

# fio --client=client1 --remote-config=/root/all_powerpath.fio
--client=client2 --remote-config=/root/all_multipaths.fio
hostname=client1, be=0, 64-bit, os=Linux, arch=x86-64,
fio=fio-2.6-13-g8a76, flags=1
hostname=client2, be=0, 64-bit, os=Linux, arch=x86-64,
fio=fio-2.6-13-g8a76, flags=1

<client2> readwrite-mpatha-8k-para: (g=0): rw=randrw, <client1>
readwrite-emcpowera-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
ioengine=libaio, iodepth=8
<client2> readwrite-mpathb-8k-para: (g=0): rw=randrw, <client1>
readwrite-emcpowerb-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
ioengine=libaio, iodepth=8
<client2> readwrite-mpathc-8k-para: (g=0): rw=randrw, <client1>
readwrite-emcpowerc-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
ioengine=libaio, iodepth=8
<client2> readwrite-mpathd-8k-para: (g=0): rw=randrw, <client1>
readwrite-emcpowerd-8k-para: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
ioengine=libaio, iodepth=8

<<< Omit other info >>>

<client2> Starting 24 processes
<client1> Starting 24 processes

client <client1>: timeout on SEND_ETA/405.7M/0K /s] [51.2K/50.7K/0
iops] [eta 02d:23h:59m:49s]
fio: client: unable to find matching tag (dbebe0)2M/0K /s]
[60.8K/58.6K/0 iops] [eta 02d:23h:59m:54s]
fio: client.c:1241: handle_eta: Assertion `client->eta_in_flight == eta' failed.
Aborted

# fio --version
fio-2.6-13-g8a76

Also sometimes the job information gets mixed up from both the clients
as above.

Thanks for your support.
--
Srinivasa R Chamarthy
