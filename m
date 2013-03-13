Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:63999 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3CMCtZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 22:49:25 -0400
Received: by mail-ve0-f181.google.com with SMTP id d10so398543vea.12
        for <fio@vger.kernel.org>; Tue, 12 Mar 2013 19:49:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAExtNyFN5mOUFgYaki=64Dd=WA6diu5Q_GiXy0-_JE-5k2cgLw@mail.gmail.com>
References: <1363072013-7562-1-git-send-email-olegmatcovsky@gmail.com>
	<CAKCZDgmZkiTEtw178EZjqaWgrGyXUnD7kKbNM4ymZATeyHow2w@mail.gmail.com>
	<CAKCZDgnkXszwD_Mv6B7kqSfc+icuA3AL3BXp76UCEZYz4DY_Dg@mail.gmail.com>
	<CAExtNyFN5mOUFgYaki=64Dd=WA6diu5Q_GiXy0-_JE-5k2cgLw@mail.gmail.com>
Date: Wed, 13 Mar 2013 13:49:23 +1100
Message-ID: <CAKCZDgmxKb-k5UQLAUSpO-kwUOXgVGAdyvJh=537V1oO4-_3jw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Conditionally include <sys/shm.h> based on OS
 support. Define missing MAP_HUGETLB for Android.
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Oleg Matcovsky <olegmatcovsky@gmail.com>
Cc: fio@vger.kernel.org

On 13 March 2013 12:26, Oleg Matcovsky <olegmatcovsky@gmail.com> wrote:
> Yes, -DFIO_NO_HAVE_SHM_H must be removed from Makefile.
>
> Anyway, I have working Android.mk file and fio builds without any problems.
> Will post for your review tonight.

That's great.  It would be good if you could also test your changes
with an NDK build, which is done something like:

make UNAME=Android
cross_prefix=~/dev/android-toolchain-r8c/bin/arm-linux-androideabi-



Cheers,
  -- Aaron
