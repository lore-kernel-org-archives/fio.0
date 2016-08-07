Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39529 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbcHGDFp (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Aug 2016 23:05:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bWEAW-0001xN-Sj
	for fio@vger.kernel.org; Sun, 07 Aug 2016 04:50:28 +0200
From: Saeed <ionictea@gmail.com>
Subject: fio2gnuplot iop graphs not showing any output
Date: Sat, 6 Aug 2016 21:50:10 -0500
Message-ID: <no67l1$l4$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Is there any trick to getting fio2gnuplot to plot graphs with data for 
the iop logs?  Its not plotting any data for me currently even thgh the 
job averages about 100k iops in the results output and when it plots 
graphs gnuplot takes a very long time complete the job.

[global]
bs=4k
ioengine=libaio
iodepth=1
size=5g
direct=1
filename=/dev/sde
group_reporting
numjobs=1
per_job_logs=0
write_bw_log=bw
write_iops_log=iops
write_lat_log=lat
[read]
rw=read
time_based=1
runtime=180


