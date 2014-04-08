Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:47889 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaDHPwu (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Apr 2014 11:52:50 -0400
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Tue, 8 Apr 2014 16:52:48 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id EC95E2190041
	for <fio@vger.kernel.org>; Tue,  8 Apr 2014 16:52:40 +0100 (BST)
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s38Fqako64946236
	for <fio@vger.kernel.org>; Tue, 8 Apr 2014 15:52:36 GMT
Received: from d06av05.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s38FqkDt005935
	for <fio@vger.kernel.org>; Tue, 8 Apr 2014 09:52:46 -0600
Received: from dyn-9-152-222-127.boeblingen.de.ibm.com (dyn-9-152-222-127.boeblingen.de.ibm.com [9.152.222.127])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with SMTP id s38FqkUk005931
	for <fio@vger.kernel.org>; Tue, 8 Apr 2014 09:52:46 -0600
Message-Id: <20140408155159.696154675@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2014 17:51:59 +0200
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 0/2] timing and nop fixes for the s390 architecture
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Testing recent fio code revealed a few issues on s390.
The patches in this series aim to fix them.

