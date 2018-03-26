Return-Path: <fio-owner@vger.kernel.org>
Received: from act-MTAout3.csiro.au ([150.229.7.39]:7975 "EHLO
        act-MTAout3.csiro.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbeC0AJA (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Mar 2018 20:09:00 -0400
Received: from mayhem.atnf.CSIRO.AU (mayhem.atnf.csiro.au [130.155.194.144])
        by crux.atnf.csiro.au (Postfix) with ESMTP id 43D79199F7
        for <fio@vger.kernel.org>; Tue, 27 Mar 2018 10:58:24 +1100 (AEDT)
Received: from mci156 by mayhem.atnf.CSIRO.AU with local (Exim 4.84_2)
        (envelope-from <mci156@mayhem.atnf.csiro.au>)
        id 1f0c0O-00007f-64
        for fio@vger.kernel.org; Tue, 27 Mar 2018 10:58:24 +1100
Date: Tue, 27 Mar 2018 10:58:24 +1100
From: Vincent McIntyre <vincent.mcintyre@csiro.au>
Subject: help constructing job file
Message-ID: <20180326235824.GC30981@mayhem.atnf.CSIRO.AU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi

(newbie alert)

I am struggling with how to model a particular workload:
 - there are two groups of processes (8 writers and 8 readers),
   that run concurrently, writing to a single RAID unit

 - each of the writers
   - opens 36 files
   - appends to the files in 1M chunks until they reach 100G
   - closes those files and opens a new set

 - each of the readers
   - reads a group of 36 contemporaneous files from beginning to end
   - moves on to the next group

My goal is not to maximise numbers from fio tests but rather
to model the system and how it is likely to scale up or down.
In particular I want to observe the system behaviour over an
extended period (up to 24h) with readers & writers hammering away.

Below is my initial sketch which isn't right; in my tests (with
smaller filesize, numjobs, nrfiles) it runs the file layout fine
but I never seem to get a prolonged period of read operations
in parallel with writes.

[global]
direct=0
fsync=0
bs=4k
size=1M
ioengine=posixaio
rwmixread=50
rwmixwrite=50
group_reporting=1
per_job_logs=0
filesize=100G
file_append=1
invalidate=1
refill_buffers=1

[writer]
name=writer
readwrite=write
numjobs=8
nrfiles=36
file_service_type=roundrobin

[reader]
name=reader
readwrite=read
numjobs=8
nrfiles=36
file_service_type=roundrobin

Any pointers would be most welcome.
Vince
