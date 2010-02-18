Return-Path: <fio-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:36563 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab0BRBsz (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Feb 2010 20:48:55 -0500
Received: from fe-emea-09.sun.com (gmp-eb-lb-1-fe1.eu.sun.com [192.18.6.7] (may be forged))
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1I1msuB002060
	for <fio@vger.kernel.org>; Thu, 18 Feb 2010 01:48:54 GMT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KY000400KV8HB00@fe-emea-09.sun.com> for fio@vger.kernel.org; Thu,
 18 Feb 2010 01:48:41 +0000 (GMT)
Received: from [192.168.1.20] ([unknown] [89.180.177.68])
 by fe-emea-09.sun.com (Sun Java(tm) System Messaging Server 7u2-7.04 64bit
 (built Jul  2 2009)) with ESMTPSA id <0KY000ETCL15XQD0@fe-emea-09.sun.com> for
 fio@vger.kernel.org; Thu, 18 Feb 2010 01:48:41 +0000 (GMT)
Date: Thu, 18 Feb 2010 01:48:40 +0000
From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Bad verify header
Message-id: <1266457720.19149.80.camel@cfslap.wizy.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

(Please CC me in the reply, I'm not subscribed)

Hi,

I've justed observed another type of verification failure, using the following
configuration:

--------------------
[global]
ioengine=libaio
iodepth=30
rw=randwrite
bsrange=512-128k
direct=1
verify=sha512
verify_async=8

[/dev/sda2]
--------------------

The output is:

-------------------------
wizeman@cfslap:~/src/fio$ sudo ./fio verify.conf
/dev/sda2: (g=0): rw=randwrite, bs=512-128K/512-128K, ioengine=libaio, iodepth=30
Starting 1 process                                                               
Bad verify header 11a201ef at 7151022087K /s] [0/172 iops] [eta 03m:11s]         
fio: pid=30053, err=84/file:verify.c:840, func=async_verify, error=Invalid or incomplete multibyte or wide character
Bad verify header 713f2224 at 60533760                                                                              
Bad verify header 7df21ab6 at 44630528          
Bad verify header 1124297c at 50690048                                                                              
Bad verify header 6fc5d15f at 102814208                                                                             
Bad verify header 63469875 at 139774464                                                                             
Bad verify header 1743d35f at 164766720                                                                             
Bad verify header 29cbf9d7 at 173868544      
...
-------------------------

This happens on both RHEL5.4 and Ubuntu 9.10.
fio was compiled from source from the latest git commit.

Any ideas of what might be wrong?

Thanks in advance,
Ricardo



