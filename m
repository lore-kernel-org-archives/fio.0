Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:54045 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3GWKXV (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Jul 2013 06:23:21 -0400
Message-ID: <51EE5997.6070804@enovance.com>
Date: Tue, 23 Jul 2013 12:23:19 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: segmentation fault on power system
References: <20130723101359.GC2152@localhost.localdomain>
In-Reply-To: <20130723101359.GC2152@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: fio@vger.kernel.org

On 23/07/2013 12:13, Han Pingtian wrote:
> Hey there,
>
> When trying to run fio on one of our power system, segmentation fault
>
Can you give us the kind of cpu you are using ? (/proc/cpuinfo)
I'm not used with PPC but maybe your processor doesn't support ATBU call 
on mfspr.

Erwan,
