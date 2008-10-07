Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:46372 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbYJGJYS (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 7 Oct 2008 05:24:18 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Date: Tue, 07 Oct 2008 20:24:02 +1100
Message-ID: <48EB2AB2.1000807@gelato.unsw.edu.au>
MIME-Version: 1.0
Subject: [PATCH] Document environment variable expansion
References: <48E70DAD.5000604@gelato.unsw.edu.au> <20081004081241.GZ19428@kernel.dk>
In-Reply-To: <20081004081241.GZ19428@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org

Add environment variable expansion documentation to HOWTO, and fix
a few nearby typo's while we're at it.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 HOWTO |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 178bc98..129926b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -111,7 +111,7 @@ several global sections if so desired. A job is only affected by a global
 section residing above it. If the first character in a line is a ';' or a
 '#', the entire line is discarded as a comment.
 
-So lets look at a really simple job file that define to threads, each
+So let's look at a really simple job file that defines two processes, each
 randomly reading from a 128MiB file.
 
 ; -- start job file --
@@ -133,7 +133,7 @@ line, this job would look as follows:
 $ fio --name=global --rw=randread --size=128m --name=job1 --name=job2
 
 
-Lets look at an example that have a number of processes writing randomly
+Let's look at an example that has a number of processes writing randomly
 to files.
 
 ; -- start job file --
@@ -158,6 +158,33 @@ specify:
 
 $ fio --name=random-writers --ioengine=libaio --iodepth=4 --rw=randwrite --bs=32k --direct=0 --size=64m --numjobs=4
 
+fio also supports environment variable expansion in job files. Any
+substring of the form "${VARNAME}" as part of an option value (in other
+words, on the right of the `='), will be expanded to the value of the
+environment variable called VARNAME.  If no such environment variable
+is defined, or VARNAME is the empty string, the empty string will be
+substituted.
+
+As an example, let's look at a sample fio invocation and job file:
+
+$ SIZE=64m NUMJOBS=4 fio jobfile.fio
+
+; -- start job file --
+[random-writers]
+rw=randwrite
+size=${SIZE}
+numjobs=${NUMJOBS}
+; -- end job file --
+
+This will expand to the following equivalent job file at runtime:
+
+; -- start job file --
+[random-writers]
+rw=randwrite
+size=64m
+numjobs=4
+; -- end job file --
+
 fio ships with a few example job files, you can also look there for
 inspiration.
 
-- 
1.6.0.2
