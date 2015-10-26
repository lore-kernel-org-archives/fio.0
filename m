Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33741 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbbJZMDu (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 26 Oct 2015 08:03:50 -0400
Received: by iodd200 with SMTP id d200so20292889iod.0
        for <fio@vger.kernel.org>; Mon, 26 Oct 2015 05:03:50 -0700 (PDT)
MIME-Version: 1.0
From: Hyukjoong Kim <wangmir@gmail.com>
Date: Mon, 26 Oct 2015 21:03:30 +0900
Message-ID: <CAAkw5-Md8HWx4oQtB1Yy43RgiCJ11uAqBdCawbb_v28z7rxQJg@mail.gmail.com>
Subject: error on using fio trace replay
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

<div dir="ltr"><span style="font-size: 14px;">Hi,</span><div
style="font-size: 14px;"><br></div><div style="font-size: 14px;">I'm
trying to replay iolog using fio iolog, but i failed with
that.</div><div style="font-size: 14px;"><br></div><div
style="font-size: 14px;">simply, I check the example trace with
write_iolog option, and I got trace like this,</div><div
style="font-size: 14px;">--------------</div><div style="font-size:
14px;"><div>fio version 2 iolog</div><div>/mnt/test/rand-write.1.0
add</div><div>/mnt/test/rand-write.1.0
open</div><div>/mnt/test/rand-write.1.0 read 64757760
4096</div><div>/mnt/test/rand-write.1.0 read 794873856
4096</div><div>/mnt/test/rand-write.1.0 read 905355264
4096</div><div>/mnt/test/rand-write.1.0 write 504672256
4096</div><div>-------------</div><div>So, I make a new trace with
similar format like this</div><div>-------------</div><div><div>fio
version 2 iolog</div><div>/dev/sdb open</div><div>/dev/sdb write 4096
4096</div></div><div>------------</div><div>However, I failed to
replay both with different error.</div><div><br></div><div>Firstly, I
ran extracted file (fio --name test --read_iolog=trace
--replay_redirect=/dev/sdb), but error was like
this,</div><div>------------------------------<wbr>--------------</div><div>test:
(g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync,
iodepth=1</div><div><div>fio-2.0.10</div><div>Starting 1
process</div><div>bad iolog2: fio version 2 iolog</div><div>fio:
pid=14839, got signal=11</div><div><br></div><div><br></div><div>Run
status group 0 (all
jobs):</div></div><div>------------------------------<wbr>--------------&nbsp;</div><div><br></div><div>and
if I delete the first line than, fio said don't support iolog
1</div><div><br></div><div><br></div><div>Secondly, I ran the file I
made with same command, and error was different from
former,</div><div><br></div><div>------------------------------<wbr>----------</div><div>test:
(g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync,
iodepth=1</div><div><div>fio-2.0.10</div><div>Starting 1
process</div><div>fio: pid=12868, got
signal=11</div><div><br></div><div><br></div><div>Run status group 0
(all jobs):</div></div><div>------------------------------<wbr>--------------------</div><div><br></div><div>I
think fio was killed by someone, but I don't know
why.</div><div><br></div><div>So,, how can I fix this problem? I tried
this behavior with apt repository fio, and current git, and fio 2.0.10
also, but error was
same.</div><div><br></div><div>Thnks,</div><div>Hyukjoong</div></div>
</div>
