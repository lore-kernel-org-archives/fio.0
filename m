Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56452 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbbFDNKi (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Jun 2015 09:10:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1Z0Uug-0000NJ-Bo
	for fio@vger.kernel.org; Thu, 04 Jun 2015 15:10:26 +0200
Received: from lmcpra.ericsson.ca ([192.75.88.231])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Thu, 04 Jun 2015 15:10:26 +0200
Received: from viali.lee by lmcpra.ericsson.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Thu, 04 Jun 2015 15:10:26 +0200
From: FIO-User-KKV <viali.lee@gmail.com>
Subject: Re: Parameter Issue with 'ratemin'...
Date: Thu, 4 Jun 2015 13:10:08 +0000 (UTC)
Message-ID: <loom.20150604T150859-664@post.gmane.org>
References: <loom.20150603T211024-259@post.gmane.org> <CY1PR02MB1303CE323DB544A10F37A24381B40@CY1PR02MB1303.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hinson, Roger <Roger_Hinson@...> writes:

> 
> 
> -----Original Message-----
> From: fio-owner@...
> [mailto:fio-owner@...] On Behalf Of FIO-User-KKV
> Sent: Wednesday, June 03, 2015 12:21 PM
> To: fio@...
> Subject: Parameter Issue with 'ratemin'...
> 
> Hi, I am using Fio 2.2.8.
> I have an issue when setting the parameter 'ratemin'.
> It only accepts '0'!
> no matter what non-zero values I set, 
> 
> e.g., 
> sudo fio -name "SOURCE"  -numjobs 1  -bs 1M   -rw write -direct 1 -
runtime 
> 50 -filename=/dev/vdb  -prio 0 -ratemin=1K
> 
> I will end up quickly with "fio: minimum rate exceeds rate"!
> Could anyone know what's wrong there?
> 
> Thanks!
> 
> --
> Hey,
> 
> The value of ratemin needs to be an int.  If you want 1000, you need 
to enter as 1000, not 1K.
> 
> Roger
> 
> 
Hi, thanks for the quick reply.
I also tried 1000, or 1, or 100 whatever...
It didn't work...
I always got "fio: minimum rate exceeds rate".
only 0 works.....



