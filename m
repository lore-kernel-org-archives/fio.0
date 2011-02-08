Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41628 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab1BHKa4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Feb 2011 05:30:56 -0500
Received: by wwa36 with SMTP id 36so5854092wwa.1
        for <fio@vger.kernel.org>; Tue, 08 Feb 2011 02:30:55 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Feb 2011 10:30:55 +0000
Message-ID: <AANLkTimVOrLR+MJDhg5Q=vfLvNKbfP4H6i3iJNjxPgpe@mail.gmail.com>
Subject: FIO is CPU bound on small block sizes
From: "Bike & Snow" <bikeandsnow@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello

I am trying to measure IOPs on a RAID system using FIO.

I've been using FIO for a while and I'm pretty familiar with it.

However, I have found for small blocksizes, the benchmark is CPU bound
as it only works on a single CPU core.

Here's what I mean. All these are sequential read results.

Iometer results:
512B	181,317
1K		166,232
2K		133,753
4K		109,498
8K		 78,276
16K		 51,638

FIO results:
512B	 97,494
1K		100,034
2K		 98,615
4K		 93,859
8K		 83,064
16K		 69,623

I can see when observing the output from "top" that the "fio" thread
is at 99% for the smaller block sizes.
So it appears to be CPU bound for small block sizes - 512B to 4K.
From 8K onwards FIO is actually faster than Iometer.

Software:
Linux 2.6.36.3
FIO 1.50
Iometer 1.1.0

Hardware:
Intel Xeon X3450 @ 2.67GHz
Hardware RAID6 array

FIO command used:
fio -name iops -rw=read -bs=512 -runtime=180 -iodepth 4 -filename
/dev/storage/iometer -ioengine libaio -direct=1

As you can see I'm testing the block device directly without using a
file system.

I have tried different iodepth values but it makes no difference.

Any ideas on how I can measure the IOPs of the RAID device when using
small block sizes?

I really want to use FIO as I can script it.
