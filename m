Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:33327 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbeC0Q5V (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Mar 2018 12:57:21 -0400
Received: by mail-ua0-f181.google.com with SMTP id f6so14774806ual.0
        for <fio@vger.kernel.org>; Tue, 27 Mar 2018 09:57:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116E6D05D5F5FCC0283298581AC0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB111683B907AEAA34BB0A9A3881A80@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjzvd7dBTYGBSMaiSWm+v+LgbcrtKdh7EpZdNWtwmcubg@mail.gmail.com>
 <CALjAwxjN890tChPL2cOw2NsU_M-85GcEJKq8XwotYNOoDgxEtA@mail.gmail.com>
 <CY1PR0401MB1116191E688201AE89DA270381AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhhXogm8x_7RbdOBq0wOEFSrguL2S-qTpN=7ahO=HZ_0g@mail.gmail.com>
 <CY1PR0401MB111665D846A301C108F9694B81AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxibi4Pfy0OtBaWkwnoyYbQm+pZvhdUK_WWGEDPc6+DVdg@mail.gmail.com>
 <CY1PR0401MB1116C049AE98BC39FC9100C281AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjBiLRoQckkYqa8ywSm1CF5noqptgaZhZb8J3DSjg3dGw@mail.gmail.com> <CY1PR0401MB1116E6D05D5F5FCC0283298581AC0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Mar 2018 17:56:49 +0100
Message-ID: <CALjAwxg3-L4EgN2xBGtw6kgPVz=_f3uwGr3zwBdU_JrPoJ41+Q@mail.gmail.com>
Subject: Re: "No I/O performed by <engine>" reporting bug?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Itay Ben Yaacov <Itay.BenYaacov@wdc.com>

On 27 March 2018 at 16:23, Kris Davis <Kris.Davis@wdc.com> wrote:
>
> I'm wondering if I've completely misunderstood the meaning of "looping". =
 I was thinking it basically meant to "repeat" the job specification a numb=
er of times, but from your description of the impacts, that appears to be w=
rong.
>
> Looking at other verbiage in the doc, "loops" say to "repeat same workloa=
d a given number of times".  Under time_based, it says "it will simply loop=
 over the same workload as many times as runtime allows".    I'm wondering =
if the word 'loop' is really means the same thing in these two descriptions=
.  If nothing is really "reset" between loop iterations, then it seems to m=
e that these two uses of 'loop' mean the same thing.

I'd argue both reset the offset when the end of the file is reached
when you're doing sequential I/O and they reset the areas available to
be used when doing random I/O that is also using a randommap. Certain
specific things can also be set to happen on each loop to (e.g. see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-unlink-each-=
loop
). I think verification do_verify verification passes also run after
each write job loop but I'd have to check.

> Sorry if I'm missing the point, but if the "loops" option really doesn't =
effect other aspects like the runtime, ramp_time or resetting LBAs and such=
, I'm confused when "loops" would be used - what does it accomplish that is=
n't available through other options?

It saves some calculation. Imagine I want a run where I write the
entire file twice and I don't know its size then I could use loops=3D2 .
LBAs are definitely being reset in simple loops jobs...

--=20
Sitsofe | http://sucs.org/~sits/
