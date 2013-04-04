Return-Path: <fio-owner@vger.kernel.org>
Received: from wbwburpvsmtpa.warnerbros.com ([168.161.192.150]:23649 "EHLO
	WBWBURPVSMTPA.amer.warnerbros.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762945Ab3DDQiH (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 4 Apr 2013 12:38:07 -0400
Received: from [10.130.18.140] (wally.mpi.warnerbros.com [10.130.18.140])
	by nismstr.mpi.warnerbros.com (8.13.8/8.13.1) with ESMTP id r34GSZ5U022003
	for <fio@vger.kernel.org>; Thu, 4 Apr 2013 09:28:35 -0700
Message-ID: <515DAA33.4000009@warnerbros.com>
Date: Thu, 04 Apr 2013 09:28:35 -0700
From: Alan Hagge <Alan.Hagge@warnerbros.com>
MIME-Version: 1.0
Subject: How to re-use default sequential filenames?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm trying to put together a test of the write and read speed to some 
new SAN storage.  Our workflow involves writing large numbers of 12 MiB 
files (on the order of 20,000 or so) at a time.  I'd like to set up a 
config file section that will write all 20,000 files then read all 
20,000 files and report on the write performance and the read 
performance (separately).

I've tried something like this:

[global]
blocksize=4m
filesize=12m
nrfiles=20000
openfiles=1
file_service_type=sequential
create_on_open=1
ioengine=posixaio

[write]
rw=write

[read]
stonewall
rw=read

But the issue is that the files get created with default filenames 
(write.1.1, write.1.2, etc.), so that when the read job is run, it can't 
find any files (since it expects the files to be named read.1.1, 
read.1.2, etc.).  If I try to specify the "filename=" option in either 
section, fio no longer appends the ".<thread>.<sequence>" to the 
filename, but rather tries to do all I/O to a single file.

Is there a syntax for the "filename=" option that will allow me to 
specify a different root filename, but still use the 
".<thread>.<sequence>" naming convention?  Failing that, is there any 
other way to accomplish my goal?

Thanks for any tips, pointers, etc.

