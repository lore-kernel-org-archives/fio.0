Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:54937 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187Ab1D2Jos (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 29 Apr 2011 05:44:48 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 3Rxt4dsPYnwLPnZz for <fio@vger.kernel.org>; Fri, 29 Apr 2011 03:44:39 -0600 (MDT)
Message-ID: <4DBA8884.5040605@fusionio.com>
Date: Fri, 29 Apr 2011 11:44:36 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Fio 1.52
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I have tagged version 1.52 of fio. There's not much exciting since
1.51, but one change in particular warrants a note.

As of 1.52, the random generator used for generating IO offset
for random workloads has been changed. We used to rely on
the one supplied by glibc (and similar on other platforms),
but this has a few down sides:

- We did not necessarily generate the same sequences on
  all platforms.
- Our internal generator is faster and from some testing
  of higher quality than the glibc provided one.

So on the plus side we now generate the same IO patterns
on all platforms. The only real downside is that we do not
generate the same IO patterns as 1.51 and previous. This
_should_ not cause any issues, since the pattern should be
equally random. But it will be different. So it is something
to keep in mind, if people use fio for regression runs and
watch performance. We are not at the point where manufacturers
will optimize for a fio workload, so I don't envision any
issues from this change :-)

-- 
Jens Axboe

