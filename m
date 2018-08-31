Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f42.google.com ([209.85.222.42]:37045 "EHLO
        mail-ua1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbeHaKmO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Aug 2018 06:42:14 -0400
Received: by mail-ua1-f42.google.com with SMTP id y10-v6so7414558uao.4
        for <fio@vger.kernel.org>; Thu, 30 Aug 2018 23:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <0C78F71C-8395-44D8-9B9C-E43C89604CF5@netapp.com>
In-Reply-To: <0C78F71C-8395-44D8-9B9C-E43C89604CF5@netapp.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Aug 2018 07:35:51 +0100
Message-ID: <CALjAwxj8GF=+wx0bTHrQOUxvd_d4=rg2_M00FV2xacyg0Og=EA@mail.gmail.com>
Subject: Re: Some questions about FIO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: fio <fio@vger.kernel.org>

Hey Neto!

On Thu, 9 Aug 2018 at 16:58, neto from Brazil
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
> Hi All,
>
> This is neto from Brazil
>
> How are you?
>
> I would like to check if we have plans to have the following with FIO:
>
> 1) When FIO runs, it shows IOPS + MB/s. Do we have any plans to show also=
 average latency? It would be really nice to have the latency (like Vdbench=
 has) - LIVE

This sounds similar to https://github.com/axboe/fio/issues/584 . I
don't see why it couldn't be done but someone is needed to code it
up...

> 2) It is possible to have an option to show the queue depth used on the s=
ervers by FIO? It could help to identify potential bottlenecks (e.g. too ma=
ny threads, etc) on the server side.

Technically you get this in the IO depths summary data that fio
reports back (see
https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
) albeit from fio's perspective.

> 3) We don't have a curve option like vdbench. Do we have plans to have it=
 on FIO? It would be really nice to have a parameter like curve (10-120) wh=
ich means: try the MAX, after to get the average, does 10%, does 20%. It wo=
uld help to identify the "knee" on the curve.

From the vdbench manual:

"When no skew is requested for any workload involved, determine the
maximum possible I/O rate by running 'iorate=3Dmax'. After this 'max'
run, the target skew for the requested workloads will be set to the
skew that was observed. Workloads of 10%, 50%, 70%, 80%, 90% and 100%
of the observed maximum I/O rate and skew will be run."

Sounds like a mix of Steady state
(https://fio.readthedocs.io/en/latest/fio_doc.html#steady-state ) and
diskplorer https://github.com/avikivity/diskplorer with more
flexibility. Like 1) if someone were to code it up I'm sure it would
be looked at...

--=20
Sitsofe | http://sucs.org/~sits/

