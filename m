Return-Path: <fio-owner@vger.kernel.org>
Received: from server506g.appriver.com ([50.56.144.37]:51193 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752915AbaDDUGg convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 4 Apr 2014 16:06:36 -0400
Received: from [10.242.229.139] (HELO smtp.exg6.exghost.com)
  by server506.appriver.com (CommuniGate Pro SMTP 6.0.2)
  with ESMTPS id 164007498 for fio@vger.kernel.org; Fri, 04 Apr 2014 15:06:33 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: Mixing command line and job file parameters
Date: Fri, 4 Apr 2014 20:06:32 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB10866E58@DAGN05B-E6.exg6.exghost.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

This has been bugging me for a while... it appears that we have a choice of using either cmd line parameters xor a job file (but not combining the two) to fully specify a job. 
For instance:
fio --runtime=20 derf.cfg
fio: time_based requires a runtime/timeout setting
file__0: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
fio-2.1.6.1
[...]
where derf.cfg starts otherwise fully specified the job, just doesn't have the runtime.

There are ways around this for some cases by using environment variables (e.g. "RT=20 fio def.cfg" and runtime=${RT}) but those can get clunky and only allows value substitutions, not additional directives. In my current case, I'd like to have the config file supply default values for certain parameters and override them as needed from the command line (e.g. runtime=20 unless I say otherwise). Right now, I already have 6 or 7 env vars passed in to the job file and that's too many. 

Is there any way to do this without really hacking up the parsing code? I'm currently looking at init.c, where it looks like the cmd line is parsed first then the job file(s), but I lose the mental thread when I get into parse_jobs_ini(). Ideally, any fio options on the command line before a --name= would be stuck at the end of the global thread data (*td_parent?), similar to including a directive multiple times.

Thanks,

z!

