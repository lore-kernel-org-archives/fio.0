Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:35071 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752774AbeFNHmC (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 14 Jun 2018 03:42:02 -0400
Received: by mail-ot0-f172.google.com with SMTP id q17-v6so5991306otg.2
        for <fio@vger.kernel.org>; Thu, 14 Jun 2018 00:42:02 -0700 (PDT)
MIME-Version: 1.0
References: <SN6PR04MB40649343247761CFB42764468F7F0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <CAHndrB=vMFT8Si+9VCYVzdt17E3MiN=FF=MHd_0f__+LPr_n3Q@mail.gmail.com> <SN6PR04MB406453E0B3B53A20632F16BA8F7E0@SN6PR04MB4064.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB406453E0B3B53A20632F16BA8F7E0@SN6PR04MB4064.namprd04.prod.outlook.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Thu, 14 Jun 2018 16:41:28 +0900
Message-ID: <CAHndrBm8apZhNeCEd8UC=-xTbrnNoK3=BC-D-7R5U=bC7_g5jw@mail.gmail.com>
Subject: Re: fio environment var bug
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: fio <fio@vger.kernel.org>

Jeff Furlong <jeff.furlong@wdc.com>:
>
> >Do you have QD=1 on server side ?
> >If not then your server probably failed to parse test.job contents sent from client after socket is initialized.
>
> Thanks.  Now I see your point.  The correct way to specify an environment variable for client/server would be to specify at the server invocation time:

Yes, that's the way it works, but as you mentioned I think this is a
bug (should be done on the client side).

>
> # QD=1  fio --server=localhost&
>
> Then run the client normally:
>
> # fio --client=localhost test.job
>
> Regards,
> Jeff
>
>
