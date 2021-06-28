Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr40135.outbound.protection.outlook.com ([40.107.4.135]:56256
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232558AbhF1KKA (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 28 Jun 2021 06:10:00 -0400
From: Erwan Velu <e.velu@criteo.com>
Subject: Adding a tool generates graphviz graphs of any fio job file.
Message-ID: <d1c50776-3c20-eae3-6f91-d82aed793d67@criteo.com>
Date: Mon, 28 Jun 2021 12:07:31 +0200
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi folks,

I've been pushing a PR to introduce a tool that is able to render a fio 
script file as a graphviz graph.

That's  first release, it works pretty well, feedback welcome.

If you want to see a sample output : 
https://raw.githubusercontent.com/axboe/fio/d61215e076fe3b51c0ed92dd985101b84bbcd757/examples/e4defrag2.png

https://github.com/axboe/fio/pull/1240

|----- Reading a fio file can be sometimes tricky when : - you have lots 
of jobs - jobs override some options - jobs have dependencies 
Understanding which jobs are running at the same time, which one waits 
for which is sometimes difficult and could easily lead to mistakes. It's 
pretty common to find jobs where people think jobs are sequential while 
some run in parallel. For ease the understanding of the scheduling and 
what's the configuration status (local + global variables), this tool 
will use some graphical helpers to enlighten things. The configuration 
file can be used to adjust the rendering but by default : - jobs are 
defined in a blue rounded box - jobs running at the same time are inside 
the same gray background - time & size variables are shown as a self 
arrow - dependencies between jobs are shown by up->down black arrows - 
specific engines options are written in blue (top of the job box) - 
standard options are printed in green (bottom of the job box) - pre/post 
actions are printed in red (head/tail of the job box) - numjobs is 
replaced by a 'x' multiplicator on the job name Several output formats 
can be defined via --format : list can be found here 
https://graphviz.org/docs/outputs/ if --view option is used, the 
rendered file will be immediately shown. if --keep is used, the grapvhiz 
file will be kept. This commit also adds the rendering of the examples 
jobs. If a newcomer gets into the repository, they can immediately 
better understand what the jobs do.|


Erwan,


