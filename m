Return-Path: <fio-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:45312 "EHLO mx143.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbeHaMic (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Aug 2018 08:38:32 -0400
From: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Some questions about FIO
Date: Fri, 31 Aug 2018 08:22:37 +0000
Message-ID: <E61DA2B3-E487-4F06-AB72-2D82233FC1ED@netapp.com>
References: <0C78F71C-8395-44D8-9B9C-E43C89604CF5@netapp.com>,<CALjAwxj8GF=+wx0bTHrQOUxvd_d4=rg2_M00FV2xacyg0Og=EA@mail.gmail.com>
In-Reply-To: <CALjAwxj8GF=+wx0bTHrQOUxvd_d4=rg2_M00FV2xacyg0Og=EA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Thanks my friend

> On Aug 31, 2018, at 2:36 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>=20
> Hey Neto!
>=20
> On Thu, 9 Aug 2018 at 16:58, neto from Brazil
> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>=20
>> Hi All,
>>=20
>> This is neto from Brazil
>>=20
>> How are you?
>>=20
>> I would like to check if we have plans to have the following with FIO:
>>=20
>> 1) When FIO runs, it shows IOPS + MB/s. Do we have any plans to show als=
o average latency? It would be really nice to have the latency (like Vdbenc=
h has) - LIVE
>=20
> This sounds similar to https://github.com/axboe/fio/issues/584 . I
> don't see why it couldn't be done but someone is needed to code it
> up...
>=20
>> 2) It is possible to have an option to show the queue depth used on the =
servers by FIO? It could help to identify potential bottlenecks (e.g. too m=
any threads, etc) on the server side.
>=20
> Technically you get this in the IO depths summary data that fio
> reports back (see
> https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
> ) albeit from fio's perspective.
>=20
>> 3) We don't have a curve option like vdbench. Do we have plans to have i=
t on FIO? It would be really nice to have a parameter like curve (10-120) w=
hich means: try the MAX, after to get the average, does 10%, does 20%. It w=
ould help to identify the "knee" on the curve.
>=20
> From the vdbench manual:
>=20
> "When no skew is requested for any workload involved, determine the
> maximum possible I/O rate by running 'iorate=3Dmax'. After this 'max'
> run, the target skew for the requested workloads will be set to the
> skew that was observed. Workloads of 10%, 50%, 70%, 80%, 90% and 100%
> of the observed maximum I/O rate and skew will be run."
>=20
> Sounds like a mix of Steady state
> (https://fio.readthedocs.io/en/latest/fio_doc.html#steady-state ) and
> diskplorer https://github.com/avikivity/diskplorer with more
> flexibility. Like 1) if someone were to code it up I'm sure it would
> be looked at...
>=20
> --=20
> Sitsofe | http://sucs.org/~sits/

