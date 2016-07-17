Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33850 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbcGQIra (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 17 Jul 2016 04:47:30 -0400
Received: by mail-vk0-f46.google.com with SMTP id o63so206185998vkg.1
        for <fio@vger.kernel.org>; Sun, 17 Jul 2016 01:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nm9c13$dsi$1@ger.gmane.org>
References: <nlha7f$a7q$2@ger.gmane.org> <nlhb66$rd6$1@ger.gmane.org>
 <CALjAwxjnttcDporW3ep6hi7URVUCnD=GCwdYpmR10DHkQPTfEw@mail.gmail.com> <nm9c13$dsi$1@ger.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 17 Jul 2016 09:47:28 +0100
Message-ID: <CALjAwxja9aXziSs51oHL1XYyVtbME0+6BTZ_g8v8B3hpwGG-zw@mail.gmail.com>
Subject: Re: fio2gnuplot issue
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saeed <ionictea@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 15 July 2016 at 01:50, Saeed <ionictea@gmail.com> wrote:
> Thanks!  I suspected it must've been something with gnuplot because it seems
> to work with Ubuntu 15.xx (running Gnuplot 4.xx) and breaks with Ubuntu
> 16.xxx (running Gnuplot 5.xx).
>
> I tried contacting Erwan for an answer on a possible update but gotten no
> response.

I've posted some changes that seem to get things going under gnuplot 5
for me. Could you check to see if
https://github.com/axboe/fio/pull/208 lets things work for you on
Ubuntu 16.04?

-- 
Sitsofe | http://sucs.org/~sits/
