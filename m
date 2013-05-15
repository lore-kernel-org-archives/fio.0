Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35767 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3EOOzn (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 May 2013 10:55:43 -0400
Received: by mail-oa0-f50.google.com with SMTP id l20so2314986oag.9
        for <fio@vger.kernel.org>; Wed, 15 May 2013 07:55:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB02DB4E@DAGN05A-E6.exg6.exghost.com>
References: <CAJqT0iwBcP4tDpAxVbb=y2djj=PobBddGywgiJ8qaifB64Jw3g@mail.gmail.com>
	<A7A1D348E34E024BBC74480FB93A2EAB02DB4E@DAGN05A-E6.exg6.exghost.com>
Date: Wed, 15 May 2013 20:25:42 +0530
Message-ID: <CAJqT0iweAToYYcuJ6cSCs4TB5P974F0DtbW39TKk_nO1CvL94g@mail.gmail.com>
Subject: Re: How to interpret the values saved in latency log files generated
 by FIO
From: sampath rapaka <sampath.rapaka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

hi carl

thanks  your reply. i did look in to that file. I figured out that i
was not specifying direct as 1 resulted in huge values in latency. i
changed it now and everything looks fine.

regards
sampath

On Tue, May 14, 2013 at 8:37 PM, Carl Zwanzig <cpz@coraid.com> wrote:
>
> Hi Sampath,
>
> Much or all of what you ask is described in the HOWTO.txt file. It should be in with all the rest of fio's files or get from http://www.bluestop.org/fio/HOWTO.txt.
>
> z!
