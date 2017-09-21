Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:52690 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdIUO60 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 21 Sep 2017 10:58:26 -0400
Received: by mail-io0-f178.google.com with SMTP id i197so11420233ioe.9
        for <fio@vger.kernel.org>; Thu, 21 Sep 2017 07:58:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiEN1MRuV5K_zn3sgwpaqCzPcLFsfDV6T4FaxvOja_X8Q@mail.gmail.com>
References: <CAL3rD49jNs3yH-yNZfmO49YffjSogNtG+GQZq0cch5uzS4nX7A@mail.gmail.com>
 <CALjAwxiEN1MRuV5K_zn3sgwpaqCzPcLFsfDV6T4FaxvOja_X8Q@mail.gmail.com>
From: shawn tim <tontinme@gmail.com>
Date: Thu, 21 Sep 2017 22:58:25 +0800
Message-ID: <CAL3rD4-Y1V3qpPzGVyW00Ud0Fn2rzCBf5hNsbWO0ipmso_YbjA@mail.gmail.com>
Subject: Re: fio rbd engine cannot specify the location of ceph.conf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Sorry for my late reply

Yes, $CEPH_CONF.

In my opinion:
1. ceph client (like rbd, ceph, etc) has the option: --conf
2. I have two or more ceph cluster in out environment. like Cluster A,
Cluster B, Cluster C.
But I only have one fio client server.
when doing benchmark using fio, I must modify ceph.conf to connect to
different cluster
3. one more thing. When benchmark Ceph Cluster A, I can use Cluster B
as fio client server If fio can use clusterconf option


Sitsofe Wheeler <sitsofe@gmail.com>=E4=BA=8E2017=E5=B9=B49=E6=9C=8818=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=887:29=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> On 15 September 2017 at 09:04, shawn tim <tontinme@gmail.com> wrote:
> >
> > Is the fio rbd engine support clusterconf option?
> >
> > 01:~# fio --enghelp=3Drbd
> > clustername             : Cluster name for ceph
> > rbdname                 : RBD name for RBD engine
> > pool                    : Name of the pool hosting the RBD for the RBD =
engine
> > clientname              : Name of the ceph client to access the RBD
> > for the RBD engine
> > busy_poll               : Busy poll for completions instead of sleeping
> >
> > In my environment, the ceph.conf is not in /etc/ceph/, and clustername
> > is 'ceph'.
> > But fio seems failed if there is no /etc/ceph/ceph.conf.
>
> Isn't the file used controlled by the $CEPH_CONF environment variable
> (http://docs.ceph.com/docs/hammer/rados/configuration/ceph-conf/ )
> when you want a non-standard location?
>
> --
> Sitsofe | http://sucs.org/~sits/
