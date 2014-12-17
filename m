Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43485 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaLQU4Q (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Dec 2014 15:56:16 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so21299304wgg.11
        for <fio@vger.kernel.org>; Wed, 17 Dec 2014 12:56:15 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 17 Dec 2014 22:56:14 +0200
Message-ID: <CACTTzNb+KW+9sL8_d3X2=b4m96-V0e4j7Z4NwFpmdrjSdirxkw@mail.gmail.com>
Subject: Questions about mmap ioengine
From: Yigal Korman <yigal@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I have a couple of questions regarding the mmap ioengine.

One of the benefits of doing mmap() VS write() is bypassing the need
of an intermediate buffer.
Instead of preparing a buffer for write(), data can be written
directly to file with mmap().
I want to do some performance comparisons on this subject with fio on
different filesystems.
After reviewing the code a bit, I saw that the mmap ioengine is only
responsible for writing the data.
The buffer preparation is done in the common code the same way for all
ioengines.
Am I understanding this correctly?
Is there another way to circumvent the buffer filling and implement
writing data directly with mmap?

Another question relates to mmap and the 'time_based' fio parameter.
I want to see how mmap behaves for repeated random access where the
initial page fault has less impact.
But I would like the repeats be on the workset and not on individual
accesses (i.e. write randomly to file, then write again with the same
pattern). This is because I do want to see TLB misses on repeated
access but not page faults.
I tried running fio with --time_based --runtime=<big enough to ensure
several repeats>.
I saw that indeed the workset was repeated but the results didn't make sense.
So again, I reviewed the code and saw that the mmap ioengine will
munmap() between each iteration of the workset, which in turn will
cause a page fault on each repeated access.
Was I wrong to use 'time_based' parameter for this scenario?
Does it make any sense to add a parameter for the mmap ioengine not to
munmap between iterations? or do something else?

I apologize for the lengthy descriptions,
Thanks in advance,
Yigal
