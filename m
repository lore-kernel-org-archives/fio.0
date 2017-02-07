Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:36412 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdBGIVU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2017 03:21:20 -0500
Received: by mail-pg0-f54.google.com with SMTP id v184so36784786pgv.3
        for <fio@vger.kernel.org>; Tue, 07 Feb 2017 00:21:20 -0800 (PST)
Received: from [192.168.163.17] (125-227-238-55.HINET-IP.hinet.net. [125.227.238.55])
        by smtp.gmail.com with ESMTPSA id 82sm8636571pge.42.2017.02.07.00.21.18
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2017 00:21:18 -0800 (PST)
From: YHM <yanghm@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Fio will crash by output folder is not exist when running
 server-client mode
Message-Id: <2C0BC02B-C3D8-4C11-912F-51BFDB96007D@gmail.com>
Date: Tue, 7 Feb 2017 16:21:16 +0800
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I use fio to do my server disk benchmark. I want to do the distributed =
test and I run fio server-client mode.
When I assign --output to create result log file, the client will fault =
when the target path did not exist.

1) A description of what you think the bug is
When I run the server-client mode, should only server node create output =
log is enough. Client just need run the script and return result only.
But seems like client create output file too. When I assign a invalid =
path for output file, server node can block operation correct, but =
client will core dumped

2) Environment (Linux distro version, kernel version). This is mostly =
needed if it's a build bug.
3) The output from fio --version.
=10Server node is  Ubuntu 16.04.1, fio version is fio-2.17-34-g9d25d
Client node is Ubuntu 12.04, fio version fio-2.17


4) How to reproduce. Please include a full list of the parameters passed =
to fio and the job file used (if any).
a. Login to fio client node, type "fio --server &" to listening request
b. Login to fio server node, mkdir "fiooutput" for put logfile
c. In fio server node, type fio --client=3D<fio client ip> =
~/git/fio/examples/cpuio.fio --output=3Dfiooutput.log, this job should =
success and create fiooutput.log in both node (in server node had a 754 =
byte logfile, in client node had a 0 byte logfile)
d. In fio server node, type fio --client=3D<fio client ip> =
~/git/fio/examples/cpuio.fio =
--output=3D/root/errorrfolder/fiooutput.log,this job will fault and =
server node will response "fopen output: No such file or directory"
e. In fio server node, type fio --client=3D<fio client ip> =
~/git/fio/examples/cpuio.fio --output=3D/root/fiooutput/fiooutput.log,this=
 job will not show any thing in server node, but client node will fault =
and core dumped.


In server node:
root@hmvm01:~# mkdir fiooutput
root@hmvm01:~# fio --client=3D192.168.160.144 =
~/git/fio/examples/cpuio.fio --output=3Dfiooutput.log
root@hmvm01:~# fio --client=3D192.168.160.144 =
~/git/fio/examples/cpuio.fio --output=3D/root/errorfolder/fiooutput.log
fopen output: No such file or directory
root@hmvm01:~# fio --client=3D192.168.160.144 =
~/git/fio/examples/cpuio.fio --output=3D/root/fiooutput/fiooutput.log
root@hmvm01:~# fio --client=3D192.168.160.144 =
~/git/fio/examples/cpuio.fio --output=3D/root/fiooutput/fiooutput.log
root@hmvm01:~# ls fiooutput
fiooutput.log
root@hmvm01:~# ls -al fiooutput
total 8
drwxr-xr-x 2 root root 4096 Feb  7 16:11 .
drwx------ 9 root root 4096 Feb  7 16:10 ..
-rw-r--r-- 1 root root    0 Feb  7 16:11 fiooutput.log
root@hmvm01:~# ls -al fiooutput.log
-rw-r--r-- 1 root root 754 Feb  7 16:10 fiooutput.log
root@hmvm01:~#


In client node:
root@aicos01:~# fio --server &
[1] 19562
root@aicos01:~# fio: server listening on 0.0.0.0,8765
fopen output: No such file or directory
fio: mutex.c:213: fio_mutex_down: Assertion `mutex->magic =3D=3D =
0x4d555445U' failed.

[1]+  Aborted                 (core dumped) fio --server
root@aicos01:~# ls -al fiooutput.log
-rw-r--r-- 1 root root 0 Feb  7 16:10 fiooutput.log
root@aicos01:~# cat fiooutput.log
root@aicos01:~#


5) I think that whether system is not need create output file when the =
fio machine is client node. (when this machine is running fio --server, =
i am some confuse for --server and --client command, haha)
Because the result should output in server node, and system already =
check the path vaild.


This tool is very helpful for my test job!
Thank you very much.


