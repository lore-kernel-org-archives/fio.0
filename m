Return-Path: <fio-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:48107 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2GIRpS (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 9 Jul 2012 13:45:18 -0400
Received: from zion.americas.sgi.com (zion.americas.sgi.com [128.162.236.17])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B922B8F8081
	for <fio@vger.kernel.org>; Mon,  9 Jul 2012 10:45:17 -0700 (PDT)
Received: (from emery@localhost) by zion.americas.sgi.com (8.12.9/ASC-news-1.4) id q69HjHfr25428921 for fio@vger.kernel.org; Mon, 9 Jul 2012 12:45:17 -0500 (CDT)
Date: Mon, 9 Jul 2012 12:45:17 -0500 (CDT)
From: Scott Emery <emery@sgi.com>
Message-Id: <201207091745.q69HjHfr25428921@zion.americas.sgi.com>
Subject: Glitch in HOW-TO?
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org



	I'm guessing that the following two entries should be merged
under "write_iops_log=str" (given the context in the HOW-TO file).

---
write_bw_log=str If given, write an IOPS log of the jobs in this job
                file. See write_bw_log.

write_iops_log=str Same as write_bw_log, but writes IOPS. If no filename is
                given with this option, the default filename of
                "jobname_type.log" is used. Even if the filename is given,
                fio will still append the type of log.
---

Scott Emery
emery@sgi.com
