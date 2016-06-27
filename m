Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36746 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbcF0UmM (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Jun 2016 16:42:12 -0400
Received: by mail-lf0-f48.google.com with SMTP id q132so164178631lfe.3
        for <fio@vger.kernel.org>; Mon, 27 Jun 2016 13:42:12 -0700 (PDT)
MIME-Version: 1.0
From: Srinath Krishna Ananthakrishnan <ska@datera.io>
Date: Mon, 27 Jun 2016 13:41:56 -0700
Message-ID: <CAOkRmkmnoHqBoKP2VYiY9LLJYfADK6moZdK_t1VOedDd670Aeg@mail.gmail.com>
Subject: Compression options in fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm fiddling around with some compression options in fio but I don't
seem to get it working.

From the fio manual, I see that the following options are supported by fio.

buffer_compress_percentage, buffer_compress_chunk, buffer_pattern

I have the following workload configuration,

[global]
randrepeat=1
ioengine=sync
iodepth=64
iodepth_batch=16
direct=1
runtime=5
time_based=1
numjobs=1
verify_fatal=1
verify_dump=1
filename=./my_file

[small_write]
rw=rw
blocksize=4k
size=100M
verify=crc32c-intel
buffer_compress_percentage=50
buffer_pattern="abcd"

With this, I don't see fio generating compressible data with the
pattern and still reverts to generating random data. Anything I'm
missing?

Thanks,
Srinath
