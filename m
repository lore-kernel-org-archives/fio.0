Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi2.enovance.com ([94.143.117.217]:20568 "EHLO
	mxi2.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAPNr (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Apr 2014 11:13:47 -0400
Received: from mxi1.enovance.com (mxi1.enovance.com [94.143.114.217])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mxi2.enovance.com (Postfix) with ESMTP id 0F2F4862B0B
	for <fio@vger.kernel.org>; Tue,  1 Apr 2014 17:00:21 +0200 (CEST)
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 05B36113133B
	for <fio@vger.kernel.org>; Tue,  1 Apr 2014 17:00:21 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 03672780E7E
	for <fio@vger.kernel.org>; Tue,  1 Apr 2014 17:00:21 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id KnY5Ljk82ddX for <fio@vger.kernel.org>;
	Tue,  1 Apr 2014 17:00:20 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id BE99D781357
	for <fio@vger.kernel.org>; Tue,  1 Apr 2014 17:00:20 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iXQRVeZ0asxI for <fio@vger.kernel.org>;
	Tue,  1 Apr 2014 17:00:20 +0200 (CEST)
Received: from localhost.localdomain (94-143-112-83.enovance.net [94.143.112.83])
	by zimbra.enovance.com (Postfix) with ESMTPSA id A98C4780E7E
	for <fio@vger.kernel.org>; Tue,  1 Apr 2014 17:00:20 +0200 (CEST)
Message-ID: <533AD484.2040608@enovance.com>
Date: Tue, 01 Apr 2014 17:00:20 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Surprising use of basename in finish_log_named
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

I had a input of the fio irc channel (yes some at getting into it 
sometimes :p), and he had a very interesting point.

If you specify a full path name for the iops_log, the file will stay 
into the current dir.
While looking at the code I found that finish_log_named() is performing 
the following:

     char file_name[256], *p;
     snprintf(file_name, sizeof(file_name), "%s_%s.log", prefix, postfix);
     p = basename(file_name);

Why do we basename the file_name ? What's the reason of shrinking the 
path this way ?

Note for the author: 256 is maybe too small for some ? :)))

Cheers,
Erwan
