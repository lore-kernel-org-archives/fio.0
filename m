Return-Path: <fio-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:59795 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab0BRBjs (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Feb 2010 20:39:48 -0500
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe1.eu.sun.com [192.18.6.7] (may be forged))
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1I1KPOm025248
	for <fio@vger.kernel.org>; Thu, 18 Feb 2010 01:20:27 GMT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KY000C00JEVVF00@fe-emea-10.sun.com> for fio@vger.kernel.org; Thu,
 18 Feb 2010 01:20:11 +0000 (GMT)
Received: from [192.168.1.20] ([unknown] [89.180.177.68])
 by fe-emea-10.sun.com (Sun Java(tm) System Messaging Server 7u2-7.04 64bit
 (built Jul  2 2009)) with ESMTPSA id <0KY000J00JPMOY90@fe-emea-10.sun.com> for
 fio@vger.kernel.org; Thu, 18 Feb 2010 01:20:11 +0000 (GMT)
Date: Thu, 18 Feb 2010 01:20:09 +0000
From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Verification failures with mixed read/write case
Message-id: <1266456009.19149.72.camel@cfslap.wizy.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

(Please CC me in the reply, I'm not subscribed)

Hi,

I've been observing verification failures with the following
configuration file:

-----------
[global]
ioengine=libaio
iodepth=30
rw=randrw
bs=512-128k
direct=1
rwmixcycle=40
verify=sha256
verify_async=8

[/dev/sda2]
--------------------

This happens on both RHEL5.4 and Ubuntu 9.10.

I was observing that with fio-1.36, but I just tried cloning fio from
the git repo and I'm experiencing the same problem.

Any ideas of what might be wrong?

I found this email of a few months ago:
http://www.spinics.net/lists/fio/msg00205.html

And I just verified that this patch is in my just-cloned git tree.

Also, an unrelated issue is that fio complains about 'rwmixcycle' being
deprecated but the man page doesn't specify what parameter I should be
using instead.

Thanks in advance,
Ricardo


