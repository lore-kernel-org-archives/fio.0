Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:34083 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbeHAIgI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 04:36:08 -0400
Received: by mail-vk0-f49.google.com with SMTP id l143-v6so8776491vke.1
        for <fio@vger.kernel.org>; Tue, 31 Jul 2018 23:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 1 Aug 2018 07:51:27 +0100
Message-ID: <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
Subject: Re: get err 5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>, fio <fio@vger.kernel.org>

On 1 August 2018 at 07:39, Alireza Haghdoost <haghdoost@gmail.com> wrote:
> Your jobs step on the foot of each other. You can=E2=80=99t write with mu=
ltiple
> process on the same LBA of a LUN on the same time. That is why you get er=
ror
> 5 because one thread is writting an LBA and another thread modify if at t=
he
> same time. In this case either one can get unknown result.

I agree with part of this statement (unknown result in the LBA) but
I'm doubtful it would cause an error message of "I/O error". Disks
definitely do accept simultaneous write I/Os against the same LBA but
the problem becomes that in most cases the end result as to which data
the LBA will contain is undefined. It's not illegal (in the sense that
nothing prevents and nothing will error) it's just bad from a data
integrity perspective (and since this wasn't a verify job...).

--=20
Sitsofe | http://sucs.org/~sits/
