Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36214 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752490AbdDCSHh (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Apr 2017 14:07:37 -0400
Received: by mail-vk0-f44.google.com with SMTP id s68so148265837vke.3
        for <fio@vger.kernel.org>; Mon, 03 Apr 2017 11:07:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6929A3FC-5D4B-4121-BC36-5E83B563CCC7@cisco.com>
References: <CA74E5D5-1CEF-4605-BE90-809B55465C79@cisco.com> <6929A3FC-5D4B-4121-BC36-5E83B563CCC7@cisco.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 3 Apr 2017 19:07:01 +0100
Message-ID: <CALjAwxidLY8Tm85P9yvUtuXwetNrr8pANz-bQab+_wNknraU5A@mail.gmail.com>
Subject: Re: fio seems to calls functions which are not defined
 (ffio_file_open, io_file_done, ...)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Scott Forman (scforman)" <scforman@cisco.com>
Cc: "andrey.v.kuzmin@gmail.com" <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 2 April 2017 at 23:11, Scott Forman (scforman) <scforman@cisco.com> wrot=
e:
>
> I see there are a number of functions that are called, but I cannot find =
where they are defined.  Some of the functions are:
> =C2=B7         fio_file_open
> =C2=B7         fio_file_done
> =C2=B7         fio_file_closing
> =C2=B7         fio_file_axmap
>
> Can you point me to where these functions are defined?

See file.h (https://github.com/axboe/fio/blob/fio-2.18/file.h#L159 )
for the FILE_FLAG_FNS macro that builds these functions.

--=20
Sitsofe | http://sucs.org/~sits/
