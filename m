Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:37350 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3APPCb (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Jan 2013 10:02:31 -0500
Received: by mail-vb0-f48.google.com with SMTP id fc21so1383855vbb.35
        for <fio@vger.kernel.org>; Wed, 16 Jan 2013 07:02:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB-428kduvROVr6oqVYsBaZAEA0WqUddLiB=yNiJNTw_TdYM0g@mail.gmail.com>
References: <CAB-428kduvROVr6oqVYsBaZAEA0WqUddLiB=yNiJNTw_TdYM0g@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Wed, 16 Jan 2013 09:01:50 -0600
Message-ID: <CAB-428k3dw2TLm_5-7ELzdffCNpHb02ZSzsK73=GD-YVkOgWWA@mail.gmail.com>
Subject: Multi-thread vs. Single-thread job config
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello

I am running fio on the top of raw block device with following two
configurations and I saw the first config (single threaded) can put
more load on the underlying storage system compared to second config
(with 4 thread). However, I expected to see the opposite side (more IO
load with multiple job compared to single job). Does it make sense to
you ? Is there any locking or handshaking between multiple jobs in the
second config that reduce the IO injection rate of fio ?

; -- start job Config 1 file --
[global]
rw=write
size=5G

[job1]
ioengine=libaio
iodepth=8192
bs=4k
direct=1
numjobs=1
directory=/dev
filename=sdp
; -- end job file --
------------------------------------------------

; -- start job Config 2 file --
[global]
rw=write
size=5G

[job1]
ioengine=libaio
iodepth=8192
bs=4k
direct=1
numjobs=4
directory=/dev
filename=sdp
; -- end job file --
