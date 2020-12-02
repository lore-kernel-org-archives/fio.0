Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgLBOci (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Dec 2020 09:32:38 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1824C0613CF
        for <fio@vger.kernel.org>; Wed,  2 Dec 2020 06:31:57 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v14so7795616wml.1
        for <fio@vger.kernel.org>; Wed, 02 Dec 2020 06:31:57 -0800 (PST)
MIME-Version: 1.0
From: David Pineau <david.pineau@blade-group.com>
Date: Wed, 2 Dec 2020 15:31:45 +0100
Message-ID: <CAMzroCjoMa0LD5tZhVvrkNPG=c_vGW0A1RVKQYN8jgY8LX7=HQ@mail.gmail.com>
Subject: Difficulties pushing FIO towards many small files and WORM-style use-case
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

First of all, allow me to thank the FIO developers for providing this
very complete tool to benchmark storage setups.

In the context of my work, I'm trying to compare two storage setups
using FIO, to prepare for a hardware evolution of one of our services.

As the use-case is pretty much well understood, I was trying to
reproduce it in the FIO configuration file that you'll find later in
this email. To give you a bit more context, our usage of the hardware
is to have a Content Delivery Cache Software (homewritten) which
handles multiple layers of cache to distribute pieces of data whose
sizes range up from 16k to 10MB.
As we have data on the actual usage of this current software, we know
the spread of accesses to various size ranges, and we rely on a huge
number of files accessed by the multi-threaded service. As the pieces
of data can live a long time on this service and are immutable, I'm
trying to go for a WORM-style workload with FIO.

With this information in mind, I build the following FIO configuration file:

>>>>
[global]
# File-related config
directory=/mnt/test-mountpoint
nrfiles=3000
file_service_type=random
create_on_open=1
allow_file_create=1
filesize=16k-10m

# Io type config
rw=randrw
unified_rw_reporting=0
randrepeat=0
fallocate=none
end_fsync=0
overwrite=0
fsync_on_close=1
rwmixread=90
# In an attempt to reproduce a similar usage skew as our service...
# Spread IOs unevenly, skewed toward a part of the dataset:
# - 60% of IOs on 20% of data,
# - 20% of IOs on 30% of data,
# - 20% of IOs on 50% of data
random_distribution=zoned:60/20:20/30:20/50
# 100% Random reads, 0% Random writes (thus sequential)
percentage_random=100,0
# Likewise, configure different blocksizes for seq (write) & random (read) ops
bs_is_seq_rand=1
blocksize_range=128k-10m,
# Here's the blocksizes repartitions retrieved from our metrics during 3 hours
# Normally, it should be random within ranges, but this mode
# only uses fixed-size blocks, so we'll consider it good enough.
bssplit=,8k/10:16k/7:32k/9:64k/22:128k/21:256k/12:512k/14:1m/3:10m/2

# Threads/processes/job sync settings
thread=1

# IO/data Verify options
verify=null # Don't consume CPU please !

# Measurements and reporting settings
#per_job_logs=1
disk_util=1

# Io Engine config
ioengine=libaio


[cache-layer2]
# Jobs settings
time_based=1
runtime=60
numjobs=175
size=200M
<<<<<

With this configuration, I'm obligated to use the CLI option
"--alloc-size=256M" otherwise the preparatory memory allocation fails
and aborts.

That being said, despite this setting, I get the following issues that
I do not understand well enough to fix without your kind help:
 - OOM messages once the run starts
 - Setting "norandommap" does not seem to help, although I thought
that the memory issue was due to the "randommap" for my many files &
workers.
 - Impossible to increase the number of jobs/threads or files, because
once I do that. I get back to the memory pre-allocation issue, and no
amount of memory seems to fix it. (1g, 10g, etc..)
 - With these blockers, it seems impossible to push my current FIO
workload as far as saturating my hardware (which is my aim)
 - I observe that if I increase the settings of "size", "numjobs" or
"--alloc-size", the READ throughput measured by FIO goes down, while
the WRITE througput increases. I understand that increasing size for
seq write workload sincreases their throughput, but I'm at a loss in
front of the READ throughput behavior.

Do you have any advice on the configuration parameters I'm using to
push my hardware further towards its limits ?
Is there any mechanism within FIO that I'm misunderstanding, which is
causing me difficulty to do that ?

In advance, thank you for your kind advice and help,

--
David Pineau

