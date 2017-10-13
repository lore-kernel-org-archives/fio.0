Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:53462 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdJMUb4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Oct 2017 16:31:56 -0400
Received: by mail-qt0-f176.google.com with SMTP id n61so21796603qte.10
        for <fio@vger.kernel.org>; Fri, 13 Oct 2017 13:31:56 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Fri, 13 Oct 2017 13:31:14 -0700
Message-ID: <CAKwzdDo7ub14AmQBmJu9J5rOuSDnxEAVp1w2gkDo=5stkzS31A@mail.gmail.com>
Subject: fio LBA span query
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

All,
I want  to ensure that unique thread targeted the given LBA span, is
there a way to achieve it using "raw" drive

[thread1]
size= LBA 0-50%

[thread2]
size= LBA 51-80%

[thread3]
size= 80-20%

Another thing:
When FIO start a workload e.g. Random Read does it always starts from LBA0
i.e.
random_wr = size 100% (dirve written in a given pattern)
then.

random rd 4k [ LBA 0 ....]
stonewall
random rd 8k  [ Will this also start from LBA 0 or pick some random
offset for start]

Appreciate your support here .

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
