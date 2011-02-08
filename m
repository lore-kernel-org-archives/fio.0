Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33649 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1BHODA (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Feb 2011 09:03:00 -0500
Received: by vxb37 with SMTP id 37so2472059vxb.19
        for <fio@vger.kernel.org>; Tue, 08 Feb 2011 06:02:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimVOrLR+MJDhg5Q=vfLvNKbfP4H6i3iJNjxPgpe@mail.gmail.com>
References: <AANLkTimVOrLR+MJDhg5Q=vfLvNKbfP4H6i3iJNjxPgpe@mail.gmail.com>
Date: Tue, 8 Feb 2011 07:02:59 -0700
Message-ID: <AANLkTikE1=RGwdi85tqFfFw6g7=KyzBAXURDiKhevc_P@mail.gmail.com>
Subject: Re: FIO is CPU bound on small block sizes
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bike & Snow <bikeandsnow@googlemail.com>
Cc: fio@vger.kernel.org

On Tue, Feb 8, 2011 at 3:30 AM, Bike & Snow <bikeandsnow@googlemail.com> wrote:
<snip>
> I can see when observing the output from "top" that the "fio" thread
> is at 99% for the smaller block sizes.

Why not increase the thread count?
