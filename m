Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:36402 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3H3LxP (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Aug 2013 07:53:15 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id A126AA31F9
	for <fio@vger.kernel.org>; Fri, 30 Aug 2013 13:53:14 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (hercules.tks.local [192.168.110.28])
	by iris.tks.local (Postfix) with ESMTP id 4D8893FAC5
	for <fio@vger.kernel.org>; Fri, 30 Aug 2013 13:53:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 49C2A1A84008
	for <fio@vger.kernel.org>; Fri, 30 Aug 2013 13:53:14 +0200 (CEST)
Received: from zimbra.thomas-krenn.com ([127.0.0.1])
	by localhost (zimbra.thomas-krenn.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EqhXGq6Wfq9X for <fio@vger.kernel.org>;
	Fri, 30 Aug 2013 13:53:09 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (zimbra.thomas-krenn.com [127.0.1.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id A00861A84007
	for <fio@vger.kernel.org>; Fri, 30 Aug 2013 13:53:09 +0200 (CEST)
Date: Fri, 30 Aug 2013 13:53:09 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <795872394.588090.1377863589568.JavaMail.root@thomas-krenn.com>
In-Reply-To: <609024196.540203.1377760973880.JavaMail.root@thomas-krenn.com>
Subject: Running Fio under AIX 7
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi fio users,

I am trying to run Fio under AIX 7 - according to the documentation there shouldn't be any problem with it.
For now I am getting the following error, do you have any idea what's the problem here (filesystem jfs/jfs2)?

Thanks for you help, Georg
 
/tmp/fio-2.1.2/fio-2.1.2# fio --rw=write --name=test --size=10M
test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.1.2
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 10MB)
fio: posix_fallocate fails: Invalid argument
fio: pid=0, err=22/file:filesetup.c:412, func=invalidate_cache, error=Invalid argument
 
Run status group 0 (all jobs):
 
With ''--debug'' on:
...
time     17105066 inv_cycles_per_usec=32768
mutex    17105066 wait on startup_mutex
mutex    17105066 done waiting on startup_mutex
Starting 1 process
file     17105066 setup files
process  17105066 pid=0: runstate 0 -> 4
file     17105066 get file size for b0002028/0/b0002148
test: Laying out IO file(s) (1 file(s) / 10MB)
file     17105066 layout unlink test.1.0
file     17105066 open file test.1.0, flags 101
file     17105066 posix_fallocate file test.1.0 size 10485760
fio: posix_fallocate fails: Invalid argument
io       17105066 invalidate cache test.1.0: 0/10485760
process  17105066 pid=0: runstate 4 -> 0
fio: pid=0, err=22/file:filesetup.c:412, func=invalidate_cache, error=Invalid argument
process  17105066 pid=0: runstate 0 -> 10
  



