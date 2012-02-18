Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46196 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2BRBTY (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Feb 2012 20:19:24 -0500
Received: by qadc10 with SMTP id c10so1446764qad.19
        for <fio@vger.kernel.org>; Fri, 17 Feb 2012 17:19:23 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Fri, 17 Feb 2012 17:19:03 -0800
Message-ID: <CAAUT-yOi26hzpOdzCbSDTS9AE_y96USLK25LVYvfzCFP5skJ4g@mail.gmail.com>
Subject: Something odd with the fio random offset generator & time_based runs
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

While experimenting with some IO loads, I noticed that the random
offset selection wasn't as random as it should be.  I started looking
for something complicated thinking maybe it had to do with large
devices.  But when I took a step back and tried a simpler test, I
found it applied to any size.

Using a random map masks the problem because it is forced to cover all
the offsets.  But for IO loads on large devices with multiple jobs,
random maps aren't useful.

Here's a simple demonstration on Linux.  (Linux only because it uses
the special /proc/self/fd files.  It can work on other OSs by writing
to a normal file or pipe and running the rest of the command on that
file/pipe.)

First, with a random map...
$ ./fio --name=test --rw=randread --iodepth=1 --ioengine=null --thread
--bs=128 --size=1k --runtime=6 --time_based
--write_iolog=/proc/self/fd/1 | grep 'test.1.0 read' | sort | uniq -c
 184946 test.1.0 read 0 128
 184945 test.1.0 read 128 128
 184945 test.1.0 read 256 128
 184946 test.1.0 read 384 128
 184945 test.1.0 read 512 128
 184946 test.1.0 read 640 128
 184945 test.1.0 read 768 128
 184945 test.1.0 read 896 128

As expected, it is pretty evenly spread.  But now without a random map...
$ ./fio --name=test --rw=randread --iodepth=1 --ioengine=null --thread
--bs=128 --size=1k --runtime=6 --time_based --norandommap
--write_iolog=/proc/self/fd/1 | grep 'test.1.0 read' | sort | uniq -c
 188409 test.1.0 read 0 128
 565224 test.1.0 read 256 128
 188408 test.1.0 read 384 128
 565224 test.1.0 read 640 128

Even with a random map, this has an impact.  The offsets which are
favored by the RNG will always be used first, before those unfavored.
Notice that the 3 offsets that got an extra IO were all in the set
returned in the second test.  (Offsets 0, 384 and 640.)

This is not a new regression either.  I tried using the OS random flag...
$ ./fio --name=test --rw=randread --iodepth=1 --ioengine=null --thread
--bs=128 --size=1k --runtime=6 --time_based --norandommap
--use_os_rand=1 --write_iolog=/proc/self/fd/1 | grep 'test.1.0 read' |
sort | uniq -c
 558950 test.1.0 read 0 128
 372632 test.1.0 read 384 128
 558949 test.1.0 read 512 128

And when I tried going to an old 1.x release before the random
changes, it was identical to the use_os_rand flag.
