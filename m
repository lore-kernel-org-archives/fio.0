Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53070 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030617AbaDJNKF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Apr 2014 09:10:05 -0400
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 10 Apr 2014 14:10:03 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 133FA1B08069
	for <fio@vger.kernel.org>; Thu, 10 Apr 2014 14:10:01 +0100 (BST)
Received: from d06av11.portsmouth.uk.ibm.com (d06av11.portsmouth.uk.ibm.com [9.149.37.252])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s3AD9vkL3211584
	for <fio@vger.kernel.org>; Thu, 10 Apr 2014 13:09:57 GMT
Received: from d06av11.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av11.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s3ADA0J2011053
	for <fio@vger.kernel.org>; Thu, 10 Apr 2014 07:10:01 -0600
Received: from dyn-9-152-222-127.boeblingen.de.ibm.com 
	(dyn-9-152-222-127.boeblingen.de.ibm.com [9.152.222.127])by 
	d06av11.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with SMTP id 
	s3ADA0Tv011050for <fio@vger.kernel.org>; Thu, 10 Apr 2014 07:10:00 -0600
Message-Id: <20140410130946.570253556@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2014 15:09:46 +0200
From: <ehrhardt@linux.vnet.ibm.com>
Subject: [patch 0/1] Further timing and nop fixes for the s390 architecture
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


