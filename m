Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:21305 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3HAKJd (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Aug 2013 06:09:33 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id C6FEC381AE
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 12:09:31 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id C2FCE744C4D
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 12:09:31 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gJ8GYE3gDL5f for <fio@vger.kernel.org>;
	Thu,  1 Aug 2013 12:09:31 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 843DA5D29407
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 12:09:31 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lJWbIegWfOS7 for <fio@vger.kernel.org>;
	Thu,  1 Aug 2013 12:09:31 +0200 (CEST)
Received: from localhost.localdomain (unknown [185.23.92.11])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 417945A8DC52
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 12:09:31 +0200 (CEST)
Message-ID: <51FA33DA.70402@enovance.com>
Date: Thu, 01 Aug 2013 12:09:30 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Empty block size in iops log files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

When running fio and ask it to log bandwidth and iops into log file, I 
discovered that the last column of the bandwidth log file is populated 
with the block size while the iops remains to 0.

Is it an expected behavior ? If not, I can have a look for a patch

Cheers,
