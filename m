Return-Path: <fio-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:50365 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbcEXVkL (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 May 2016 17:40:11 -0400
Date: Tue, 24 May 2016 17:40:10 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <897324962.65623516.1464126010451.JavaMail.zimbra@redhat.com>
In-Reply-To: <632274204.65621860.1464125206824.JavaMail.zimbra@redhat.com>
Subject: assert failing with latency log
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Tim Wilkinson <twilkins@redhat.com>

If I run this fio jobfile with absolute latest upstream code:

[global]
directory=/var/tmp

[randreads]
direct=1
rate_iops=1000
size=512m
ioengine=sync 
bs=4k 
rw=randread
filename=ben.dd 
runtime=30
write_lat_log=foo

It fails with 

fio: stat.c:1988: get_cur_log: Assertion `iolog->pending->nr_samples < iolog->pending->max_samples' failed.

But if I take out the "write_lat_log=foo" line, it succeeds.  The assertion seems to be in the code path for latency logs, right?  Anyone else seen this?


