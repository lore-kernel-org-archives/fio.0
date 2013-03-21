Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53708 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3CUCxz (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 20 Mar 2013 22:53:55 -0400
Received: by mail-wi0-f175.google.com with SMTP id c10so701695wiw.2
        for <fio@vger.kernel.org>; Wed, 20 Mar 2013 19:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHUxXBCZLAEHqvwZ2Cb0M=KwCOt6W+2WijwAk=tPK-HVKWtg0Q@mail.gmail.com>
References: <CAHUxXBCZLAEHqvwZ2Cb0M=KwCOt6W+2WijwAk=tPK-HVKWtg0Q@mail.gmail.com>
From: Shengkai Zhu <geniusjash@gmail.com>
Date: Thu, 21 Mar 2013 10:53:34 +0800
Message-ID: <CAHUxXBCwa55Y+ZE37NJ1BQrhVh+P42r8hq2D8u0YLu53MnEbPw@mail.gmail.com>
Subject: [Bug?] 3Gb and 6Gb mixed measurement
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: geniusjash@gmail.com

 Hi all,

      OS: RHEL 6.3; Kernel: 2.6.32-279.el6.x86_64
      4 x 6Gb/s SSD: 2 on 3Gb/s SATA, 2 on 6Gb/STA
      fio-2.0.14

      fio --name=rand --filename=/dev/sda:/dev/sdb:/dev/sdc:/dev/sdd
 --ioengine=libaio --direct=1 --runtime=60 --blocksize=4K --rw=randread
 --iodepth=8 --numjobs=128 --group_reporting

      I have this unreasonable performance while testing with 3Gb SATA and
 6Gb SATA together. 6Gb drive seems degraded to 3Gb perf when tested them
 mixed. And the performance is normal while I measured 6Gb and 3Gb in two
 seperate fio command lines concurrently.

 Run                   r/w mix         rand/seq     iops
2 x 6Gb SSD      100% read       RAND     158000
2 x 3Gb SSD      100% read       RAND     100000
4 SSD 1 fio         100% read       RAND     205000
4 SSD con 2 fio   100% read       RAND    260000

    Not sure whether this is a bug in fio...

 --
Regards,
Jash Zhu
