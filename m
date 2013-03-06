Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:60674 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab3CFWTU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 Mar 2013 17:19:20 -0500
Received: by mail-ve0-f170.google.com with SMTP id 14so7217111vea.15
        for <fio@vger.kernel.org>; Wed, 06 Mar 2013 14:19:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <809551062.20130306191204@serebryakov.spb.ru>
References: <809551062.20130306191204@serebryakov.spb.ru>
Date: Wed, 6 Mar 2013 14:19:19 -0800
Message-ID: <CAN2qFarWnbLA8gqhBx=k04gUB6vVaHSBQP_pCn78h22WpTgjMg@mail.gmail.com>
Subject: Re: How to layout sparce files before run? Why all files for all jobs
 have same size?
From: Matt Hayward <matt.hayward@delphix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Lev Serebryakov <lev@serebryakov.spb.ru>
Cc: fio@vger.kernel.org

Hello Lev,
   What happens if you pre-create the sparse files before you invoke
fio and then use the filename= argument to specify to fio to use your
sparse files?

On Wed, Mar 6, 2013 at 7:12 AM, Lev Serebryakov <lev@serebryakov.spb.ru> wrote:
>
> Hello, Fio.
>
>   How could I tell fio to don't write anything but last byte into
>  files used for jobs? I need to test random write to sparse files with
>  read only from written parts (like dumb torrent clients does).
>
>   And why when I have N jobs with "filesize=2G-4G" all filesizes for
>  all jobs are equal?
>
> --
> // Black Lion AKA Lev Serebryakov <lev@serebryakov.spb.ru>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Matthew Hayward
Director Professional Services
Delphix:
https://www.facebook.com/DelphixCorp
https://twitter.com/delphixcorp
M: 206.849.6389
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
