Return-Path: <fio-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:52846 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751900Ab2GIViz (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 9 Jul 2012 17:38:55 -0400
Received: from zion.americas.sgi.com (zion.americas.sgi.com [128.162.236.17])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B05DEAC009
	for <fio@vger.kernel.org>; Mon,  9 Jul 2012 14:38:54 -0700 (PDT)
Received: (from emery@localhost) by zion.americas.sgi.com (8.12.9/ASC-news-1.4) id q69LcsAr22293463 for fio@vger.kernel.org; Mon, 9 Jul 2012 16:38:54 -0500 (CDT)
Date: Mon, 9 Jul 2012 16:38:54 -0500 (CDT)
From: Scott Emery <emery@sgi.com>
Message-Id: <201207092138.q69LcsAr22293463@zion.americas.sgi.com>
Subject: How to get latency logs after 1.39?
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


	I eventually want to specify a job on the command line that includes
collecting latency/bandwidth/iops logs.

	I have a command/job script combination that makes latency
logs in 1.38 and doesn't in 1.39.   I fail to get latency logs for a fair
sample of fio versions from 1.39 to 2.07. I discovered this in attempting
to figure out where the behavior changed.

cat ./run
#
/loaner/semery/fio/fio-1.39/fio --output test.small.loaner --latency-log --bandwidth-log  --alloc-size=4096 test.small

cat test.small
#
[global]
bs=2m
ioengine=libaio
iodepth=1
size=1g
direct=1
runtime=1200
directory=/loaner/semery/fio/latencylogs
group_reporting

[seq-read]
rw=read
numjobs=2

[seq-write]
new_group
rw=write
numjobs=1


When run uses fio-1.38 I get the following:
[semery@lou2-mov4 latencylogs]$ ./run
[semery@lou2-mov4 latencylogs]$ ls
run		   seq-write.3.0	  test.putgetstorm.iod4.loaner
seq-read.1.0	   seq-write_clat.log	  test.small
seq-read.2.0	   seq-write_slat.log	  test.small.loaner

With fio-1.39 I get:
[semery@lou2-mov4 latencylogs]$ ls
run	      seq-write.3.0	     test.putgetstorm.iod4.loaner
seq-read.1.0  test.putgetstorm	     test.small
seq-read.2.0  test.putgetstorm.iod4  test.small.loaner

I grovelled through a diff -r of 1.38 and 1.39 and the significant looking
difference is this:

diff -r fio-1.38/init.c fio-1.39/init.c
884,886d883
<       def_thread.o.write_bw_log = write_bw_log;
<       def_thread.o.write_lat_log = write_lat_log;
<


	Have latency logs, et. al. been deprecated?  Is there a  new/better
way to get them?


Scott Emery
emery@sgi.com
