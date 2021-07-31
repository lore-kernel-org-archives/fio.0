Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbhGaPJ4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 31 Jul 2021 11:09:56 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA8DC06175F
        for <fio@vger.kernel.org>; Sat, 31 Jul 2021 08:09:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso1297123wmq.3
        for <fio@vger.kernel.org>; Sat, 31 Jul 2021 08:09:49 -0700 (PDT)
MIME-Version: 1.0
From: CED17I048 SJ HARINI <ced17i048@iiitdm.ac.in>
Date: Sat, 31 Jul 2021 15:09:36 +0530
Message-ID: <CAPJkFLYrwOx+fdSLPij8eqF09wZ7nfTS3m-7UCce8_Y0ZRHBXA@mail.gmail.com>
Subject: Guidance to learn more about fio tool
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I came across the FIO tool recently, and wish to contribute to this
open source project. But before that I want to better understand how
the tool works, and the underlying logic it uses for various job
parameters and options. I am a university student and would love to
take up this project and contribute.
I was wondering that building a debug version of the project would
help me understand different sections of the code. I have never worked
on a big project in open source, and would be grateful for guidance
from the community. I am a beginner and I apologize if my questions
are unclear or sound trivial and silly. I am really passionate about
learning more about how the tool works, the logic it uses and
contributing. I hope this is the right place to send emails containing
doubts regarding fio.

What have I done so far to understand the tool and the source code better:
1) Tried running  fio (installed using : sudo apt-get install fio)
from command line (ubuntu) with --debug=all.
    A lot of log information was printed in the terminal.
2) Cloned the source code from github fio repository. Installed
sourcetrail and indexed all the files in fio-master. But there were
many errors while indexing the files, so the visualization was
somewhat incomplete. In case anyone has tried using sourcetrail, would
love to know your experience.
3) Tried running many test jobs using fio.
4) Read up various resources available online about using fio and
understanding its output.

Some doubts:
1) To understand the underlying logic about how the tool works, what
concepts should I learn about prior? - From my reading about the fio
tool, I came across AIO engine, nvme and learned that the hard
disk/storage device also contains a hardware cache. So sometimes when
we want to stress the hard disk/spin disk, we are actually stressing
the cache. How do I disable the hardware cache using the fio tool ?
Will --validate or --direct parameters take care of this ?
2) I also came across some tools like IOStat, IO Meter, for storage
device performance. How is FIO superior to these tools?
3) When I run fio for random read and set the file option : example :
--size = 20M, a file is created, which is not readable (i'm guessing
it is a binary file). What does this file contain?
And why is a file getting created even if rw is set to read? How to
read this test file created by fio? My understanding is that FIO reads
and writes random data using a random number generator, so shouldn't
the data be readable.
4) Is there any design diagram or documentation to understand the
logic of how fio works?
5) How do I create a debug version of fio source code ? I was hoping
that using breakpoints and debugging may help me identify the flow of
the code.
6) How to find the optimal io depth? Is queue depth same as fio iodepth?
7) For zonemode = strided, does zonesize represent the stride length?
My understanding of stride length is the gap between each read/write.
8) I wanted to check if whatever data was written is correct or not,
so I ran the basic-verify.fio job file. But I didn't get any output
saying the data written was also read, and that there were no errors.
How do I know if there were errors ?

If you could recommend any useful resources to better my
understanding, that would be highly appreciated.
Even though I do not have a clear understanding of how the tool works,
I am eager to learn as much as possible and hope to gain an enriching
learning experience.
I hope to gain a good understanding of the tool and want to create a
documentation with flowchart of how fio works as my first contribution
(so it's easier for complete beginners like me to understand better)
Thank you for taking the time and reading this mail, awaiting your response.

Thanks and regards
Harini
CS student

