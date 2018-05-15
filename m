Return-Path: <fio-owner@vger.kernel.org>
Received: from fukushima.klipix.org ([85.12.144.25]:41716 "EHLO
        fukushima.klipix.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753819AbeEOPaO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 May 2018 11:30:14 -0400
Received: from [192.168.1.247] (modemcable077.38-81-70.mc.videotron.ca [70.81.38.77])
        by fukushima.klipix.org (Postfix) with ESMTPSA id 701B5460575
        for <fio@vger.kernel.org>; Tue, 15 May 2018 17:20:25 +0200 (CEST)
From: Julien Desfossez <ju@klipix.org>
Subject: io_submit depth
Message-ID: <6c4cdf73-b7d9-7843-8061-86646c20ef02@klipix.org>
Date: Tue, 15 May 2018 11:20:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

When stracing fio running on Linux (4.13) with libaio engine, I saw that 
only one request is sent in the io_submit system call regardless of the 
iodepth parameter value.

To see this:
strace -f fio --name=tmp --filename=/tmp/fio --filesize=8G \
--ioengine=libaio --bs=4k --iodepth=32 --rw=randwrite \
--runtime=10 2>&1 | grep io_submit

All of the lines look like this:
io_submit(140287955259392, 1, [{pwrite, fildes=3, str="...", 
nbytes=4096, offset=1035223040}]) = 1

I would have expected to see the second parameter to be 32.

I see that the iodepth parameter has an impact in how many requests are 
sent at the beginning (in this example, I see 32 requests sent), but 
after that the requests are sent one by one as soon as one completes. I 
understand this is done to keep the number of "requests in flight" 
steady, but this is not what I expected when setting iodepth.

So is there a way to run fio so that we can send multiple requests per 
io_submit call ?

Thanks,

Julien
