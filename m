Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0F2Tct (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 29 Jun 2010 15:32:49 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5TJWmjk013272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <fio@vger.kernel.org>; Tue, 29 Jun 2010 15:32:48 -0400
Received: from machine.usersys (dhcp-100-19-106.bos.redhat.com [10.16.19.106])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5TJWmmu016713
	for <fio@vger.kernel.org>; Tue, 29 Jun 2010 15:32:48 -0400
Date: Tue, 29 Jun 2010 15:32:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Have we changed number of fields in fio --minimal output
Message-ID: <20100629193247.GA3819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I was running latest fio and noticed that number of fields in fio
--minimal output have gone up from 69 to 77. A increase of 8 fields. Don't
see any update in --minimal documentation. Is it regarding total latency
thing?

Thanks
Vivek
