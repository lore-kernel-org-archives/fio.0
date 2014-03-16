Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44394 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbaCPXxm (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 16 Mar 2014 19:53:42 -0400
Received: by mail-vc0-f170.google.com with SMTP id hu19so5183658vcb.1
        for <fio@vger.kernel.org>; Sun, 16 Mar 2014 16:53:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CF43A47E.293D5%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <CF43A47E.293D5%Antonio.Jose.Rodrigues.Neto@netapp.com>
Date: Sun, 16 Mar 2014 16:53:41 -0700
Message-ID: <CAF+0mv=suTk2XbOuRyhfVyKFVAjk5mhfpawwqP5Nb7BeQKTu0g@mail.gmail.com>
Subject: Re: Compressible and Dedupable ratios using fio
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Mar 10, 2014 at 2:18 PM, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
> Hi All,
>
> This is neto from Brazil
>
> How are you?
>
> I need to know how to control the % of compression and deduplication using
> fio?
>
> My idea is to generate some workload based on:
>
> Workload Random
> 0% compressible and 0% dedupable
>
> Workload Mixed
> 20% compressible and 20% dedupable
>
> Workload Easier
> 100% compressible and 100% dedupable
>
> Could you please help me?
>
> Thank you very much,
>
> All the best
>
> neto
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Neto,

Have you tried using buffer_compress_percentage?  Setting this to 100
would get you 100% compressible data while 0 would be 0% compressible.
 Note that if you use fio prior to version 2.1.6 in git, you will also
want to set scramble_buffers=0 to get the desired compression.

I don't know how you would control how dedupable the data is, since to
my knowledge there is no way to specify how repeatable the data
pattern is.  But I think fully incompressible data is naturally not
dedupable, while the opposite is true for fully compressible data.
