Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58999 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3HSBYj (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 18 Aug 2013 21:24:39 -0400
Received: by mail-wg0-f53.google.com with SMTP id c11so3093826wgh.32
        for <fio@vger.kernel.org>; Sun, 18 Aug 2013 18:24:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9E26C6259ACF1842A4815F929194EDD36FEDD89F@phex01.corp.bitmicro.com>
References: <CA+8ZFnhapBuTo0U9Loyg=zrGHxf2GGJN2=LTu2Sw0oJWKHNicA@mail.gmail.com>
	<20130813144311.GI25668@kernel.dk>
	<CA+8ZFnhH9Dg7-nsH52KALp1RaREVy51AKkd0_d_m2WPiv4AesA@mail.gmail.com>
	<9E26C6259ACF1842A4815F929194EDD36FEDD89F@phex01.corp.bitmicro.com>
Date: Mon, 19 Aug 2013 09:24:38 +0800
Message-ID: <CA+8ZFnh8_3vKgoO4w6CdHkn2NAAWD8natJmNJCeskPd+abh9cQ@mail.gmail.com>
Subject: Re: Encountered Mix Access R/W Problem
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Aug 16, 2013 at 1:44 PM, Ritchie Babaylan
<Ritchie.Babaylan@bitmicro.com> wrote:
> Hi,
>
> I use FIO-2.1.1 in one of my system running a simple workload with the following details.
>         64KB; 60% Sequential 60% Read; 1-Depth / 1-Job
>         64KB; 30% Sequential 60% Read; 1-Depth / 1-Job
>
> The result of the metrics for Read/Write access are zero as reflected on the command line in Windows 7 32-bit. I'd like to seek help why I am getting a zero metrics on Read/Write access.

I'm a rookie to fio :). And I have seen zero metics when I used loop
device on Ubuntu. Did you use a pseudo-device?
Can you post the whole fio script content?
-- 
-Thanks.
- xan.peng
