Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:43890 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaCZRjM (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Mar 2014 13:39:12 -0400
Received: by mail-ve0-f171.google.com with SMTP id cz12so2754316veb.16
        for <fio@vger.kernel.org>; Wed, 26 Mar 2014 10:39:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CF576193.61C6%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <CF43A47E.293D5%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CAF+0mv=suTk2XbOuRyhfVyKFVAjk5mhfpawwqP5Nb7BeQKTu0g@mail.gmail.com>
	<CF4BB600.4797%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CF576193.61C6%Antonio.Jose.Rodrigues.Neto@netapp.com>
Date: Wed, 26 Mar 2014 10:39:11 -0700
Message-ID: <CAF+0mvmrsj2DTUN0a0h2_W8=LXpULW8HTzMHwY5cde2WD5ZNTg@mail.gmail.com>
Subject: Re: Compressible and Dedupable ratios using fio
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

> One question:
>
> 1) Are these parameters (randrepeat=0, norandommap=1,
> file_service_type=random) going to help in the randomness and
> compressibility of the data?
>
> 2) Do you have any practical example where I have to use those parameters?
>
> In my tests, I haven't notice any difference.

Data compressibility is only affected by the data pattern.  Randrepeat
and norandommap will only affect the randomness of the io for random
workloads.  For file_service_type, I think this is only used if fio
has multiple files open at the same time, e.g. if multiple filenames
are specified or nrfiles is used.
