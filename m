Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36931 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbbLALFA (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Dec 2015 06:05:00 -0500
Received: by wmww144 with SMTP id w144so8029061wmw.0
        for <fio@vger.kernel.org>; Tue, 01 Dec 2015 03:04:59 -0800 (PST)
From: Avi Kivity <avi@scylladb.com>
Subject: RFE: Graphing and iteration support for fio
Message-ID: <565D7ED9.3000606@scylladb.com>
Date: Tue, 1 Dec 2015 13:04:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Sometimes you want to run a set of experiments on a disk, varying a 
parameter between tests (in my case, iodepth, but buffer size is also a 
good candidate).  You then want to present the results in a nice graph.

I wrote a small wrapper around fio to do this 
(https://github.com/avikivity/diskplorer), but it occurs to me that 
generalized support for both in fio would be much more useful.

Possibly, you'd define a job as a template:

[aio-read]
template_start=1
template_end=100
template_step=1
(or template_ratio=1.05 for exponential growth)
iodepth=template_variable

(it's just possible that someone can come up with better syntax).

A few more options in the global section can then cause a graph to be 
generated.

btw, a fast disk can easily saturate a single core using libaio, so a 
multithreaded libaio ioengine would be welcome (I am currently emulating 
it using multiple jobs and new_group).


