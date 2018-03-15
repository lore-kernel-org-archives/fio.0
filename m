Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:33237 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbeCOQbG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Mar 2018 12:31:06 -0400
Received: by mail-ua0-f174.google.com with SMTP id f6so4783895ual.0
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 09:31:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB11166E39586E25D46B482E4581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CAODBMz=rOy1kJGVGn3fyCGT78QUK0BH0rzw7cTRMxKZ6sdSF-Q@mail.gmail.com>
 <CY1PR0401MB11166E39586E25D46B482E4581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 15 Mar 2018 16:30:35 +0000
Message-ID: <CALjAwxgn-yxPf5noENrdbhPKS7T3BVsArSa8wG50e0r88DPr-A@mail.gmail.com>
Subject: Re: ZBC/FLEX FIO addition ideas
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: Phillip Chen <phillip.a.chen@seagate.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>

On 15 March 2018 at 16:15, Kris Davis <Kris.Davis@wdc.com> wrote:
> Despite the desire to have fio work with Host Managed devices independent=
 of the engine, a Host Managed device operation is different than a traditi=
onal block device, and the kernel also has to manage it differently. Thus, =
I would still recommend creating a new IO engine for use with Host Managed =
devices, we would not want the additional overhead associated with SMR to i=
mpact the standard aio engine.  We have mostly used the fio SG engine along=
 with external operations in testing of SMR.
>
> Here is the way we envision a new fio engine might work with Host Managed=
 devices:

It's definitely going to need something special. I think last time
round (https://www.spinics.net/lists/fio/msg06646.html ) I suggested a
profile but perhaps that won't be enough. I doubt an ioengine would be
enough because you're going to have interact with the next offset code
etc. unless you're going to fake I/Os done to "wrong" regions...

--=20
Sitsofe | http://sucs.org/~sits/
