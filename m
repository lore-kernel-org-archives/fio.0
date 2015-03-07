Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:36334 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbCGSZw (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 7 Mar 2015 13:25:52 -0500
Received: by qgdz107 with SMTP id z107so20055923qgd.3
        for <fio@vger.kernel.org>; Sat, 07 Mar 2015 10:25:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D1208B18.10E7D%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D1208B18.10E7D%Antonio.Jose.Rodrigues.Neto@netapp.com>
Date: Sat, 7 Mar 2015 10:25:51 -0800
Message-ID: <CAM8G_BLSbvr322m7y0Q2Z6vcpFMQyRqALNj3q3LPp-dYFtdSEQ@mail.gmail.com>
Subject: Re: Rate for write IOPS read IOPS
From: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Wish one could :) and all the storage vendors will be clueless how fio
got it :) , IOPS is "Per Second" not "Per Hour or Per Year"

On Sat, Mar 7, 2015 at 8:01 AM, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
> Hi All,
>
> This is neto from Brazil
>
> How are you?
>
> I need to generate a workload as:
>
> 45,000 IOPS (write)
> 7,000  IOPS (read)
>
> I have tried to use rate_iops and rwmixread and rxmixwrite. I was able to
> rate the workload at 52,000 IOPS but no matter the % value that I use at
> rwmixread and rwmixwrite, I always have 50/50 read/write.
>
> Is there any way to specify: I want 45,000 IOPS writes and 7,000 IOPS
> reads.
>
> Thank you,
>
> All the best
>
> neto
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
A ship is safer in a harbor.  But that's not what ships are built for.
