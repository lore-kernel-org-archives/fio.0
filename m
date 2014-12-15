Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.190]:54004 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOL4t convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 15 Dec 2014 06:56:49 -0500
Received: from iris.intern.thomas-kren.com (iris.intern.thomas-krenn.com [192.168.110.42])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 5F9F1A1A6E
	for <fio@vger.kernel.org>; Mon, 15 Dec 2014 12:48:21 +0100 (CET)
Received: from zimbra.thomas-krenn.com (zimbra.thomas-krenn.com [192.168.110.28])
	by iris.intern.thomas-kren.com (Postfix) with ESMTP id 40F953FD0F
	for <fio@vger.kernel.org>; Mon, 15 Dec 2014 12:48:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 3EE311A84004
	for <fio@vger.kernel.org>; Mon, 15 Dec 2014 12:48:21 +0100 (CET)
Date: Mon, 15 Dec 2014 12:48:20 +0100 (CET)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com>
In-Reply-To: <298214297.62025.1418642489614.JavaMail.zimbra@thomas-krenn.com>
Subject: SSD write latency lower than read latency
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Fio users and Jens,

I am currently analyzing read and write latencies of Solid State Disks (SSDs). My assumption was that
write latencies are usually higher than read latencies. But my tests with Fio on an Intel DCS3500 show 
that average latency while writing is lower than while reading (using fio-2.1.3):

* $ sudo /usr/bin/fio --rw=randrw --name=intelDCS3500 --bs=4k --direct=1 --filename=/dev/sda --rwmixread=0
    --numjobs=1 --ioengine=libaio --runtime=60 --iodepth=1 --time_based 
    [...]
    lat (usec): min=30, max=1010, avg=43.32, stdev= 3.42
    [...]
* $ sudo /usr/bin/fio --rw=randrw --name=intelDCS3500 --bs=4k --direct=1 --filename=/dev/sda --rwmixread=100
    --numjobs=1 --ioengine=libaio --runtime=60 --iodepth=1 --time_based 
    [...]
    lat (usec): min=103, max=2315, avg=121.92, stdev=11.02

I have made this observation on two different machines with different SSDs, always producing similar results.
Am I doing anything wrong with my tests?
Are write latencies in general lower than read latencies?

One guess I have is a SSD cache to enhance write access (in particular the Intel datacenter SSDs, as they have
a "Enhanced power-loss data protection" feature).

Thanks a lot, Georg
-- 
: Georg Schönberger
: Web Operations & Knowledge Transfer
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki
