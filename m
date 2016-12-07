Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:34072 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752142AbcLGRQu (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Dec 2016 12:16:50 -0500
Received: by mail-ua0-f176.google.com with SMTP id 51so421855055uai.1
        for <fio@vger.kernel.org>; Wed, 07 Dec 2016 09:16:50 -0800 (PST)
MIME-Version: 1.0
From: "Olausson, Bjoern" <contactme@olausson.de>
Date: Wed, 7 Dec 2016 18:16:48 +0100
Message-ID: <CAE7O3TdQh8MmuJeb6Q+QD+LOD2ZKaEBfFSBbL1dV0YDuKs-GXA@mail.gmail.com>
Subject: "fio --server" on Windows -> "fio: waitpid: Function not implemented"
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello FIO users,

I have to run some benchmarks on multiple Windows Server 2012 Build
9200 clients.

When I start fio as server on the windows machines everything looks
fine until I commence the benchmark, I get the following output:


PS C:\Program Files\fio> .\fio.exe --server
fio: server listening on 0.0.0.0,8765
fork is not implemented
waitpid is not implemented
fio: waitpid: Function not implemented
waitpid is not implemented
fio: waitpid: Function not implemented

This output continues until I us the processmanager to kill FIO

PS C:\Program Files\fio> .\fio.exe --version
fio-2.15

The benchmark was initiated form a Windows 2012 Build 9200 too:
PS C:\Program Files\fio> .\fio.exe --client=Z:\fio\hostlist-test
Z:\fio\results\test.inp --section=test
fio: client 192.168.2.81, timeout on cmd PROBE
fio: client 192.168.2.81 timed out
PS C:\Program Files\fio>.\fio.exe --version
fio-2.15


Also tested to start the benchmark from Linux system - which would be
the preferred way
[root@server40 ~]# /root/fio-git/fio
--client=/sharedfs/fio/hostlist-test /sharedfs/fio/results/test.inp
--section=test
client: host=192.168.2.81 disconnected
[root@server40 ~]# /root/fio-git/fio --version
fio-2.15


The input file used is:
[global]
ioengine=windowsaio
group_reporting=1
unified_rw_reporting=0
ramp_time=15
norandommap=1
filename_format=fiotest.$filenum
time_based=1
runtime=30s
size=32g
directory=Z\:\fio

[test]
rw=read
fsync=0
direct=0
nrfiles=1
numjobs=1
blocksize=8m

hostlist contains only one client for testing this FIO issue:
[root@server40 ~]# cat /sharedfs/fio/hostlist-test
192.168.2.81

It looks like this behavior is present since 2013
(http://www.spinics.net/lists/fio/msg02564.html "--server broken on
Windows (2.1.1 and 2.0.14)")

I compiled the tatest version from GIT on Windows but it did yield the
same results.

Is there an easy way to fix this or is this feature considered broken
and is not going to be fixed?

Greetings,
Bjoern
