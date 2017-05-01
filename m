Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34382 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2999706AbdEAGY7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 1 May 2017 02:24:59 -0400
Received: by mail-ua0-f169.google.com with SMTP id g49so2665122uaa.1
        for <fio@vger.kernel.org>; Sun, 30 Apr 2017 23:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E09D8C27-9FE6-4BD6-B751-92BD34AD66D5@asu.edu>
References: <E09D8C27-9FE6-4BD6-B751-92BD34AD66D5@asu.edu>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 1 May 2017 07:24:28 +0100
Message-ID: <CALjAwxhV0TgvwM1xhgY=iJV7E5-p+wJ7GCiNRMg4MUO4L6EBGQ@mail.gmail.com>
Subject: Re: Compiling on Android using ndk-r15 or higher
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Omri Mor <omor1@asu.edu>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 29 April 2017 at 00:01, Omri Mor <omor1@asu.edu> wrote:
> Description
> Building using ndk-r15 will result in a build failure:
> ./os/os-android.h:87:7: error: redefinition of 'key' with a different typ=
e: 'char [11]' vs 'key_t' (aka 'int=E2=80=99)

I'm not sure why this took so long for this to be deliver to GMail but
for the benefit of those browsing the mailing list Omri submitted a
fix for this in
https://github.com/axboe/fio/pull/350/commits/91f643461babe7ee83870e28f6b61=
20d2b52c742
.

--=20
Sitsofe | http://sucs.org/~sits/
