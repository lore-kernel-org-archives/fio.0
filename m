Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34973 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2IULvO (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Sep 2012 07:51:14 -0400
Received: by lbbgj3 with SMTP id gj3so3733352lbb.19
        for <fio@vger.kernel.org>; Fri, 21 Sep 2012 04:51:13 -0700 (PDT)
Message-ID: <505C54AE.9010701@vpseer.com>
Date: Fri, 21 Sep 2012 18:51:10 +0700
From: Konstantin Boyandin <konstantin@vpseer.com>
MIME-Version: 1.0
Subject: fio 2.0.9 fails: shmget: No space left on device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

When trying to run the command line

fio --bs=4k --size=128m --direct=1 --runtime=10 --rw=randread
--numjobs=32 --group_reporting --time_based --name=128m

I see only this:

shmget: No space left on device
error: failed to setup shm segment

Environment:
# cat /etc/redhat-release
CentOS release 6.3 (Final)

# uname -a
Linux vpseer 2.6.32-042stab059.7 #1 SMP Tue Jul 24 19:12:01 MSK 2012
x86_64 x86_64 x86_64 GNU/Linux

# virt-what
openvz

# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/simfs            52428800   1590532  50838268   4% /
none                    526336         4    526332   1% /dev
none                    526336         0    526336   0% /dev/shm

If additional info required, please tell me.
Thanks.

Sincerely,
Konstantin
