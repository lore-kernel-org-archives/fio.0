Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37709 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbcBPJVg (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Feb 2016 04:21:36 -0500
Received: by mail-ig0-f172.google.com with SMTP id 5so73770735igt.0
        for <fio@vger.kernel.org>; Tue, 16 Feb 2016 01:21:36 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 16 Feb 2016 17:21:36 +0800
Message-ID: <CABtFm2WgQ6j-XiYPxOLt=xoR_LdzsfhPLKMqqTdAWaObkGYugQ@mail.gmail.com>
Subject: client/server mode - thread count of only one client is shown in the
 job status
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

While running FIO in client/server mode with two clients where in each
of the client spawns 24 threads/jobs, the FIO status only shows the
thread count from one client.

In the below example, the thread count should show 48, instead of
"[m(24)]". Please correct me if i am wrong.

# fio --client=client1 --remote-config=/root/all_powerpath.fio
--client=client2 --remote-config=/root/all_multipaths.fio
hostname=client2, be=0, 64-bit, os=Linux, arch=x86-64,
fio=fio-2.6-13-g8a76, flags=1
hostname=client1, be=0, 64-bit, os=Linux, arch=x86-64,
fio=fio-2.6-13-g8a76, flags=1
<client1> readwrite-emcpowera-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerb-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerc-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerd-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowere-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerf-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerg-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerh-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpoweri-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerj-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerk-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerl-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerm-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowern-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowero-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerp-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerq-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerr-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowers-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowert-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpoweru-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerv-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerw-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> readwrite-emcpowerx-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpatha-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathb-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathc-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathd-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathe-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathf-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathg-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathh-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathi-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathj-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathk-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathl-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathm-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathn-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpatho-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathp-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathq-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathr-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpaths-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpatht-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathu-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathv-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathw-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client2> readwrite-mpathx-8k-para: (g=0): rw=randrw,
bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=8
<client1> Starting 24 processes
<client2> Starting 24 processes
Jobs: 48 (f=48): [m(24)] [0.0% done] [270.5M/266.6M/0K /s]
[33.9K/33.4K/0 iops] [eta 02d:23h:59m:48s]

--
Srinivasa R Chamarthy
