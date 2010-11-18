Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64814 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab0KRT6p (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 18 Nov 2010 14:58:45 -0500
Received: by gwj17 with SMTP id 17so2131525gwj.19
        for <fio@vger.kernel.org>; Thu, 18 Nov 2010 11:58:45 -0800 (PST)
MIME-Version: 1.0
From: Dan Le <wb.danle@gmail.com>
Date: Thu, 18 Nov 2010 14:58:24 -0500
Message-ID: <AANLkTimn=cJXQN-=wC4v8AeMEYGXUUfrM5nvVMzLkwEY@mail.gmail.com>
Subject: How to flush the writing cache before a test with read
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Greetings,

FIO needs to write data files in order to read them. Without disabling
the write-cache of the disk, I was wondering if there's a way to flush
these data cache to disk right before FIO starts to read these files.

I don't want to run every second "sync && echo 3 >
/proc/sys/vm/drop_caches" at the same time with FIO because of its
incurred overheads. Please help.

Thanks,

Dan
