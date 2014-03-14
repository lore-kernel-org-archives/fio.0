Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56832 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaCNPwb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 14 Mar 2014 11:52:31 -0400
Received: by mail-ve0-f180.google.com with SMTP id jz11so2941503veb.11
        for <fio@vger.kernel.org>; Fri, 14 Mar 2014 08:52:30 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Mar 2014 08:52:30 -0700
Message-ID: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>
Subject: Possible bug when setting compression
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I have been testing iops performance using different compression
settings and found that setting either zero_buffers or
buffer_compress_percentage was not enough, I had to also set
scramble_buffers=0 in order to get the desired compression.  But this
was not the case when setting refill_buffers.  I tested with fio 2.1.5
and fio from git (fio-2.1.6.1-10-g4e59d).

My job file:

[global]
bs=4k
ioengine=libaio
iodepth=32
direct=1
size=8g
time_based
filename=/dev/sdf

#scramble_buffers=0
#refill_buffers
zero_buffers
#buffer_compress_percentage=100

[rand-write-iops]
rw=randwrite
runtime=10
stonewall

My results:

scramble_buffers=0
buffer_compress_percentage=100
iops=83254

scramble_buffers=0
buffer_compress_percentage=0
iops=51137

scramble_buffers=1
buffer_compress_percentage=100
iops=69639

scramble_buffers=1
buffer_compress_percentage=0
iops=69429

-----

scramble_buffers=0
zero_buffers
iops=83339

scramble_buffers=1
zero_buffers
iops=69510

-----

scramble_buffers=0
refill_buffers
iops=50774

scramble_buffers=1
refill_buffers
iops=50813
