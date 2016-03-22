Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38758 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbcCVOGf (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 22 Mar 2016 10:06:35 -0400
Received: by mail-ig0-f172.google.com with SMTP id ig19so90711354igb.1
        for <fio@vger.kernel.org>; Tue, 22 Mar 2016 07:06:35 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Mar 2016 22:06:34 +0800
Message-ID: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
Subject: Linux OS killed fio process because fio invoked oom_killer
From: flash yan <flashyan83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I have run fio-2.7 to test iscsi device, one unusual issue happened.
If I set the io_size to 4096, queue_depth to 16 ,rw to randwrite and
run_time to 3000,
the fio would invoke oom_killer and the Linux OS would kill the fio process.
The machine have about 11 GB memory and I have tried the machine with
23GB, the issue also happened.
I think fio have problem when dealing with 4KB io_size then used too
many memory.

Thanks

Liang Yan
