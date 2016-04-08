Return-Path: <fio-owner@vger.kernel.org>
Received: from mailuogwhop.emc.com ([168.159.213.141]:59729 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbcDHUB6 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 8 Apr 2016 16:01:58 -0400
Received: from maildlpprd03.lss.emc.com (maildlpprd03.lss.emc.com [10.253.24.35])
	by mailuogwprd04.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id u38K1uxB000946
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <fio@vger.kernel.org>; Fri, 8 Apr 2016 16:01:57 -0400
Received: from mailusrhubprd52.lss.emc.com (mailusrhubprd52.lss.emc.com [10.106.48.25]) by maildlpprd03.lss.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Fri, 8 Apr 2016 16:00:12 -0400
Received: from MXHUB215.corp.emc.com (MXHUB215.corp.emc.com [10.253.68.85])
	by mailusrhubprd52.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id u38K1g8N015738
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL)
	for <fio@vger.kernel.org>; Fri, 8 Apr 2016 16:01:43 -0400
From: "Foley, Robert" <robert.foley@emc.com>
Subject: random writes with different patterns
Date: Fri, 8 Apr 2016 20:01:40 +0000
Message-ID: <759ED0CCB4AB7D4A897D03A711E4EC4C6F771F72@MX204CL02.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello all,
We use fio and it more than meets our needs in the majority of cases.  There is one use case where we would like to write to randomly selected blocks with one data pattern, and then overwrite that same set of blocks with a different data pattern.  We did not find the fio parameters that would allow this.

Our use case is one where we initially write randomly to a portion of a test area. Here is an example of our job file parameters:
verify=crc32c 
rw=randwrite
bs=4k
size=128G
io_size=32M 
randseed=42

Our understanding is that this job allows us to write 32 meg of data to random areas in the 128 gig region.  Since we are using randseed, this allows us to later use a read job to verify the data on these random blocks.

Suppose at time A we wrote out a pattern using the parameters above.  Later at time B we would like to write the same blocks (offsets) of the test area but with a different pattern of data bytes.  Our understanding is that randseed will seed the generation of both a) the pattern of I/O blocks that we generate as well as b) the pattern of data in the buffers we are writing.  In other words since the randseed controls both a) and b), there is no way for us to get a different data pattern written to the same pattern of blocks (offsets).

Does anyone know how to accomplish this with fio?

We had some ideas around how to solve this if it is not currently supported.   It might be useful to have an optional "verify_io_stamp" parameter, which would specify a simple 32 or 64 bit integer that could get added to and verified with the verify_header.  

At time A in the example above, the job would specify one value for the verify_io_stamp (A)  and at time B the job would specify a different value (B).  Since reads would verify the verify_io_stamp in the header, we could distinguish between the (A) and the (B) data and solve the use case we mentioned above.

Another benefit of this verify_io_stamp is that if we ever received incorrect data, it might help us find out from which point that data was.  So for example if we wrote with a different verify_io_stamp at times A, B, and C, and we received data pattern "A" at time "C" then it would give us potentially valuable information about the failure, which might help us to debug it faster.  

Does this seem useful to you?  We are willing to contribute this if it seems beneficial to the community. 

Thank You !
-Rob Foley


