Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:34137 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932592AbdCWU7G (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Mar 2017 16:59:06 -0400
Received: by mail-ot0-f171.google.com with SMTP id a5so4172808oth.1
        for <fio@vger.kernel.org>; Thu, 23 Mar 2017 13:59:05 -0700 (PDT)
From: Jason Sirichoke <jason.sirichoke@broadcom.com>
References: <CAJAr4ZUSv8RNoiFp23WUV48CBn-Vv8qs3zczz2ZQSnBctwx=9w@mail.gmail.com>
In-Reply-To: <CAJAr4ZUSv8RNoiFp23WUV48CBn-Vv8qs3zczz2ZQSnBctwx=9w@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 23 Mar 2017 14:59:04 -0600
Message-ID: <72e659317cc3b61aaf5ad05504d83919@mail.gmail.com>
Subject: How to simulate bursty I/O traffic with fio?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

All,



I am trying to evaluate the behavior of some RAID controllers when faced
with =E2=80=9Cbursty=E2=80=9D IOs. Typically in our storage performance tes=
ting we evaluate
controllers using a steady stream of I/Os by controlling the iodepth option
and leaving the rest of the IO depth and IO rate parameters undefined so
they take the defaults. The behavior I am trying to simulate is an
application sending multiple IOs at once, retrieve + processing time and
then submitting the next group of IOs. From the fio HOWTO document it looks
like the best way to do this is:



iodepth =3D (number of I/Os to send at once, i.e 32)

iodepth_batch_submit =3D 0 (submit the full set of iodepth IOs at once)

iodepth_batch_complete_min =3D 1

iodepth_batch_complete_max =3D iodepth (fio should try to retrieve at least=
 a
single IO and up to the iodepth number of IOs)

iodepth_low =3D default (always fill the queue)



thinktime =3D number of milliseconds between each burst

thinktime_blocks =3D ? (This is where I was confused=E2=80=A6do I set this =
to the
iodepth so it will burst all iodepth IOs before waiting thinktime
milliseconds? Or should this be set to 1 because I want the thinktime to
occur after a single batch of IOs?)



So I=E2=80=99m hoping the end behavior is along the lines of:



=C2=B7         Send 32 IOs

=C2=B7         Retrieve all 32 IOs

=C2=B7         Wait 5 ms  (will it continue to wait if all IOs from the pre=
vious
batch have not been retrieved yet?)

=C2=B7         Send the next 32 IOs, repeat



I did read the HOWTO  couple of times but just wanted clarification since I
haven=E2=80=99t used fio in this manner before and did not want to assume m=
y
interpretation is correct. Jens indicated this is the best place to ask so
figured I would give it a shot. Thanks for the help in advance.


--

Jason Sirichoke

Performance Analyst

Datacenter Solutions Group (DCSG)
Broadcom Ltd

Phone: +1.719.533.7943
