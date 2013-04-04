Return-Path: <fio-owner@vger.kernel.org>
Received: from server506f.appriver.com ([50.56.144.36]:51155 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764420Ab3DDTH7 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 4 Apr 2013 15:07:59 -0400
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: How to re-use default sequential filenames?
Date: Thu, 4 Apr 2013 19:02:55 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB023D8F@DAGN05A-E6.exg6.exghost.com>
References: <515DAA33.4000009@warnerbros.com>
 <CAN2qFapd8shvoG+eJSa5TRv-jzW-Cms-PKJM+PcxUGeXnwGBJw@mail.gmail.com>
In-Reply-To: <CAN2qFapd8shvoG+eJSa5TRv-jzW-Cms-PKJM+PcxUGeXnwGBJw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matt Hayward <matt.hayward@delphix.com>, Alan Hagge <Alan.Hagge@warnerbros.com>
Cc: fio <fio@vger.kernel.org>

> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Matt Hayward

> It seems possible that doing this for 20000 files might create a
> problem with the length of the parameter...

Seems to me also that multiple servers would be in order. You'd need something pretty beefy to swing that many processes and open files.  Which OS and file system are you using? The original email mentions posixaid, and assuming linux, I've had better throughput with linux's libaio. Also beware of one process forking that many subprocesses. Not saying that it can't be done, but I'd probably distribute that kind of load over at least 10 initiators, and maybe more.

Have you done any back-of-the-envelope calculations for where the bottlenecks might be? A 10g connection at best moves only about 1.2gB/sec (including overhead), which divided by 20k streams gives only about 60kB/sec per stream (have I got that right?) and again, that doesn't account for any overhead.  Likewise, a single 3.5" rotating drive generally won't deliver more than about 150 random write IOPS with write cache enabled, and 2/3 to 1/2 that with the cache disabled. Even with large sequential blocks at the user level, with that many streams into a file system, it can take the appearance of almost pure random access.

z!

