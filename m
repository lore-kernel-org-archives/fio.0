Return-Path: <fio-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59453 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1BDTVw (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 4 Feb 2011 14:21:52 -0500
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p14J0715016326
	for <fio@vger.kernel.org>; Fri, 4 Feb 2011 14:02:08 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7F9E47280B5
	for <fio@vger.kernel.org>; Fri,  4 Feb 2011 14:21:34 -0500 (EST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p14JLYWZ430170
	for <fio@vger.kernel.org>; Fri, 4 Feb 2011 14:21:34 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p14JLXc9009088
	for <fio@vger.kernel.org>; Fri, 4 Feb 2011 12:21:33 -0700
Received: from [9.65.64.24] (sig-9-65-64-24.mts.ibm.com [9.65.64.24])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p14JLVMs008490
	for <fio@vger.kernel.org>; Fri, 4 Feb 2011 12:21:32 -0700
Message-ID: <4D4C51B2.1090700@austin.ibm.com>
Date: Fri, 04 Feb 2011 13:21:22 -0600
From: Steven Pratt <slpratt@austin.ibm.com>
MIME-Version: 1.0
Subject: test definition help needed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am trying to create a job file that randomly select a file form an imported list and reads the entire file sequentially. Them moves to the next file. I also want multiple jobs(processe) running the same workload. I have this:

[global]
bs=4k
time_based=1
runtime=15m
iodepth=4
rw=read
ioengine=libaio
time_based=1
ramp_time=600s
norandommap

[job1]
opendir=/${FIO_MOUNT}/session1/small_file1
file_service_type=sequential
numjobs=8



I used file_service_type=sequential because tought without it it would only do a single read (block) from the file before switching to a different file, which is not what I want. The issue with this test as written is it seems like all the fio processes choose files in the same order so I get way more cache hits than I want. I want this to be more of a random file selection, but with reading whole file.  Any advice?

Steve
