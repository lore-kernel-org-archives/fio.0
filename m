Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40671 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbcBITM2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Feb 2016 14:12:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1aTDi6-0008Sx-OA
	for fio@vger.kernel.org; Tue, 09 Feb 2016 20:12:27 +0100
Received: from pc1mwgproxy02-dmz.us.dell.com ([143.166.255.112])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 09 Feb 2016 20:12:26 +0100
Received: from Kurt_Dorsey by pc1mwgproxy02-dmz.us.dell.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 09 Feb 2016 20:12:26 +0100
From: Kurt Dorsey <Kurt_Dorsey@Dell.com>
Subject: =?utf-8?b?b3V0cHV0X2Zvcm1hdD10ZXJzZSxqc29u?= core dumping
Date: Tue, 9 Feb 2016 19:12:14 +0000 (UTC)
Message-ID: <loom.20160209T200431-709@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am trying to get multiple output formats working with fio and I am 
getting a core dump 
fio: diskutil.c:710: show_disk_util: Assertion `parent' failed.
Aborted (core dumped)

I am utilizing format from 
commit a666cab8ed3d2a2fa782be345425a2e88734a007
Author: Jens Axboe <axboe@fb.com>
Date:   Tue Oct 27 13:45:21 2015 +0900

    Enable the use of multiple output formats
    
    You can now do
    
    ./fio --output-format=normal,json jobfile.fio
    
    and get both types of output.
    
    Signed-off-by: Jens Axboe <axboe@fb.com>


fio -v
fio-2.6-10-g820b



fio --ioengine=libaio --buffered=0 --direct=1 --norandommap --name=test  
--filename=/dev/sdb --iodepth=32  --ba=4k --rw=randrw --rwmixwrite=65 --
bs=8K --numjobs=1 --runtime=10 --ramp_time=0 --time_based --output-
format=terse,json

I have also tried 
--format=normal,json and I get the same issue


--output-format=normal,terse  
Works just fine but I really would like to have json output along with 
terse.


Is there a workaround to get both terse and json (or json+)?
Thank you,
Kurt


