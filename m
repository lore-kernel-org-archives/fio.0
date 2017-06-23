Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:58245 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754510AbdFWW2I (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 23 Jun 2017 18:28:08 -0400
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v4 0/4] stat: Modify info for bw and add iops stats
Date: Sat, 24 Jun 2017 00:27:34 +0200
Message-Id: <20170623222738.5146-1-aherrmann@suse.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

Hi,

Next try. Changes to previous version:

[PATCH 1/4] stat: Print one-line iops stat			     
 - Added client conversion and bump server version
[PATCH 2/4] stat: Print number of samples in bw and iops stats  
[PATCH 3/4] stat: Merge show_thread_status_terse_* functions    
[PATCH 4/4] stat: Add iops stat and sample number information to
 - Added explanation of v5 terse format to man page and HOWTO
 - Continue to report TRIM status with terse version 5

One oddity I've spotted is that man page states

 "text description (if provided in config - appears on newline)"

But I think that this applies only to v2 terse format.

My merge of the terse output functions tried to preserve the code as
is so no newline for v3 and above.

If the newline is the desired behaviour I'll send a follow-on patch to
adapt the code to the man-page (and if not vice versa).



Regards,

Andreas
