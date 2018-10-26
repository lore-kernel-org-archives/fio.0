Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f172.google.com ([209.85.221.172]:34427 "EHLO
        mail-vk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbeJZMrh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Oct 2018 08:47:37 -0400
Received: by mail-vk1-f172.google.com with SMTP id b65-v6so2774952vkf.1
        for <fio@vger.kernel.org>; Thu, 25 Oct 2018 21:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <3AF0240C-DE31-4E79-AB21-31D04B863142@emc.com>
In-Reply-To: <3AF0240C-DE31-4E79-AB21-31D04B863142@emc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 26 Oct 2018 05:11:53 +0100
Message-ID: <CALjAwxjS4MXpf_K6mqE2vb=+sJ40iVgKQyLJ0zfEyR2JEBpfAQ@mail.gmail.com>
Subject: Re: Static linking and RDB/Rados
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark Beierl <Mark.Beierl@dell.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 26 Oct 2018 at 00:53, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>
> I=E2=80=99ve been doing some playing around with static linking and from =
the looks of it the static libraries for Rados and RDB are no longer availa=
ble.  Same goes for some of the libraries needed to enable HTTP (S3) suppor=
t.
>
> So, I don=E2=80=99t think the options for =E2=80=93build-static are valid=
 anymore.  If anyone has pointers as to how to get the static Rados or RDB =
libraries, I=E2=80=99d love to hear about it :)

You didn't mention your distro but I think in the case of curl (which
is used for the HTTP/S3 suport) it will be highly environment
dependent. For example, Ubuntu seem to ship a static version of
libcurl (https://packages.ubuntu.com/bionic/amd64/libcurl4-gnutls-dev/filel=
ist
and see libcurl-gnutls.a) but I can't see any static libcurl in
regular Fedora packages. In fact, I know that Fedora doesn't ship a
static libaio either and others have been forced to download the
source, build a private copy with a static library and then point fio
at that in they wanted such a binary on Fedora.

--=20
Sitsofe | http://sucs.org/~sits/

