Return-Path: <fio-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46287 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaCFV2y convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 6 Mar 2014 16:28:54 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 89BA27C06B0
	for <fio@vger.kernel.org>; Thu,  6 Mar 2014 14:22:36 -0700 (MST)
From: Bruce Cran <BCran@fusionio.com>
Subject: RE: [PATCH 0/2] Two small ./configure fixes
Date: Thu, 6 Mar 2014 21:22:30 +0000
Message-ID: <0dee324adeb2479d96ebb8c90a6654ee@DM2PR04MB478.namprd04.prod.outlook.com>
References: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
 <20140306181450.GA23848@sucs.org> <5318E68A.1000904@fb.com>
In-Reply-To: <5318E68A.1000904@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, Sitsofe Wheeler <sitsofe@yahoo.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

The Windows build of fio assumes only a minimal set of POSIX headers is available, so trying to build using Cygwin's GCC and its full set is probably not going to work. Why do you not want to use MinGW GCC?

-- 
Bruce

-----Original Message-----
From: Jens Axboe [mailto:axboe@fb.com] 
Sent: Thursday, March 6, 2014 2:20 PM
To: Sitsofe Wheeler; Stefan Hajnoczi
Cc: fio@vger.kernel.org; Bruce Cran
Subject: Re: [PATCH 0/2] Two small ./configure fixes

On 03/06/2014 11:14 AM, Sitsofe Wheeler wrote:
> On Thu, Mar 06, 2014 at 06:41:57PM +0100, Stefan Hajnoczi wrote:
>> My hopes of cross-compiling fio for Windows were dashed when I 
>> realized pthreads is needed (I guess only Cygwin supports it, not mingw).
>
> I think mingw supports pthreads using winpthreads (see 
> https://urldefense.proofpoint.com/v1/url?u=http://thread.gmane.org/gma
> ne.comp.storage.fio/97/focus%3D149&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r
> =3JMVyziIyZtZ5cv9eWNLwQ%3D%3D%0A&m=UhTi1rWRqSE0ZT%2B5li5HCwkSWuK8mUG1CqLBrQTtHU0%3D%0A&s=28594f27ce732489c3620148921f10705aa70e811eeaf337622bc397dae3f21d ). Does fio even compile with pure cygwin gcc (rather than mingw)? I think I had a brief try and it complained about conflicting headers...

Probably want to pull Bruce into this thread.

--
Jens Axboe



This e-mail (and any attachments) is confidential and may be privileged.  Any unauthorized use, copying, disclosure or dissemination of this communication is prohibited.  If you are not the intended recipient,  please notify the sender immediately and delete all copies of the message and its attachments.
