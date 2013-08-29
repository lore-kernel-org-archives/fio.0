Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61187 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3H2RwK (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Aug 2013 13:52:10 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so864225lbi.1
        for <fio@vger.kernel.org>; Thu, 29 Aug 2013 10:52:08 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Aug 2013 13:52:08 -0400
Message-ID: <CABFR9T1-Ekd81qB8q4P6O=H28NcWPiv-akgrdyuFK5qQGsjC4w@mail.gmail.com>
Subject: fio log file feature request with a side or of help
From: Roger Sibert <roger_sibert@xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO <fio@vger.kernel.org>

Hello Everyone,


I am working on determining wear leveling behavior on SSD.   The
request to me is to run load for a set period of time, we can use 24
hrs as an example, and at the end of the run compare the
performance/latency for each hour.  So in theory any graph would have
up to 24 sets of entries on it.

My initial though was to run fio and then in a different window run a
script that just copied the logs off every 60 minutes.  Im using the
below for the configuration file (this was a 2 hour proof of theory
run not the full length run) and Im just not seeing any log files to
copy.

[global]
bs=512k
direct=1
ioengine=libaio
iodepth=16
filename=/dev/sdc   ; or use a full disk, for example /dev/sda
runtime=120m
time_based

[seqwrite-phase]
stonewall
rw=write
fill_device=1
write_bw_log=sdc-iodepth16-seqwrite-bs512k-1
write_lat_log=sdc-iodepth16-seqwrite-bs512k-1
write_iops_log=sdc-iodepth16-seqwrite-bs512k-1

For the current version of fio is there a way to gather the logs every
X# of minutes?  IE a command that tells fio to keep the logs flushed
out or to dump the logs every X# of minutes?

For the feature request would it make sense to have the ability to
either increment the log file every X minutes or to put a time stamp
of some sort in the log file so you can split it on that stamp?

Thanks,
Roger
