Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:42456 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbGBWPb (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Jul 2015 18:15:31 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 1F99E273154
	for <fio@vger.kernel.org>; Thu,  2 Jul 2015 16:15:30 -0600 (MDT)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id k882gLi06j-I for <fio@vger.kernel.org>;
	Thu,  2 Jul 2015 16:15:29 -0600 (MDT)
Received: from [10.50.3.54] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Thu,  2 Jul 2015 16:15:28 -0600 (MDT)
From: Bruce Cran <bruce@cran.org.uk>
Subject: gcc 5.1.1 and warnings when building fio on Linux with -flto
Message-ID: <5595B800.3030303@cran.org.uk>
Date: Thu, 2 Jul 2015 16:15:28 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Noticed the following warnings when building fio on Linux with gcc 5.1.1 
and -flto:

debug.h:38:22: warning: type of ‘fio_debug’ does not match original 
declaration
  extern unsigned long fio_debug;
                       ^
t/debug.c:5:14: note: previously declared here
  unsigned int fio_debug = 0;


lib/libmtd.c: In function ‘mtd_get_dev_info1’:
lib/libmtd.c:751:46: warning: passing argument 3 of ‘dev_read_data’ 
discards ‘const’ qualifier from pointer target type 
[-Wdiscarded-array-qualifiers]
   ret = dev_read_data(lib->mtd_name, mtd_num, &mtd->name,
                                               ^
lib/libmtd.c:184:12: note: expected ‘void *’ but argument is of type 
‘const char (*)[128]’
  static int dev_read_data(const char *patt, int mtd_num, void *buf, int 
buf_len)
             ^
lib/libmtd.c:757:46: warning: passing argument 3 of ‘dev_read_data’ 
discards ‘const’ qualifier from pointer target type 
[-Wdiscarded-array-qualifiers]
   ret = dev_read_data(lib->mtd_type, mtd_num, &mtd->type_str,
                                               ^
lib/libmtd.c:184:12: note: expected ‘void *’ but argument is of type 
‘const char (*)[65]’
  static int dev_read_data(const char *patt, int mtd_num, void *buf, int 
buf_len)


-- 
Bruce
