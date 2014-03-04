Return-Path: <Eric.Lamkin@lsi.com>
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Tue, 4 Mar 2014 13:37:57 +0000
Message-ID: <77fa8ec86fa9425d9360595b0a2edc71@BN1PR07MB437.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk>
 <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
 <70dc0e01a5674f159ed9e02dc61b64ce@BN1PR07MB437.namprd07.prod.outlook.com>
 <CAB-428m7+O6c+H8Lx1N0d3nQkgx5aMeuFf55+mw7Kvq6+a6=kA@mail.gmail.com>
In-Reply-To: <CAB-428m7+O6c+H8Lx1N0d3nQkgx5aMeuFf55+mw7Kvq6+a6=kA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, David Nellans <david@nellans.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Alireza,

I provided the information to show how I ran a replay along with the differ=
ences between the original trace and the replay trace with the hope of rece=
iving some advice on what I was doing wrong to cause replay to stop short.

So my interpretation is that something went wrong.  Please help determine w=
hat I need to do to use replay correctly.

Eric
-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Alireza Haghdoost
Sent: Monday, March 03, 2014 9:13 PM
To: Lamkin, Eric
Cc: Jens Axboe; David Nellans; fio@vger.kernel.org
Subject: Re: fio replay

On Mon, Mar 3, 2014 at 7:25 AM, Lamkin, Eric <Eric.Lamkin@lsi.com> wrote:
>
> Comparative analysis replay to original Capture time .88% % reads=20
> +1.16% % writes -1.16% Block range 104% Queue operations .78% Blocks=20
> queued .78% % sequential queued 108% Max blocks per sequential run=20
> 31.4% Completion operations 1.42% Blocks completed .78% % sequential=20
> completions 110%


Eric,

Thanks for sharing the results with us. I am interested to hearing your int=
erpretation on this comparison...

--
Alireza
--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html


