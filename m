Return-Path: <fio-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:60100 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbcEZTLM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 May 2016 15:11:12 -0400
Date: Thu, 26 May 2016 15:11:11 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <1119349874.66202652.1464289871526.JavaMail.zimbra@redhat.com>
In-Reply-To: <671811755.66182002.1464284748641.JavaMail.zimbra@redhat.com>
Subject: problem with fio --client and latency logs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Tim Wilkinson <twilkins@redhat.com>, Andrew Theurer <atheurer@redhat.com>, John Harrigan <jharriga@redhat.com>

recently I noticed a problem in master branch when fio --client is used.  latency logs generated with it have large numbers of "0, 0, 0, 0" records at the end of the file.  I have a simple reproducer fio jobfile:

--------- reproducer.fiojob ----
[global]
numjobs=1
directory=/var/tmp

[shared-files]
rw=randread
write_lat_log=1thr
ioengine=sync
bs=4k      # I/O size
filesize=1g  # file size
runtime=20
-------------

If you run this job file like this:

# fio --server --daemonize=/var/run/fiosvr.pid
# fio --client=localhost reproducer.fiojob

You get the latency log 1thr_clat.1.log with the 0 records at the end.  If you run the same job file with:

# fio reproducer.fiojob

You don't get the 0 records.  This explains why Ceph CBT does not have the problem, for example.

I bisected fio history using git until I found the first commit that failed:

-------
commit 0cba0f919ee6af7dd65df436884336cff9c903f9
Author: Jens Axboe <axboe@fb.com>
Date:   Thu Dec 17 14:54:15 2015 -0700

    client/server: transparent handling of storing compressed logs

    Signed-off-by: Jens Axboe <axboe@fb.com>
------

I could use some help figuring out what went wrong at this point, the diffs were complicated but it seemed possible that this commit was related to my problem.

-ben england
