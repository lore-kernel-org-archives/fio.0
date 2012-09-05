Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47131 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2IEUew (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Sep 2012 16:34:52 -0400
Received: by bkwj10 with SMTP id j10so471977bkw.19
        for <fio@vger.kernel.org>; Wed, 05 Sep 2012 13:34:51 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 16:34:51 -0400
Message-ID: <CACgm0dhiEQm6K-Am82A5=da04N9SGZ+Q5EZYxZsbkzDw4TukMA@mail.gmail.com>
Subject: Simulating a SAS workload
From: Spencer Hayes <spencer@jshayesinc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello, fio folks. I'm working on simulating workloads for SAS and am
having a bit of trouble getting the read and write mix to model how
SAS works.

In my example, SAS will read in two data sets from separate OS files,
then write a merged data set out to a new OS file. The issue is that
SAS will read each data set one line at a time, then write the
appropriate lines out to the new file before reading in the next lines
from the source data sets.

I've tried a few different fio job configs and can't seem to get it to
work how I expect. This seems to make sense:

[global]
disable_clat=1
disable_slat=1
clat_percentiles=0
direct=1
directory=/sasdata1

## Simulates interleaving of two data sets
##
[source_data_sets]
rw=read
filesize=100m
nrfiles=2

[destination_data_set]
rw=write
size=200m


But the actual behavior is that the second job doing the writing seems
to block the first job from reading and the reads only really proceed
after the write job is finished. I've also tried a config with a
single job using mixed sequential read/write, and while that may end
up being good enough, it seems like it doesn't necessarily match what
I'm trying to simulate.

Basically I want the first job to do 2 reads, then the second job to
do a write and continue in that roundrobin kind of way which is how
SAS would process the files.

I've read through the HOWTO a few times and think I'm probably just
not understanding what a couple options here or there could do for me.

Thanks for your help!

Regards,

Spencer
