Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:45989 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbeCNPHD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Mar 2018 11:07:03 -0400
Received: by mail-pg0-f50.google.com with SMTP id s13so1461360pgn.12
        for <fio@vger.kernel.org>; Wed, 14 Mar 2018 08:07:03 -0700 (PDT)
From: Matt Freel <matt.freel@broadcom.com>
References: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com> <368477604.10754890.1521010004445.JavaMail.zimbra@redhat.com>
In-Reply-To: <368477604.10754890.1521010004445.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Date: Wed, 14 Mar 2018 09:07:00 -0600
Message-ID: <7d4b20a37c7c500d6565a76db6481a40@mail.gmail.com>
Subject: RE: Proper way to shut down FIO in Linux
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <evelu@redhat.com>
Cc: fio@vger.kernel.org

I'm using it to generate IO -- not necessarily as a benchmark.  I'm running
IO, taking some other measurements, then killing it to kick off a different
workload.  The time it needs to run is not constant -- it depends on a bunc=
h
of different things.

-----Original Message-----
From: Erwan Velu <evelu@redhat.com>
Sent: Wednesday, March 14, 2018 12:47 AM
To: Matt Freel <matt.freel@broadcom.com>
Cc: fio@vger.kernel.org
Subject: Re: Proper way to shut down FIO in Linux

Hey,

Why do you want to kill fio ? That sounds weird to me.

If you need to run your benchmark on constant time then use time_based &
runtime instructions.

----- Mail original -----
De: "Matt Freel" <matt.freel@broadcom.com>
=C3=80: fio@vger.kernel.org
Envoy=C3=A9: Mardi 13 Mars 2018 19:56:10
Objet: Proper way to shut down FIO in Linux

I'm using FIO to run IOs to a number of block devices.  I'm looking for the
proper way to shut down all the threads that are spawned.

I'm doing the following:

/usr/bin/pkill --signal INT fio

Most of the time this works fine, but I do have cases where some of the FIO
processes remain open.  Eventually I get a 300s timeout and then they're
killed.

A couple questions:

1.	When these threads have to be ungracefully killed, do the results
still get counted in the output file?
a.	I'm using JSON output file
2.	Is there a better way I should be killing all the threads?
--
To unsubscribe from this list: send the line "unsubscribe fio" in the body
of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
