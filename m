Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1BIPYI (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Feb 2011 10:24:08 -0500
Received: by wyb28 with SMTP id 28so287403wyb.19
        for <fio@vger.kernel.org>; Wed, 09 Feb 2011 07:24:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikE1=RGwdi85tqFfFw6g7=KyzBAXURDiKhevc_P@mail.gmail.com>
References: <AANLkTimVOrLR+MJDhg5Q=vfLvNKbfP4H6i3iJNjxPgpe@mail.gmail.com>
	<AANLkTikE1=RGwdi85tqFfFw6g7=KyzBAXURDiKhevc_P@mail.gmail.com>
Date: Wed, 9 Feb 2011 15:24:06 +0000
Message-ID: <AANLkTim47WLLX9SmiMkBE+gK8cv7BEJRVNSYZt0Y9jp9@mail.gmail.com>
Subject: Re: FIO is CPU bound on small block sizes
From: "Bike & Snow" <bikeandsnow@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Thanks Chris & Jens.

Sounds really obviously now - just run multiple threads of FIO.

This is what I get now on 512B block size:
203,216 IOPs

That is using 8 threads and an IOdepth of 32.

The RAID array is now being stressed and not the CPU.
