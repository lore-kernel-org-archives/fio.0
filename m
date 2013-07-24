Return-Path: <fio-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:38461 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3GXBkb (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Jul 2013 21:40:31 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <hanpt@linux.vnet.ibm.com>;
	Tue, 23 Jul 2013 19:40:30 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id D93603E40045
	for <fio@vger.kernel.org>; Tue, 23 Jul 2013 19:40:06 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r6O1eSPv159014
	for <fio@vger.kernel.org>; Tue, 23 Jul 2013 19:40:28 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r6O1eSv5016291
	for <fio@vger.kernel.org>; Tue, 23 Jul 2013 19:40:28 -0600
Date: Wed, 24 Jul 2013 09:40:26 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Subject: Re: segmentation fault on power system
Message-ID: <20130724014026.GD2152@localhost.localdomain>
References: <20130723101359.GC2152@localhost.localdomain>
 <51EE5997.6070804@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE5997.6070804@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: fio@vger.kernel.org

On Tue, Jul 23, 2013 at 12:23:19PM +0200, Erwan Velu wrote:
> On 23/07/2013 12:13, Han Pingtian wrote:
> >Hey there,
> >
> >When trying to run fio on one of our power system, segmentation fault
> >
> Can you give us the kind of cpu you are using ? (/proc/cpuinfo)
> I'm not used with PPC but maybe your processor doesn't support ATBU
> call on mfspr.
> 
> Erwan,

This is the contents of /proc/cpuinfo:

processor       : 0
cpu             : POWER7 (architected), altivec supported
clock           : 3550.000000MHz
revision        : 2.3 (pvr 003f 0203)

processor       : 1
cpu             : POWER7 (architected), altivec supported
clock           : 3550.000000MHz
revision        : 2.3 (pvr 003f 0203)

processor       : 2
cpu             : POWER7 (architected), altivec supported
clock           : 3550.000000MHz
revision        : 2.3 (pvr 003f 0203)

processor       : 3
cpu             : POWER7 (architected), altivec supported
clock           : 3550.000000MHz
revision        : 2.3 (pvr 003f 0203)

timebase        : 512000000
platform        : pSeries
model           : IBM,8231-E2C
machine         : CHRP IBM,8231-E2C

