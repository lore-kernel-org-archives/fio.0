Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36635 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967179AbdDZUTV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Apr 2017 16:19:21 -0400
Received: by mail-oi0-f43.google.com with SMTP id w12so14631710oiw.3
        for <fio@vger.kernel.org>; Wed, 26 Apr 2017 13:19:21 -0700 (PDT)
From: Bryan Gurney <bgurney@permabit.com>
MIME-Version: 1.0
Date: Wed, 26 Apr 2017 16:19:19 -0400
Message-ID: <07fa4af4953de5cca876fdc266a4356c@mail.gmail.com>
Subject: Running fio with buffer_compress_percentage=0 and scramble_buffers=1
 produces high-dedupe data
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I found an issue with a number of fio versions (2.2.8, 2.11, and
fio-2.19-14-g306f) where a configuration with both
"buffer_compress_percentage=0" and "scramble_buffers=1" results in data
buffer content with very low compressibility, but very high dedupability.

In a fio test run, I was using the "buffer_compress_percentage" and
"dedupe_percentage" parameters to alter the compressibility and
dedupability of the data buffers.  I wanted to create a "control"
configuration that would produce random, scrambled buffer content that
would result in no dedupe, and no compression.  Working backward from my
other configurations, I constructed the configuration below, with the
following intentions:

- Set compression to 0 percent, which should match fio's default buffer
pattern.
- Remove the "dedupe_percentage" line, and leave "scramble_buffers=1" to
prevent dedupe, since the default fio behavior is to reuse buffers.

[globals]

bs=4096
rw=write
name=write_1G_control_scrambled
numjobs=1
size=1g
norandommap
randrepeat=1
group_reporting
unlink=0
direct=1
iodepth=128
iodepth_batch_complete=16
iodepth_batch_submit=16
ioengine=libaio
scramble_buffers=1
buffer_compress_percentage=0
buffer_compress_chunk=4096

[thread1]
filename=/dev/sdc

The result of the write was 1 GB of data, which exhibited nearly 100%
dedupe, but was almost incompressible.  On examination with "hexdump -C",
the resulting data does not exhibit the "buffer modifications"
characteristic of the scramble_buffers option.

I wondered if this was related to the existence of the
"buffer_compress_percentage=0" and "buffer_compress_chunk=4096" lines, so
I removed those two lines, resulting in the following configuration:

[globals]

bs=4096
rw=write
name=write_1G_control_scrambled
numjobs=1
size=1g
norandommap
randrepeat=1
group_reporting
unlink=0
direct=1
iodepth=128
iodepth_batch_complete=16
iodepth_batch_submit=16
ioengine=libaio
scramble_buffers=1

[thread1]
filename=/dev/sdc

The result of this write was 1 GB of data, with 0% dedupe and 0%
compression.  On examination with "hexdump -C", the resulting data
exhibits the "buffer modifications" characteristic of the scramble_buffers
option.

The behavior above seems to suggest that the "buffer_compress"
functionality is mutually exclusive of the "scramble_buffers=1" setting.

I performed some tests for various non-zero values of
"buffer_compress_percentage", and the resulting data was not dedupable
(which would be consistent with the behavior of "scramble_buffers=1", but
the data pattern seems to suggest that the algorithm used in
scramble_buffers is not being used.  Comparing this to when
buffer_compress_percentage is set to zero, the resulting data is almost
incompressible, but exhibits a high frequency of dedupe.  This is despite
the intentions of the user's configuration for buffer data content of 0%
compression, and scrambled to avoid dedupe.


Thanks,

Bryan Gurney
