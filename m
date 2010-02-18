Return-Path: <fio-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:36289 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0BRBgJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Feb 2010 20:36:09 -0500
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe1.eu.sun.com [192.18.6.7] (may be forged))
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1I1a30N001468
	for <fio@vger.kernel.org>; Thu, 18 Feb 2010 01:36:07 GMT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KY000100K3TWG00@fe-emea-10.sun.com> for fio@vger.kernel.org; Thu,
 18 Feb 2010 01:35:42 +0000 (GMT)
Received: from [192.168.1.20] ([unknown] [89.180.177.68])
 by fe-emea-10.sun.com (Sun Java(tm) System Messaging Server 7u2-7.04 64bit
 (built Jul  2 2009)) with ESMTPSA id <0KY000JYTKFHOYC0@fe-emea-10.sun.com> for
 fio@vger.kernel.org; Thu, 18 Feb 2010 01:35:42 +0000 (GMT)
Date: Thu, 18 Feb 2010 01:35:41 +0000
From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: Verification failures with mixed read/write case
In-reply-to: <1266456009.19149.72.camel@cfslap.wizy.org>
Message-id: <1266456941.19149.76.camel@cfslap.wizy.org>
References: <1266456009.19149.72.camel@cfslap.wizy.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Ok, this appears to be a bug in the SHA256 function after all:

sha256: verify failed at 0/1310720K/23461K /s] [0/179 iops] [eta
00m:46s]
4234ee764aba733fd973ca3f52ab654e9b2611287eecd75043b45806e725ea6d3817f1342a03bb6835129936feb6d4738e7ca76195c3106055d45d233867777957496c386cbdfd4bcbaab173d391f168df5d3e04f4821f67af2dc17da4a5ff1f56b2e85abdac00677b61470775117408c0b34116b505e46992f21f29d0302132
4234ee764aba733fd973ca3f52ab654e9b2611287eecd75043b45806e725ea6d3817f1342a03bb6835129936feb6d4738e7ca76195c3106055d45d2338677779e41d69b71069690d300255b680aa84b786c769b7ed9380b7000000000000000000000000f0fd7db7020055b6000285b7c59380b7b4f77db7f4df85b780c968b7
sha256: verify failed at 131072/131072
23d88d7345fae206536dc33adfb9be1a4040c654ee68e86121a3380a08884175e1be76634d8fdf02b7680f30f39183707a0e6a589c9fd928ec06c176b2ee29485722d229075c0c1965ae097e00b05a39a4de530104a8621fada832696571b4711f139a3f80cb95431ee6e7590a500927cd701e116c85843219f7a32e79bbaa7e
23d88d7345fae206536dc33adfb9be1a4040c654ee68e86121a3380a08884175e1be76634d8fdf02b7680f30f39183707a0e6a589c9fd928ec06c176b2ee294800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

It works fine with SHA512.

Cheers,
Ricardo

On Qui, 2010-02-18 at 01:20 +0000, Ricardo M. Correia wrote:
> (Please CC me in the reply, I'm not subscribed)
> 
> Hi,
> 
> I've been observing verification failures with the following
> configuration file:
> 
> -----------
> [global]
> ioengine=libaio
> iodepth=30
> rw=randrw
> bs=512-128k
> direct=1
> rwmixcycle=40
> verify=sha256
> verify_async=8
> 
> [/dev/sda2]
> --------------------
> 
> This happens on both RHEL5.4 and Ubuntu 9.10.
> 
> I was observing that with fio-1.36, but I just tried cloning fio from
> the git repo and I'm experiencing the same problem.
> 
> Any ideas of what might be wrong?
> 
> I found this email of a few months ago:
> http://www.spinics.net/lists/fio/msg00205.html
> 
> And I just verified that this patch is in my just-cloned git tree.
> 
> Also, an unrelated issue is that fio complains about 'rwmixcycle' being
> deprecated but the man page doesn't specify what parameter I should be
> using instead.
> 
> Thanks in advance,
> Ricardo
> 


