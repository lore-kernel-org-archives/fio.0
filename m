Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:53257 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaKERUO (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Nov 2014 12:20:14 -0500
Received: by mail-ob0-f182.google.com with SMTP id nt9so1015686obb.27
        for <fio@vger.kernel.org>; Wed, 05 Nov 2014 09:20:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141105171024.GC25731@vass-desktop>
References: <20141105171024.GC25731@vass-desktop>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Wed, 5 Nov 2014 09:19:53 -0800
Message-ID: <CAE56cDtmD7xcGUrbXr1JhweHbqMdEbCnxRAeJkv4G8ikcheJ9w@mail.gmail.com>
Subject: Re: Fix for a race when fio prints I/O statistics periodically
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vasily Tarasov <tarasov@vasily.name>
Cc: fio <fio@vger.kernel.org>

Hey,
This is exactly what I'm seeing as well sporadically. My rig is busy
over the next few days but I'll try verify ASAP with these patches.

Thanks!
Michael
