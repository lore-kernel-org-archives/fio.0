Return-Path: <ladros@gmail.com>
MIME-Version: 1.0
Sender: ladros@gmail.com
In-Reply-To: <CAKa9Nmsi_QxSZyD14AH6wrNQ5sqGe_K2m4Efy7ZaHTu2ryGMtQ@mail.gmail.com>
References: <CAKa9NmvPyvyrdbpYaHoo20yu5Gbsq1m_GYzUen2viOUZkJdQHQ@mail.gmail.com>
	<4E6DC4C1.2050804@kernel.dk>
	<CAKa9Nmsi_QxSZyD14AH6wrNQ5sqGe_K2m4Efy7ZaHTu2ryGMtQ@mail.gmail.com>
Date: Tue, 13 Sep 2011 02:04:03 -0600
Message-ID: <CAKTuRrGKODdJ9dnsfPjK82-===RYr-Js1aM5U6rOC2823n3LYw@mail.gmail.com>
Subject: Re: runtime option not working similar for all devices
From: Josh Aune <luken@omner.org>
Content-Type: multipart/alternative; boundary=0016e6d7e8c148235004acce165f
To: Vikram Seth <seth.vik@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--0016e6d7e8c148235004acce165f
Content-Type: text/plain; charset=ISO-8859-1

>
> [global]
> description=Standard Performance test
> runtime=43200
> direct=1
> filename=/dev/sdc
> numjobs=20
> group_reporting

Add time_based and it will run for the full duration specified by runtime.

Josh

>
> [test]
> rw=randread
> bs=128k
>
> Thanks
> Vikram.

--0016e6d7e8c148235004acce165f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br>&gt;<br>&gt; [global]<br>&gt; description=3DStandard Performance test<b=
r>&gt; runtime=3D43200<br>&gt; direct=3D1<br>&gt; filename=3D/dev/sdc<br>&g=
t; numjobs=3D20<br>&gt; group_reporting<br><br>Add time_based and it will r=
un for the full duration specified by runtime. <br>
<br>Josh<br><br>&gt;<br>&gt; [test]<br>&gt; rw=3Drandread<br>&gt; bs=3D128k=
<br>&gt;<br>&gt; Thanks<br>&gt; Vikram.<br>

--0016e6d7e8c148235004acce165f--


