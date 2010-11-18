Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63128 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab0KRVNm (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 18 Nov 2010 16:13:42 -0500
Received: by gxk23 with SMTP id 23so2206867gxk.19
        for <fio@vger.kernel.org>; Thu, 18 Nov 2010 13:13:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimn=cJXQN-=wC4v8AeMEYGXUUfrM5nvVMzLkwEY@mail.gmail.com>
References: <AANLkTimn=cJXQN-=wC4v8AeMEYGXUUfrM5nvVMzLkwEY@mail.gmail.com>
From: Dan Le <wb.danle@gmail.com>
Date: Thu, 18 Nov 2010 16:13:26 -0500
Message-ID: <AANLkTiknYzSOx8Othcvb4UA=Vvyb4WTPd8jy9t-2CV+b@mail.gmail.com>
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
incurred overhead. Please help.

Thank you,

Dan
