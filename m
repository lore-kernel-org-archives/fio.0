Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:34386 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFZOaI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Jun 2017 10:30:08 -0400
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 4072E60ADB
        for <fio@vger.kernel.org>; Mon, 26 Jun 2017 14:30:07 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 1/4] stat: Print one-line iops stat
Date: Mon, 26 Jun 2017 14:30:03 +0000
Message-ID: <AT5PR84MB0082C10FAD4DA42F5F7B1295ABDF0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170623222738.5146-1-aherrmann@suse.com>
 <20170623222738.5146-2-aherrmann@suse.com>
In-Reply-To: <20170623222738.5146-2-aherrmann@suse.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>, Jens Axboe <axboe@fb.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Andreas Herrmann
> Sent: Friday, June 23, 2017 5:28 PM
> To: Jens Axboe <axboe@fb.com>
> Cc: fio@vger.kernel.org
> Subject: [PATCH 1/4] stat: Print one-line iops stat
> 
> This adds basic iops statistics (likewise to what we already have for
> bandwidth) to normal and json fio output. Example for normal output:
> 
>    bw (  KiB/s): min=42192, max=162068, per=0.10%, avg=93236.21,
> stdev=22180.02
>    iops : min=21090, max=81020, avg=46606.84, stdev=11088.40
>     lat (usec) : 2=55.13%, 4=21.11%, 10=0.36%, 20=0.03%, 50=23.14%
...
> +		log_buf(out, "   iops : min=%5llu, max=%5llu, avg=%5.02f, "
> +			"stdev=%5.02f\n", min, max, mean, dev);

Seven more spaces are needed to line up the : characters in all the rows.

I don't recommending splitting up a quoted string like that either - it
makes it hard to find things with grep.

---
Robert Elliott, HPE Persistent Memory


