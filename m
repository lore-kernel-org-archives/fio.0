Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48668 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbcGVQaE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Jul 2016 12:30:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bQdKs-0003oK-4N
	for fio@vger.kernel.org; Fri, 22 Jul 2016 18:30:02 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Fri, 22 Jul 2016 18:30:02 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Fri, 22 Jul 2016 18:30:02 +0200
From: Saeed <ionictea@gmail.com>
Subject: "errror=Invalid or incomplete multibyte or wide character" & "verify: bad header numberio" errors
Date: Fri, 22 Jul 2016 11:29:49 -0500
Message-ID: <nmthlt$4m6$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Has anyone seen these errors before?

Here's the job file:

bs=4k
ioengine=libaio
iodepth=32
size=1g
direct=1
runtime=60
filename=/dev/sdb
group_reporting
numjobs=10

# validation
do_verify=1
verify_fatal=1
verify_dump=1

verify_pattern=0x01020304

[mixed-a]
rw=readwrite
stonewall

[mixed-b]
rw=randrw
stonewall

[mixed-c]
rw=readwrite:4k
stonewall

[mixed-d]
rw=randrw:4k
stonewall

Errors:

Multiple writers may overwrite blocks that belong to other jobs. This 
can cause verification failures.
mixed-verify-random-with-holes-4k: (g=3): rw=randrw, 
bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
...
fio-2.12
Starting 40 processes
fio: pid=5809, err=84/file:io_u.c:1968, func=io_u_queued_complete, 
error=Invalid or incomplete multibyte or wide character
fio: pid=5814, err=84/file:io_u.c:1968, func=io_u_queued_complete, 
error=Invalid or incomplete multibyte or wide character
fio: pid=5808, err=84/file:io_u.c:1968, func=io_u_queued_complete, 
error=Invalid or incomplete multibyte or wide character

verify: bad header numberio 2985, wanted 11 at file /dev/sdb offset 
1224704, length 4096
       hdr_fail data dumped as sdb.1224704.hdr_fail
verify: bad header numberio 2986, wanted 12 at file /dev/sdb offset 
1228800, length 4096
       hdr_fail data dumped as sdb.1228800.hdr_fail
verify: bad header numberio 23727, wanted 22903 at file /dev/sdb offset 
106496, length 4096
       hdr_fail data dumped as sdb.106496.hdr_fail
verify: bad header numberio 13399, wanted 1319 at file /dev/sdb offset 
311296, length 4096
       hdr_fail data dumped as sdb.311296.hdr_fail


